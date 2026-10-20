<template>
  <div class="app-container iot-asset-page">
    <IoTWorkspaceHeader
      title="设备中心"
      eyebrow="CONNECTED DEVICE OPERATIONS"
      description="集中查看设备连接、归属关系与实时数据，快速完成接入、绑定和批量控制。"
      :stats="deviceStats"
    >
      <template #icon><el-icon><Cpu /></el-icon></template>
      <template #actions>
        <el-button type="primary" icon="Plus" @click="handleAdd" v-hasPermi="['iot:devices:add']">
          接入设备
        </el-button>
      </template>
    </IoTWorkspaceHeader>

    <!-- 查询区域 -->
    <el-form
      v-show="showSearch"
      ref="queryRef"
      :model="queryParams"
      :inline="true"
      label-width="100px"
      class="asset-filter-panel"
    >
      <el-form-item label="设备名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备别名" prop="alias">
        <el-input
          v-model="queryParams.alias"
          placeholder="请输入设备别名"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="所属产品" prop="productId">
        <el-select
          v-model="queryParams.productId"
          placeholder="请选择产品"
          clearable
          @keyup.enter="handleQuery"
        >
          <el-option
            v-for="item in productsList"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="所属网关" prop="gatewayId">
        <el-select
          v-model="queryParams.gatewayId"
          placeholder="请选择所属网关"
          clearable
          @keyup.enter="handleQuery"
        >
          <el-option
            v-for="item in edgeDeviceList"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
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
      <el-form-item label="连接状态" prop="linkStatus">
        <el-select v-model="queryParams.linkStatus" placeholder="全部状态" clearable>
          <el-option
            v-for="dict in link_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态变更时间" prop="statusTime">
        <el-date-picker
          clearable
          v-model="queryParams.statusTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="选择状态变更时间"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <section class="asset-table-panel">
      <div class="asset-table-heading">
        <div>
          <span class="asset-table-title">设备列表</span>
          <span class="asset-table-caption">共 {{ total }} 台设备，当前展示 {{ devicesList.length }} 台</span>
        </div>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
      </div>

    <!-- 操作工具栏 -->
    <el-row :gutter="10" class="mb8 asset-toolbar">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['iot:devices:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:devices:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:devices:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:devices:export']"
        >设备导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="Upload"
          @click="handleImport"
          v-hasPermi="['iot:devices:add']"
        >设备导入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleBindingExport"
          v-hasPermi="['iot:binding:export']"
        >绑点导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="Upload"
          @click="handleBindingImport"
          v-hasPermi="['iot:binding:add']"
        >绑点导入</el-button>
      </el-col>
    </el-row>

    <!-- 设备列表 -->
    <el-table
      v-loading="loading"
      :data="devicesList"
      @selection-change="handleSelectionChange"
      border
      stripe
      row-key="id"
      @row-dblclick="handleDetail"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="设备信息" prop="name" min-width="210">
        <template #default="scope">
          <div class="device-identity">
            <span class="device-identity-icon"><el-icon><Cpu /></el-icon></span>
            <div>
              <strong>{{ scope.row.name || '未命名设备' }}</strong>
              <small>{{ scope.row.id }}<template v-if="scope.row.alias"> · {{ scope.row.alias }}</template></small>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="所属产品" align="center" prop="productId" min-width="120">
        <template #default="scope">
          <dict-tag :options="productsList" :value="String(scope.row.productId)" :show-value="false" />
        </template>
      </el-table-column>
      <el-table-column label="所属网关" align="center" prop="gatewayId" min-width="120">
        <template #default="scope">
          <dict-tag :options="edgeDeviceList" :value="String(scope.row.gatewayId)" :show-value="false" />
        </template>
      </el-table-column>
      <el-table-column label="设备类型" align="center" prop="deviceType" width="100">
        <template #default="scope">
          <dict-tag :options="device_type" :value="String(scope.row.deviceType)" />
        </template>
      </el-table-column>
      <el-table-column label="连接状态" align="center" prop="linkStatus" width="110">
        <template #default="scope">
          <span class="connection-state" :class="`is-${scope.row.linkStatus || 'unknown'}`">
            <i></i>{{ getStatusLabel(scope.row.linkStatus) }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="状态变更时间" align="center" prop="statusTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.statusTime, '{y}-{m}-{d}') }}</span>
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
      <el-table-column label="操作" align="center" width="280" fixed="right">
        <template #default="scope">
          <el-button
            link
            type="primary"
            icon="View"
            @click="handleDetail(scope.row)"
            v-hasPermi="['iot:devices:edit']"
          >设备详情</el-button>
          <el-button
            link
            type="success"
            icon="Edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['iot:devices:edit']"
          >修改</el-button>
          <el-button
            link
            type="danger"
            icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['iot:devices:remove']"
          >删除</el-button>
        </template>
      </el-table-column>

      <!-- 空状态 -->
      <template #empty>
        <el-empty :description="loading ? '加载中...' : '暂无设备数据'" />
      </template>
    </el-table>

    <!-- 分页 -->
    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />
    </section>

    <!-- ========== 设备详情对话框 ========== -->
    <el-dialog
      v-model="openDetail"
      width="1180px"
      append-to-body
      :close-on-click-modal="false"
      destroy-on-close
      class="device-workspace-dialog"
    >
      <template #header>
        <div class="device-dialog-title">
          <span class="device-dialog-icon"><el-icon><Cpu /></el-icon></span>
          <div>
            <span class="section-eyebrow">DEVICE OPERATIONS WORKSPACE</span>
            <h2>{{ form.name || '设备详情' }}</h2>
            <p>{{ form.id }} · {{ form.description || '查看实时属性、历史趋势与采集点绑定' }}</p>
          </div>
          <el-tag :type="getStatusType(form.linkStatus)" effect="dark" round>
            {{ getStatusLabel(form.linkStatus) }}
          </el-tag>
        </div>
      </template>

      <section class="device-profile-strip">
        <article>
          <span class="profile-label">所属产品</span>
          <strong><dict-tag :options="productsList" :value="String(form.productId)" :show-value="false" /></strong>
        </article>
        <article>
          <span class="profile-label">设备类型</span>
          <strong>
              <dict-tag :options="device_type" :value="String(form.deviceType)" />
          </strong>
        </article>
        <article>
          <span class="profile-label">所属网关</span>
          <strong>
              <dict-tag :options="edgeDeviceList" :value="String(form.gatewayId)" :show-value="false" />
          </strong>
        </article>
        <article>
          <span class="profile-label">状态更新时间</span>
          <strong>{{ parseTime(form.statusTime, '{y}-{m}-{d} {h}:{i}:{s}') || '—' }}</strong>
        </article>
      </section>

      <el-tabs v-model="activeTab" class="device-workspace-tabs">
        <el-tab-pane label="实时数据" name="data">
          <DeviceData
            v-if="openDetail && activeTab === 'data'"
            v-bind="form"
            :key="form.id + '-data-' + openDetail"
          />
        </el-tab-pane>
        <el-tab-pane label="物模型绑定" name="binding">
          <DeviceBinding
            v-if="openDetail && activeTab === 'binding'"
            v-bind="form"
            :key="form.id + '-binding-' + openDetail"
          />
        </el-tab-pane>
      </el-tabs>
    </el-dialog>

    <!-- ========== 添加/修改设备对话框 ========== -->
    <el-dialog
      :title="title"
      v-model="open"
      width="600px"
      append-to-body
      :close-on-click-modal="false"
      class="form-dialog"
    >
      <el-form ref="devicesRef" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="设备ID" prop="id">
          <el-input
            v-model="form.id"
            placeholder="请输入设备ID"
            :disabled="data.operator === 'edit'"
          />
        </el-form-item>
        <el-form-item label="设备名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入设备名称" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="所属产品" prop="productId">
          <el-select
            v-model="form.productId"
            placeholder="请选择所属产品"
            :disabled="data.operator === 'edit'"
            @change="changeProductId"
          >
            <el-option
              v-for="item in productsList"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="所属网关" prop="gatewayId">
          <el-select
            v-model="form.gatewayId"
            placeholder="请选择所属网关"
          >
            <el-option
              v-for="item in selectEdgeDeviceList"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="标签" prop="tagIds">
          <TagSelect v-model="form.tagIds" />
          <el-text type="info" size="small">移除所选标签即可解绑；清空后保存将解除全部标签。</el-text>
        </el-form-item>
        <el-form-item label="设备说明" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            placeholder="请输入设备说明（选填）"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="Token" prop="token">
          <el-input v-model="form.token" placeholder="请输入设备 Token" />
        </el-form-item>
        <el-form-item label="拓展配置" prop="ext">
          <el-input
            v-model="form.ext"
            type="textarea"
            :rows="2"
            placeholder="请输入拓展配置（选填）"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancel">取 消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">确 定</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- ========== 设备导入对话框 ========== -->
    <excel-import-dialog
      ref="importDeviceRef"
      title="设备导入"
      action="/iot/devices/importData"
      template-action="/iot/devices/importTemplate"
      template-file-name="devices_template"
      update-support-label="是否更新已经存在的设备数据"
      @success="getList"
    />

    <!-- ========== 设备绑点导入对话框 ========== -->
    <excel-import-dialog
      ref="importBindingRef"
      title="设备绑点导入"
      action="/iot/binding/importData"
      template-action="/iot/binding/importTemplate"
      template-file-name="binding_template"
      update-support-label="是否更新已经存在的设备绑点数据"
      @success="getList"
    />

  </div>
</template>

<script setup name="Devices">
import { listDevices, getDevices, delDevices, addDevices, updateDevices } from "@/api/iot/devices";
import ExcelImportDialog from "@/components/ExcelImportDialog";
import DeviceData from "@/views/iot/devices/DeviceData.vue";
import DeviceBinding from "@/views/iot/devices/DeviceBinding.vue";
import { listAllProducts, getProducts } from "@/api/iot/products";
import { listAllEdgeDevice } from "@/api/iot/edgeDevice";
import IoTWorkspaceHeader from "@/components/IoTWorkspaceHeader";
import TagSelect from "@/components/TagSelect/index.vue";

const { proxy } = getCurrentInstance();
const { device_type, link_status } = proxy.useDict("device_type", "link_status");

// === 状态变量 ===
const devicesList = ref([]);
const open = ref(false);
const openDetail = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
const productsList = ref([]);
const edgeDeviceList = ref([]);
const selectEdgeDeviceList = ref([]);
const submitting = ref(false);
const activeTab = ref("data");
let productRequestSequence = 0;

const deviceStats = computed(() => {
  const online = devicesList.value.filter(item => item.linkStatus === "online").length;
  const offline = devicesList.value.filter(item => item.linkStatus === "offline").length;
  const gateways = new Set(devicesList.value.map(item => item.gatewayId).filter(Boolean)).size;
  return [
    { label: "设备总数", value: total.value, icon: "Cpu", hint: "设备资产规模" },
    { label: "当前页在线", value: online, icon: "CircleCheck", tone: "success", hint: "连接正常" },
    { label: "当前页离线", value: offline, icon: "Warning", tone: "danger", hint: "建议及时检查" },
    { label: "接入网关", value: gateways, icon: "Connection", tone: "warning", hint: "当前页网关数" },
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
    token: null,
    alias: null,
    productId: null,
    description: null,
    status: null,
    ext: null,
    gatewayId: null,
    deviceType: null,
    linkStatus: null,
    statusTime: null,
  },
  rules: {
    id: [{ required: true, message: "设备ID不能为空", trigger: "blur" }],
    name: [{ required: true, message: "设备名称不能为空", trigger: "blur" }],
    productId: [{ required: true, message: "请选择所属产品", trigger: "change" }],
    deviceType: [{ required: true, message: "设备类型不能为空", trigger: "change" }],
    gatewayId: [
      {
        validator: (_rule, value, callback) => {
          if (value && !data.form.productId) {
            callback(new Error("请先选择产品"));
          } else {
            callback();
          }
        },
        trigger: "blur",
      },
    ],
  },
  operator: "",
});

const { queryParams, form, rules } = toRefs(data);

function getStatusType(status) {
  return link_status.value.find(item => String(item.value) === String(status))?.elTagType || "info";
}

function getStatusLabel(status) {
  return link_status.value.find(item => String(item.value) === String(status))?.label || status || "未知";
}

/** 查询设备列表 */
function getList() {
  loading.value = true;
  listDevices(queryParams.value)
    .then((response) => {
      devicesList.value = Array.isArray(response?.rows) ? response.rows : [];
      total.value = Number(response?.total || 0);
    })
    .catch((error) => {
      devicesList.value = [];
      total.value = 0;
      console.error("获取设备列表失败:", error);
    })
    .finally(() => {
      loading.value = false;
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
    token: null,
    alias: null,
    productId: null,
    description: null,
    status: null,
    ext: null,
    gatewayId: null,
    deviceType: null,
    linkStatus: null,
    statusTime: null,
    createBy: null,
    createTime: null,
    updateTime: null,
  };
  proxy.resetForm("devicesRef");
}

/** 切换产品时更新设备类型与可选网关 */
async function changeProductId(productId, preserveGatewayId = null) {
  const requestSequence = ++productRequestSequence;
  form.value.gatewayId = null;
  selectEdgeDeviceList.value = [];
  if (!productId) {
    form.value.deviceType = null;
    return;
  }
  try {
    const response = await getProducts(productId);
    if (requestSequence !== productRequestSequence) return;
    const product = response.data;
    form.value.deviceType = product.deviceType;
    const edgeResponse = await listAllEdgeDevice({ protocolId: product.protocolId});
    if (requestSequence !== productRequestSequence) return;
    selectEdgeDeviceList.value = (Array.isArray(edgeResponse?.data) ? edgeResponse.data : []).map((item) => ({
        label: item.name,
        value: item.id,
        elTagType: "default",
    }));
    if (preserveGatewayId != null && selectEdgeDeviceList.value.some(item => String(item.value) === String(preserveGatewayId))) {
      form.value.gatewayId = preserveGatewayId;
    }
  } catch (error) {
    if (requestSequence === productRequestSequence) {
      selectEdgeDeviceList.value = [];
      console.error("加载产品接入配置失败:", error);
    }
  }
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
  ids.value = selection.map((item) => item.id);
  single.value = selection.length !== 1;
  multiple.value = !selection.length;
}

/** 新增按钮操作 */
function handleAdd() {
  data.operator = "add";
  reset();
  open.value = true;
  title.value = "添加设备";
}

/** 查看设备详情 */
function handleDetail(row) {
  data.operator = "edit";
  const id = row?.id || ids.value[0];
  if (!id) return;
  getDevices(id).then((response) => {
    form.value = response.data;
    openDetail.value = true;
    title.value = "设备详情";
    activeTab.value = "data";
  });
}

/** 修改按钮操作 */
function handleUpdate(row) {
  data.operator = "edit";
  reset();
  const id = row?.id || ids.value[0];
  if (!id) return;
  getDevices(id).then((response) => {
    form.value = response.data;
    open.value = true;
    title.value = "修改设备";
    changeProductId(form.value.productId, form.value.gatewayId);
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["devicesRef"].validate((valid) => {
    if (!valid) return;
    submitting.value = true;
    const action = data.operator === "edit" ? updateDevices(form.value) : addDevices(form.value);
    action
      .then((response) => {
        proxy.$modal.msgSuccess(data.operator === "edit" ? "修改成功" : "新增成功");
        open.value = false;
        getList();
      })
      .finally(() => {
        submitting.value = false;
      });
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const idsToDelete = row?.id || ids.value;
  proxy.$modal
    .confirm('是否确认删除设备编号为"' + idsToDelete + '"的数据项？')
    .then(() => delDevices(idsToDelete))
    .then(() => {
      getList();
      proxy.$modal.msgSuccess("删除成功");
    })
    .catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download("iot/devices/export", { ...queryParams.value }, `devices_${new Date().getTime()}.xlsx`);
}

/** 导入按钮操作 */
function handleImport() {
  proxy.$refs["importDeviceRef"].open();
}

function getBindingExportParams() {
  const { name, alias, productId, gatewayId, statusTime } = queryParams.value;
  return { name, alias, productId, gatewayId, statusTime };
}

/** 绑点导出按钮操作 */
function handleBindingExport() {
  proxy.download("iot/binding/export", getBindingExportParams(), `binding_${new Date().getTime()}.xlsx`);
}

/** 绑点导入按钮操作 */
function handleBindingImport() {
  proxy.$refs["importBindingRef"].open();
}

// === 数据初始化 ===

/** 获取产品列表 */
const fetchProductList = async () => {
  try {
    const response = await listAllProducts();
    productsList.value = (Array.isArray(response?.data) ? response.data : []).map((item) => ({
      label: item.name,
      value: item.id,
      elTagType: "default",
    }));
  } catch (error) {
    console.error("获取产品列表失败:", error);
  }
};

/** 获取网关设备列表 */
const fetchEdgeDeviceList = async () => {
  try {
    const response = await listAllEdgeDevice();
    edgeDeviceList.value = (Array.isArray(response?.data) ? response.data : []).map((item) => ({
      label: item.name,
      value: item.id,
      elTagType: "default",
    }));
  } catch (error) {
    console.error("获取网关设备列表失败:", error);
  }
};

fetchProductList();
getList();
fetchEdgeDeviceList();
</script>

<style lang="scss">
.device-workspace-dialog {
  max-width: calc(100vw - 32px);
  margin-top: 4vh;

  .el-dialog__header {
    padding: 18px 24px;
    background:
      radial-gradient(circle at 85% 0%, color-mix(in srgb, var(--ui-accent-cyan) 10%, transparent), transparent 42%),
      linear-gradient(110deg, color-mix(in srgb, var(--el-color-primary) 7%, var(--ui-surface)), var(--ui-surface));
  }

  .el-dialog__body {
    padding: 18px 22px 24px;
  }
}

.device-dialog-title {
  display: flex;
  align-items: center;
  gap: 13px;
  padding-right: 42px;

  > div {
    min-width: 0;
  }

  > .el-tag {
    margin-left: auto;
  }

  h2 {
    margin: 1px 0 0;
    color: var(--ui-text-primary);
    font-size: 19px;
  }

  p {
    max-width: 720px;
    margin: 4px 0 0;
    overflow: hidden;
    color: var(--ui-text-secondary);
    font-size: 12px;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.device-dialog-icon {
  display: grid;
  flex: 0 0 42px;
  width: 42px;
  height: 42px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 21px;
  background: color-mix(in srgb, var(--el-color-primary) 10%, var(--ui-surface));
  border: 1px solid color-mix(in srgb, var(--el-color-primary) 20%, var(--ui-border));
  border-radius: 11px;
}

.device-workspace-dialog .section-eyebrow {
  display: block;
  color: var(--el-color-primary);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.12em;
}

.device-profile-strip {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 10px;
  margin-bottom: 16px;

  article {
    min-width: 0;
    padding: 11px 13px;
    background: var(--ui-surface-soft);
    border: 1px solid var(--ui-border);
    border-radius: 9px;
  }

  .profile-label {
    display: block;
    margin-bottom: 5px;
    color: var(--ui-text-secondary);
    font-size: 11px;
  }

  strong {
    display: block;
    overflow: hidden;
    color: var(--ui-text-primary);
    font-size: 12px;
    font-weight: 600;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.device-workspace-tabs {
  .el-tabs__header {
    margin-bottom: 18px;
  }

  .el-tabs__item {
    height: 42px;
    padding: 0 24px;
    font-weight: 600;
  }

  .el-tabs__content {
    overflow: visible;
  }
}

.device-identity {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;

  > div {
    min-width: 0;
  }

  strong,
  small {
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  strong {
    color: var(--ui-text-primary);
    font-size: 13px;
  }

  small {
    margin-top: 3px;
    color: var(--ui-text-secondary);
    font-size: 11px;
  }
}

.device-identity-icon {
  display: grid;
  flex: 0 0 34px;
  width: 34px;
  height: 34px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 9%, var(--ui-surface));
  border: 1px solid color-mix(in srgb, var(--el-color-primary) 16%, var(--ui-border));
  border-radius: 9px;
}

.connection-state {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: var(--ui-text-secondary);
  font-size: 12px;
  font-weight: 600;

  i {
    width: 7px;
    height: 7px;
    background: var(--ui-text-placeholder);
    border-radius: 50%;
  }

  &.is-online {
    color: var(--el-color-success);

    i {
      background: currentColor;
      box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-success) 12%, transparent);
    }
  }

  &.is-offline {
    color: var(--el-color-danger);

    i {
      background: currentColor;
    }
  }

  &.is-inactive {
    color: var(--el-color-warning);

    i {
      background: currentColor;
    }
  }
}

@media (max-width: 900px) {
  .device-profile-strip {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 600px) {
  .device-dialog-title {
    align-items: flex-start;
    flex-wrap: wrap;
  }

  .device-dialog-title > .el-tag {
    margin-left: 55px;
  }

  .device-profile-strip {
    grid-template-columns: 1fr;
  }
}
</style>
