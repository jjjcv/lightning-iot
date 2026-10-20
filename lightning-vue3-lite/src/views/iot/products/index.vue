<template>
  <div class="app-container iot-asset-page">
    <IoTWorkspaceHeader
      title="产品中心"
      eyebrow="IOT PRODUCT CATALOG"
      description="统一管理设备产品、接入协议与物模型，让设备接入从标准定义开始。"
      :stats="productStats"
    >
      <template #icon><el-icon><Box /></el-icon></template>
      <template #actions>
        <el-button icon="Refresh" @click="getList">刷新数据</el-button>
        <el-button type="primary" icon="Plus" @click="handleAdd" v-hasPermi="['iot:products:add']">
          创建产品
        </el-button>
      </template>
    </IoTWorkspaceHeader>

    <el-form
      v-show="showSearch"
      ref="queryRef"
      :model="queryParams"
      :inline="true"
      label-width="auto"
      class="asset-filter-panel"
    >
      <el-form-item label="产品名称" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入产品名称" clearable style="width: 200px"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="产品说明" prop="description">
        <el-input v-model="queryParams.description" placeholder="请输入产品说明" clearable style="width: 200px"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="传输协议" prop="protocolId">
        <el-select v-model="queryParams.protocolId" placeholder="请选择传输协议类型" clearable style="width: 200px">
          <el-option v-for="protocol in protocolsList" :key="protocol.value" :label="protocol.label"
            :value="protocol.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="产品分类" prop="productCategoryId">
        <el-tree-select
          v-model="queryParams.productCategoryId"
          :data="categoryOptions"
          :props="{ value: 'categoryId', label: 'categoryName', children: 'children' }"
          value-key="categoryId"
          placeholder="全部分类"
          clearable
          check-strictly
          style="width: 200px"
        />
      </el-form-item>
      <el-form-item label="标签" prop="tagIds">
        <TagSelect v-model="queryParams.tagIds" placeholder="全部标签" style="width: 240px" />
      </el-form-item>
      <el-form-item label="标签匹配" prop="tagMatchMode">
        <el-select v-model="queryParams.tagMatchMode" style="width: 140px">
          <el-option label="满足任意标签" value="any" />
          <el-option label="满足全部标签" value="all" />
        </el-select>
      </el-form-item>
      <el-form-item label="启停状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="全部状态" clearable style="width: 140px">
          <el-option label="已启用" value="enable" />
          <el-option label="已停用" value="disable" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <section class="asset-table-panel">
      <div class="asset-table-heading">
        <div>
          <span class="asset-table-title">产品列表</span>
          <span class="asset-table-caption">共 {{ total }} 个产品，当前展示 {{ productsList.length }} 个</span>
        </div>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
      </div>

    <el-row :gutter="10" class="mb8 asset-toolbar">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['iot:products:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['iot:products:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['iot:products:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['iot:products:export']">产品导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="Upload" @click="handleImport"
          v-hasPermi="['iot:products:add']">产品导入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleTemplateExport"
          v-hasPermi="['iot:productTemplates:export']">产品物模型导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="Upload" @click="handleTemplateImport"
          v-hasPermi="['iot:productTemplates:add']">产品物模型导入</el-button>
      </el-col>
    </el-row>

    <el-table
      v-loading="loading"
      :data="productsList"
      row-key="id"
      @selection-change="handleSelectionChange"
      @row-dblclick="handleConfigUpdate"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="产品信息" prop="name" min-width="230">
        <template #default="scope">
          <div class="product-identity">
            <el-image
              v-if="scope.row.photoUrl"
              :src="scope.row.photoUrl"
              :preview-src-list="[scope.row.photoUrl]"
              preview-teleported
              fit="cover"
              class="product-avatar"
            />
            <span v-else class="product-avatar is-placeholder"><el-icon><Box /></el-icon></span>
            <div>
              <strong>{{ scope.row.name || '未命名产品' }}</strong>
              <small>{{ scope.row.id }}<template v-if="scope.row.description"> · {{ scope.row.description }}</template></small>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="产品类型" align="center" prop="productCategoryId">
        <template #default="scope">
          <dict-tag :options="categoryList" :value="String(scope.row.productCategoryId)" />
        </template>
      </el-table-column>
      <el-table-column label="传输协议" align="center" prop="protocolId">
        <template #default="scope">
          <dict-tag :options="protocolsList" :value="scope.row.protocolId" />
        </template>
      </el-table-column>
      <el-table-column label="数据存储间隔(ms)" align="center" prop="storageInterval" width="130" />
      <el-table-column label="数据过期时间(ms)" align="center" prop="dataExpiration" width="130" />
      <el-table-column label="设备类型" align="center" prop="deviceType">
        <template #default="scope">
          <dict-tag :options="device_type" :value="scope.row.deviceType" />
        </template>
      </el-table-column>
      <el-table-column prop="status" align="center" label="启停状态" width="100">
        <template #default="scope">
          <el-switch v-model="scope.row.status" active-value="enable" inactive-value="disable" inline-prompt
            active-text="启" inactive-text="停" :loading="isStatusUpdating(scope.row.id)"
            :disabled="isStatusUpdating(scope.row.id)" @change="handleSwitchChange(scope.row)" />
        </template>
      </el-table-column>
      <el-table-column label="标签" min-width="180">
        <template #default="scope">
          <el-space v-if="scope.row.tags?.length" wrap>
            <el-tag v-for="tag in scope.row.tags" :key="tag.tagId" size="small" effect="plain">{{ tag.tagName }}</el-tag>
          </el-space>
          <span v-else>—</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="260" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Setting" @click="handleConfigUpdate(scope.row)"
            v-hasPermi="['iot:products:edit']">配置详情</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['iot:products:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['iot:products:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />
    </section>

    <!-- 添加或修改产品对话框 -->
    <el-dialog :title="title" v-model="open" width="680px" destroy-on-close append-to-body
      :close-on-click-modal="false" class="product-editor-dialog">
      <div class="product-editor-intro">
        <span><el-icon><Box /></el-icon></span>
        <div>
          <strong>{{ data.operator === 'edit' ? '维护产品接入定义' : '创建标准化产品' }}</strong>
          <p>产品标识创建后不可修改，将作为设备接入和物模型数据的业务前缀。</p>
        </div>
      </div>
      <el-form :model="form" label-position="top" :rules="rules" ref="productEditorRef">
        <div class="product-form-section"><span>01</span>身份与分类</div>
        <el-row :gutter="18">
          <el-col :xs="24" :sm="12">
            <el-form-item label="产品 ID" prop="id">
              <el-input v-model="form.id" placeholder="例如：smart_meter"
                :disabled="data.operator === 'edit'" maxlength="64" />
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12">
            <el-form-item label="产品名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入产品名称" maxlength="50" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12">
            <el-form-item label="产品分类" prop="productCategoryId">
              <el-tree-select v-model="form.productCategoryId" :data="categoryOptions"
                :props="{ value: 'categoryId', label: 'categoryName', children: 'children' }" value-key="categoryId"
                placeholder="请选择产品分类" check-strictly style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12">
            <el-form-item label="设备类型" prop="deviceType">
              <el-select v-model="form.deviceType" placeholder="请选择设备类型" style="width: 100%"
                @change="handleDeviceTypeChange">
                <el-option v-for="dict in device_type" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="标签" prop="tagIds">
          <TagSelect v-model="form.tagIds" />
          <span class="field-help">移除所选标签即可解绑；清空后保存将解除全部标签。</span>
        </el-form-item>
        <div class="product-form-section"><span>02</span>接入方式</div>
        <el-form-item v-if="form.deviceType === DIRECT_DEVICE_TYPE" label="消息解析器" prop="transportCodecId">
          <el-select v-model="form.transportCodecId" placeholder="请选择消息解析器" style="width: 100%">
            <el-option v-for="codec in codecList" :key="codec.value" :label="codec.label"
              :value="codec.value" />
          </el-select>
          <span class="field-help">直连设备默认通过 MQTT 接入。</span>
        </el-form-item>
        <el-form-item v-else label="传输协议" prop="protocolId">
          <el-select v-model="form.protocolId" placeholder="请选择传输协议类型" style="width: 100%">
            <el-option v-for="protocol in protocolsList" :key="protocol.value" :label="protocol.label"
              :value="protocol.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="产品说明" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="描述产品用途、接入场景或设备能力"
            :rows="3" show-word-limit maxlength="200" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancel">取 消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitForm('productEditorRef')">
            {{ data.operator === 'edit' ? '保存修改' : '创建产品' }}
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 产品详情 / 配置对话框 -->
    <el-dialog
      v-model="openDetail"
      width="1180px"
      append-to-body
      destroy-on-close
      :close-on-click-modal="false"
      class="product-workspace-dialog"
    >
      <template #header>
        <div class="product-dialog-title">
          <span class="product-dialog-icon"><el-icon><Box /></el-icon></span>
          <div>
            <span class="section-eyebrow">PRODUCT DEFINITION WORKSPACE</span>
            <h2>{{ form.name || '产品详情' }}</h2>
            <p>{{ form.id }} · {{ form.description || '管理基础参数与产品物模型契约' }}</p>
          </div>
          <el-tag :type="form.status === 'enable' ? 'success' : 'info'" effect="dark" round>
            {{ form.status === 'enable' ? '已启用' : '已停用' }}
          </el-tag>
        </div>
      </template>

      <section class="product-profile-strip">
        <article>
          <span>产品分类</span>
          <strong><dict-tag :options="categoryList" :value="String(form.productCategoryId)" /></strong>
        </article>
        <article>
          <span>设备类型</span>
          <strong><dict-tag :options="device_type" :value="form.deviceType" /></strong>
        </article>
        <article>
          <span>传输协议</span>
          <strong><dict-tag :options="protocolsList" :value="form.protocolId" /></strong>
        </article>
        <article>
          <span>创建时间</span>
          <strong>{{ parseTime(form.createTime, '{y}-{m}-{d} {h}:{i}') || '—' }}</strong>
        </article>
        <article>
          <span>更新时间</span>
          <strong>{{ parseTime(form.updateTime, '{y}-{m}-{d} {h}:{i}') || '—' }}</strong>
        </article>
      </section>

      <el-tabs v-model="activeTab" class="product-workspace-tabs">
        <el-tab-pane label="基础配置" name="basic">
          <div class="config-section-head">
            <div>
              <h3>数据生命周期</h3>
              <p>控制设备数据的入库频率和平台保留时长。</p>
            </div>
          </div>
          <el-form :model="form" label-position="top" :rules="rules" ref="productBasicRef" class="product-basic-form">
            <el-row :gutter="18">
              <el-col :xs="24" :sm="12">
                <el-form-item label="数据存储间隔（毫秒）" prop="storageInterval">
                  <el-input-number v-model="form.storageInterval" :min="1" controls-position="right" />
                  <span class="field-help">设备数据写入存储的最小时间间隔。</span>
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="数据过期时间（毫秒）" prop="dataExpiration">
                  <el-input-number v-model="form.dataExpiration" :min="0" controls-position="right" />
                  <span class="field-help">设置为 0 时由平台默认策略管理。</span>
                </el-form-item>
              </el-col>
            </el-row>
            <el-button type="primary" icon="Check" :loading="submitting"
              @click="submitForm('productBasicRef')">保存基础配置</el-button>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="物模型配置" name="model">
          <ProductConfig v-if="openDetail && activeTab === 'model'" :productId="form.id" />
        </el-tab-pane>
      </el-tabs>
    </el-dialog>

    <!-- 产品导入对话框 -->
    <excel-import-dialog
      ref="importProductRef"
      title="产品导入"
      action="/iot/products/importData"
      template-action="/iot/products/importTemplate"
      template-file-name="products_template"
      update-support-label="是否更新已经存在的产品数据"
      @success="getList"
    />

    <!-- 产品物模型导入对话框 -->
    <excel-import-dialog
      ref="importTemplateRef"
      title="产品物模型导入"
      action="/iot/productTemplates/importData"
      template-action="/iot/productTemplates/importTemplate"
      template-file-name="productTemplates_template"
      update-support-label="是否更新已经存在的产品物模型数据"
      @success="getList"
    />
  </div>
</template>

<script setup name="Products">
import { listProducts, getProducts, delProducts, addProducts, updateProducts, updateProductStatus } from "@/api/iot/products";
import { listAllProtocol } from "@/api/iot/protocol";
import { listAllTransparentCodec } from "@/api/iot/transparentCodec";
import { listProductCategories } from "@/api/iot/productCategories";
import ProductConfig from "@/views/iot/products/ProductConfig.vue";
import ExcelImportDialog from "@/components/ExcelImportDialog";
import IoTWorkspaceHeader from "@/components/IoTWorkspaceHeader";
import TagSelect from "@/components/TagSelect/index.vue";

const { proxy } = getCurrentInstance();
const { device_type } = proxy.useDict('device_type');

const DIRECT_DEVICE_TYPE = 'direct';
const MQTT_PROTOCOL_ID = 'mqtt';

const protocolsList = ref([]);
const codecList = ref([]);
const categoryList = ref([]);
const categoryOptions = ref([]);

const productsList = ref([]);
const open = ref(false);
const openDetail = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
const activeTab = ref("basic");
const submitting = ref(false);
const statusUpdatingIds = ref(new Set());

const productStats = computed(() => {
  const enabled = productsList.value.filter(item => item.status === "enable").length;
  const protocols = new Set(productsList.value.map(item => item.protocolId).filter(Boolean)).size;
  const deviceTypes = new Set(productsList.value.map(item => item.deviceType).filter(Boolean)).size;
  return [
    { label: "产品总数", value: total.value, icon: "Box", hint: "产品目录资产" },
    { label: "当前页启用", value: enabled, icon: "CircleCheck", tone: "success", hint: "可正常接入" },
    { label: "协议覆盖", value: protocols, icon: "Connection", hint: "当前页协议类型" },
    { label: "设备类型", value: deviceTypes, icon: "Grid", tone: "warning", hint: "当前页类型数" },
  ];
});

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    tagIds: [],
    tagMatchMode: "any",
    name: null,
    photoUrl: null,
    description: null,
    productCategoryId: null,
    protocolId: null,
    transportCodecId: null,
    storageInterval: null,
    dataExpiration: null,
    deviceType: null,
    status: "enable",
  },
  rules: {
    id: [
      { required: true, message: "请输入产品 ID", trigger: "blur" },
      { pattern: /^[A-Za-z0-9_.-]{2,64}$/, message: "仅支持字母、数字、点、横线和下划线", trigger: "blur" },
    ],
    name: [{ required: true, message: "请输入产品名称", trigger: ["blur", "change"] }],
    productCategoryId: [{ required: true, message: "请选择产品类型", trigger: ["blur", "change"] }],
    deviceType: [{ required: true, message: "请选择设备类型", trigger: "change" }],
    protocolId: [{ required: true, message: "请选择传输协议", trigger: "change" }],
    transportCodecId: [{ required: true, message: "请选择消息解析器", trigger: "change" }],
    description: [{ message: "请输入产品说明", trigger: ["blur", "change"] }],
    storageInterval: [
      { required: true, message: "请输入数据存储间隔", trigger: "blur" },
      {
        validator: (rule, value, callback) => {
          const numberValue = Number(value);
          if (value !== null && value !== '' && (!Number.isInteger(numberValue) || numberValue <= 0)) {
            callback(new Error("请输入大于 0 的整数"));
          } else {
            callback();
          }
        },
        trigger: "blur"
      }
    ],
    dataExpiration: [
      { required: true, message: "请输入数据过期时间", trigger: "blur" },
      {
        validator: (rule, value, callback) => {
          const numberValue = Number(value);
          if (value !== null && value !== '' && (!Number.isInteger(numberValue) || numberValue < 0)) {
            callback(new Error("请输入不小于 0 的整数"));
          } else {
            callback();
          }
        },
        trigger: "blur"
      }
    ]
  },
  operator: ""
});

const { queryParams, form, rules } = toRefs(data);

function isStatusUpdating(id) {
  return statusUpdatingIds.value.has(id);
}

/** 启停状态切换 */
function handleSwitchChange(row) {
  const enable = row.status === "enable";
  statusUpdatingIds.value = new Set(statusUpdatingIds.value).add(row.id);
  updateProductStatus(row.id, row.status)
    .then(() => {
      proxy.$modal.msgSuccess(enable ? "启用成功" : "停用成功");
    })
    .catch(() => {
      row.status = enable ? "disable" : "enable";
    })
    .finally(() => {
      const next = new Set(statusUpdatingIds.value);
      next.delete(row.id);
      statusUpdatingIds.value = next;
    });
}

/** 查询产品信息列表 */
function getList() {
  loading.value = true;
  listProducts(queryParams.value)
    .then(response => {
      productsList.value = Array.isArray(response?.rows) ? response.rows : [];
      total.value = Number(response?.total || 0);
    })
    .catch(error => {
      productsList.value = [];
      total.value = 0;
      console.error("获取产品列表失败:", error);
    })
    .finally(() => {
      loading.value = false;
    });
}

/** 获取协议列表 */
function fetchProtocolList() {
  listAllProtocol().then(response => {
    protocolsList.value = (Array.isArray(response?.data) ? response.data : []).map(item => ({
      label: item.name,
      value: item.id,
      elTagType: 'default'
    }));
  }).catch(error => {
    console.error("获取协议列表失败:", error);
  });
}

/** 获取全部消息解析器 */
function fetchCodecList() {
  listAllTransparentCodec().then(response => {
    codecList.value = (Array.isArray(response?.data) ? response.data : []).map(item => ({
      label: item.name,
      value: item.id
    }));
  }).catch(error => {
    codecList.value = [];
    console.error("获取消息解析器列表失败:", error);
  });
}

/** 获取产品类型列表 */
function fetchCategoryList() {
  listProductCategories().then(response => {
    const categories = Array.isArray(response?.data) ? response.data : [];
    categoryOptions.value = proxy.handleTree(categories, "categoryId");
    categoryList.value = categories.map(item => ({
      label: item.categoryName,
      value: String(item.categoryId),
      elTagType: 'default'
    }));
  }).catch(error => {
    categoryOptions.value = [];
    categoryList.value = [];
    console.error("获取产品分类失败:", error);
  });
}

/** 取消按钮 */
function cancel() {
  open.value = false;
  reset();
}

/** 表单重置 */
function reset() {
  form.value = {
    tagIds: [],
    id: null,
    name: null,
    photoUrl: null,
    description: null,
    productCategoryId: null,
    protocolId: null,
    transportCodecId: null,
    storageInterval: null,
    dataExpiration: null,
    deviceType: null,
    status: "enable",
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  };
  proxy.resetForm("productEditorRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1;
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef");
  handleQuery();
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 设备类型变化：直连设备固定使用 MQTT，其他类型继续选择传输协议 */
function handleDeviceTypeChange(deviceType) {
  if (deviceType === DIRECT_DEVICE_TYPE) {
    form.value.protocolId = MQTT_PROTOCOL_ID;
  } else {
    form.value.protocolId = null;
    form.value.transportCodecId = null;
  }
  proxy.$nextTick(() => {
    proxy.$refs.productEditorRef?.clearValidate(['protocolId', 'transportCodecId']);
  });
}

/** 新增按钮操作 */
function handleAdd() {
  data.operator = "add";
  reset();
  open.value = true;
  title.value = "添加产品信息";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  data.operator = "edit";
  reset();
  const _id = row?.id || ids.value[0];
  if (!_id) return;
  getProducts(_id).then(response => {
    form.value = normalizeProduct(response.data);
    open.value = true;
    title.value = "修改产品信息";
  });
}

/** 配置详情按钮操作 */
function handleConfigUpdate(row) {
  data.operator = "edit";
  reset();
  const _id = row?.id || ids.value[0];
  if (!_id) return;
  getProducts(_id).then(response => {
    form.value = normalizeProduct(response.data);
    activeTab.value = "basic";
    openDetail.value = true;
  });
}

function normalizeProduct(product) {
  const normalized = {
    ...product,
    storageInterval: product?.storageInterval == null ? null : Number(product.storageInterval),
    dataExpiration: product?.dataExpiration == null ? null : Number(product.dataExpiration),
  };
  if (normalized.deviceType === DIRECT_DEVICE_TYPE) {
    normalized.protocolId = MQTT_PROTOCOL_ID;
  }
  return normalized;
}

/** 提交按钮 */
function submitForm(refName) {
  const formRef = proxy.$refs[refName];
  if (!formRef || submitting.value) return;
  formRef.validate(valid => {
    if (!valid) return;
    const isEdit = data.operator === "edit";
    submitting.value = true;
    const action = isEdit ? updateProducts(form.value) : addProducts(form.value);
    action
      .then(() => {
        proxy.$modal.msgSuccess(isEdit ? "修改成功" : "新增成功");
        open.value = false;
        openDetail.value = false;
        getList();
      })
      .finally(() => {
        submitting.value = false;
      });
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row?.id || ids.value;
  if (!_ids || (Array.isArray(_ids) && !_ids.length)) return;
  proxy.$modal.confirm('是否确认删除产品信息编号为"' + _ids + '"的数据项？').then(function () {
    return delProducts(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => { });
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/products/export', {
    ...queryParams.value
  }, `products_${new Date().getTime()}.xlsx`)
}

/** 产品导入按钮操作 */
function handleImport() {
  proxy.$refs["importProductRef"].open();
}

/** 产品物模型导入按钮操作 */
function handleTemplateImport() {
  proxy.$refs["importTemplateRef"].open();
}

/** 产品物模型导出按钮操作 */
function handleTemplateExport() {
  proxy.download('iot/productTemplates/export', {}, `productTemplates_${new Date().getTime()}.xlsx`)
}

fetchProtocolList();
fetchCodecList();
fetchCategoryList();
getList();
</script>

<style lang="scss" scoped>
.product-identity {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0;
}

.product-identity > div {
  min-width: 0;
}

.product-identity strong,
.product-identity small {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-identity strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.product-identity small {
  margin-top: 4px;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.product-avatar {
  flex: 0 0 42px;
  width: 42px;
  height: 42px;
  border: 1px solid var(--ui-border);
  border-radius: 11px;
}

.product-avatar.is-placeholder {
  display: grid;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 19px;
  background: linear-gradient(135deg,
    color-mix(in srgb, var(--el-color-primary) 13%, var(--ui-surface)),
    var(--ui-surface-soft));
}
</style>

<style lang="scss">
.product-editor-dialog,
.product-workspace-dialog {
  overflow: hidden;
  border-radius: 16px;
}

.product-editor-dialog .el-dialog__header,
.product-workspace-dialog .el-dialog__header {
  margin: 0;
  padding: 20px 24px;
  border-bottom: 1px solid var(--ui-border);
}

.product-editor-dialog .el-dialog__body {
  padding: 22px 24px 10px;
}

.product-editor-dialog .el-dialog__footer {
  padding: 14px 24px 20px;
}

.product-editor-intro {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
  padding: 13px 15px;
  background: linear-gradient(120deg,
    color-mix(in srgb, var(--el-color-primary) 8%, var(--ui-surface-soft)),
    var(--ui-surface-soft));
  border: 1px solid var(--ui-border);
  border-radius: 11px;
}

.product-editor-intro > span {
  display: grid;
  flex: 0 0 38px;
  width: 38px;
  height: 38px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 18px;
  background: var(--ui-surface);
  border-radius: 10px;
}

.product-editor-intro strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.product-editor-intro p {
  margin: 3px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.product-form-section {
  display: flex;
  align-items: center;
  gap: 9px;
  margin: 2px 0 15px;
  color: var(--ui-text-primary);
  font-size: 13px;
  font-weight: 700;
}

.product-form-section:not(:first-of-type) {
  margin-top: 5px;
}

.product-form-section span {
  display: inline-grid;
  width: 25px;
  height: 25px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 10px;
  background: color-mix(in srgb, var(--el-color-primary) 9%, transparent);
  border-radius: 7px;
}

.product-workspace-dialog .el-dialog__body {
  padding: 0 24px 24px;
}

.product-dialog-title {
  display: flex;
  align-items: center;
  gap: 14px;
  padding-right: 42px;
}

.product-dialog-title > div {
  flex: 1;
  min-width: 0;
}

.product-dialog-icon {
  display: grid;
  flex: 0 0 44px;
  width: 44px;
  height: 44px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 21px;
  background: color-mix(in srgb, var(--el-color-primary) 10%, var(--ui-surface));
  border: 1px solid color-mix(in srgb, var(--el-color-primary) 18%, var(--ui-border));
  border-radius: 12px;
}

.product-dialog-title .section-eyebrow {
  display: block;
  margin-bottom: 3px;
  color: var(--el-color-primary);
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 1.2px;
}

.product-dialog-title h2 {
  margin: 0;
  color: var(--ui-text-primary);
  font-size: 18px;
  line-height: 1.25;
}

.product-dialog-title p {
  overflow: hidden;
  margin: 4px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-profile-strip {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  margin: 0 -24px;
  background: var(--ui-surface-soft);
  border-bottom: 1px solid var(--ui-border);
}

.product-profile-strip article {
  min-width: 0;
  padding: 14px 18px;
  border-right: 1px solid var(--ui-border);
}

.product-profile-strip article:last-child {
  border-right: 0;
}

.product-profile-strip span,
.product-profile-strip strong {
  display: block;
}

.product-profile-strip span {
  margin-bottom: 6px;
  color: var(--ui-text-secondary);
  font-size: 10px;
}

.product-profile-strip strong {
  overflow: hidden;
  color: var(--ui-text-primary);
  font-size: 12px;
  font-weight: 650;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-workspace-tabs {
  margin-top: 8px;
}

.product-workspace-tabs > .el-tabs__header {
  margin-bottom: 16px;
}

.product-workspace-tabs .el-tabs__item {
  height: 48px;
  font-weight: 650;
}

.config-section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}

.config-section-head h3 {
  margin: 0;
  color: var(--ui-text-primary);
  font-size: 15px;
}

.config-section-head p {
  margin: 4px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.product-basic-form {
  padding: 18px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 12px;
}

.product-basic-form .el-input-number {
  width: 100%;
}

.product-basic-form .field-help {
  display: block;
  margin-top: 5px;
  color: var(--ui-text-secondary);
  font-size: 10px;
  line-height: 1.45;
}

@media (max-width: 900px) {
  .product-workspace-dialog {
    width: calc(100vw - 28px) !important;
  }

  .product-profile-strip {
    grid-template-columns: repeat(2, 1fr);
  }

  .product-profile-strip article:nth-child(2n) {
    border-right: 0;
  }
}

@media (max-width: 640px) {
  .product-editor-dialog {
    width: calc(100vw - 28px) !important;
  }

  .product-dialog-title .el-tag {
    display: none;
  }

  .product-profile-strip {
    grid-template-columns: 1fr;
  }

  .product-profile-strip article {
    border-right: 0;
  }
}
</style>
