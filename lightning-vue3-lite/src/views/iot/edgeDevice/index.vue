<template>
  <div class="app-container iot-asset-page gateway-page">
    <IoTWorkspaceHeader
      title="边缘网关"
      eyebrow="EDGE CONNECTIVITY HUB"
      description="按已安装的边缘驱动隔离管理现场网关，持续掌握连接健康度与点位配置状态。"
      :stats="gatewayStats"
    >
      <template #icon><el-icon><Connection /></el-icon></template>
      <template #actions>
        <el-button icon="Refresh" @click="getList">刷新状态</el-button>
        <el-button type="primary" icon="Plus" :disabled="!selectedProtocol" @click="handleAdd"
                   v-hasPermi="['iot:edgeDevice:add']">
          新增网关
        </el-button>
      </template>
    </IoTWorkspaceHeader>

    <div class="app-content">
      <!-- 协议侧边栏 -->
      <div class="protocol-sidebar">
        <div class="sidebar-header">
          <el-icon><Connection /></el-icon>
          <span>边缘驱动</span>
        </div>
        <el-menu class="protocol-menu" :default-active="selectedProtocol" @select="handleProtocolSelect">
          <el-menu-item v-for="protocol in protocolsList" :key="protocol.value" :index="protocol.value.toString()">
            <el-icon><Link /></el-icon>
            <span class="driver-menu-copy">
              <strong>{{ protocol.label }}</strong>
              <small>{{ protocol.value }}</small>
            </span>
            <span class="protocol-count">
              <strong>{{ getProtocolGatewayStats(protocol.value).total }}</strong>
              <small>{{ getProtocolGatewayStats(protocol.value).online }} 在线</small>
            </span>
          </el-menu-item>
        </el-menu>
        <el-empty v-if="!protocolsList.length" description="尚未安装边缘驱动" :image-size="56" />
      </div>

      <!-- 主内容区 -->
      <div class="main-content">
        <div v-if="selectedDriver" class="driver-scope-card">
          <span class="driver-scope-icon"><el-icon><Link /></el-icon></span>
          <div>
            <small>当前驱动隔离视图</small>
            <strong>{{ selectedDriver.label }}</strong>
            <p>{{ selectedDriver.description || '仅展示并管理该驱动下的边缘网关。' }}</p>
          </div>
          <el-tag effect="plain" round>{{ selectedDriver.value }}</el-tag>
        </div>

        <el-empty v-if="!selectedProtocol" class="driver-empty-state"
                  description="请先安装并选择一个边缘驱动" />
        <template v-else>
        <el-form
          v-show="showSearch"
          ref="queryRef"
          :model="queryParams"
          :inline="true"
          label-width="auto"
          class="asset-filter-panel"
        >
          <el-form-item label="名称" prop="name">
            <el-input v-model="queryParams.name" placeholder="请输入名称" clearable @keyup.enter="handleQuery" />
          </el-form-item>
          <el-form-item label="传输协议" prop="protocolId">
            <el-select v-model="queryParams.protocolId" placeholder="当前驱动" style="width: 200px" disabled>
              <el-option v-for="protocol in protocolsList" :key="protocol.value" :label="protocol.label"
                         :value="protocol.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="连接状态" prop="linkStatus">
            <el-select v-model="queryParams.linkStatus" placeholder="全部连接状态" style="width: 160px" clearable>
              <el-option label="在线" value="online" />
              <el-option label="离线" value="offline" />
              <el-option label="未激活" value="inactive" />
            </el-select>
          </el-form-item>
          <el-form-item label="启停状态" prop="status">
            <el-select v-model="queryParams.status" placeholder="全部启停状态" style="width: 160px" clearable>
              <el-option label="已启用" value="enable" />
              <el-option label="已停用" value="disable" />
            </el-select>
          </el-form-item>
          <el-form-item label="说明" prop="description">
            <el-input v-model="queryParams.description" placeholder="请输入说明" clearable @keyup.enter="handleQuery" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
            <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <section class="asset-table-panel">
          <div class="asset-table-heading">
            <div>
              <span class="asset-table-title">网关列表</span>
              <span class="asset-table-caption">当前驱动视图展示 {{ edgeDeviceList.length }} 个网关</span>
            </div>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
          </div>

        <el-row :gutter="10" class="mb8 asset-toolbar">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="Plus" :disabled="!selectedProtocol" @click="handleAdd"
                       v-hasPermi="['iot:edgeDevice:add']">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
                       v-hasPermi="['iot:edgeDevice:edit']">修改</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
                       v-hasPermi="['iot:edgeDevice:remove']">删除</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="warning" plain icon="Download" @click="handleExport"
                       v-hasPermi="['iot:edgeDevice:export']">导出</el-button>
          </el-col>
        </el-row>

        <el-table v-loading="loading" :data="edgeDeviceList" row-key="id"
                  @selection-change="handleSelectionChange" @row-dblclick="handleUpdate">
          <el-table-column type="selection" width="55" align="center" />
          <el-table-column label="网关信息" prop="name" min-width="230">
            <template #default="scope">
              <button type="button" class="gateway-identity gateway-instance-link"
                      :aria-label="`查看 ${scope.row.name || scope.row.id} 的点位列表`"
                      @click="goToDataPoints(scope.row)">
                <span class="gateway-node-icon" :class="{ 'is-online': scope.row.linkStatus === 'online' }">
                  <el-icon><Connection /></el-icon>
                </span>
                <div>
                  <strong>{{ scope.row.name || '未命名网关' }}</strong>
                  <small>{{ scope.row.id }}<template v-if="scope.row.description"> · {{ scope.row.description }}</template></small>
                </div>
                <el-icon class="gateway-link-arrow"><ArrowRight /></el-icon>
              </button>
            </template>
          </el-table-column>
          <el-table-column label="连接状态" align="center" prop="linkStatus" width="110">
            <template #default="scope">
              <el-tag :type="getStatusType(scope.row.linkStatus)" effect="light" round>
                {{ getStatusLabel(scope.row.linkStatus) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="传输协议" align="center" prop="protocolId">
            <template #default="scope">
              <dict-tag :options="protocolsList" :value="scope.row.protocolId" />
            </template>
          </el-table-column>
          <el-table-column label="状态变更时间" align="center" prop="statusTime" width="180" />
          <el-table-column prop="status" align="center" label="启停状态" width="120">
            <template #default="scope">
              <el-switch v-model="scope.row.status" active-value="enable" inactive-value="disable"
                         inline-prompt active-text="启" inactive-text="停"
                         :loading="isStatusUpdating(scope.row.id)"
                         :disabled="isStatusUpdating(scope.row.id)"
                         @change="handleSwitchChange(scope.row)" />
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="230" class-name="small-padding fixed-width">
            <template #default="scope">
              <el-button link type="primary" icon="Aim" @click="goToDataPoints(scope.row)">点位</el-button>
              <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
                         v-hasPermi="['iot:edgeDevice:edit']">修改</el-button>
              <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)"
                         v-hasPermi="['iot:edgeDevice:remove']">删除</el-button>
            </template>
          </el-table-column>
          <template #empty>
            <el-empty description="暂无设备数据" />
          </template>
        </el-table>

        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
                    v-model:limit="queryParams.pageSize" @pagination="getList" />
        </section>

        <!-- 添加或修改设备接入网关对话框 -->
        <el-dialog :title="title" v-model="open" width="720px" append-to-body destroy-on-close
                   :close-on-click-modal="false" class="gateway-editor-dialog">
          <div class="gateway-editor-intro">
            <span><el-icon><Connection /></el-icon></span>
            <div>
              <strong>{{ operator === 'edit' ? '维护边缘接入配置' : '注册新的边缘网关' }}</strong>
              <p>选择协议后将加载对应连接参数，网关 ID 创建后不可修改。</p>
            </div>
          </div>
          <el-form ref="edgeDeviceRef" :model="form" :rules="rules" label-position="top"
                   :validate-on-rule-change="false">
            <div class="gateway-form-section"><span>01</span>基础身份</div>
            <el-row :gutter="20">
              <el-col :xs="24" :sm="12">
                <el-form-item label="网关 ID" prop="id">
                  <el-input v-model="form.id" placeholder="选择协议后自动生成，也可手动填写"
                            :disabled="operator === 'edit'" maxlength="64" />
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="网关名称" prop="name">
                  <el-input v-model="form.name" placeholder="请输入网关名称" maxlength="50" show-word-limit />
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="传输协议" prop="protocolId">
                  <el-select v-model="form.protocolId" placeholder="请选择传输协议类型"
                             @change="handleFormProtocolChange" clearable style="width: 100%">
                    <el-option v-for="protocol in protocolsList" :key="protocol.value" :label="protocol.label"
                               :value="protocol.value" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="网关说明" prop="description">
                  <el-input v-model="form.description" type="textarea" :rows="2" maxlength="200" show-word-limit
                            placeholder="描述部署位置、接入设备或网络环境" />
                </el-form-item>
              </el-col>
            </el-row>

            <!-- 协议连接属性 -->
            <template v-if="connectionProperties.length > 0">
              <div class="gateway-form-section"><span>02</span>协议连接配置</div>
              <div class="gateway-config-panel">
              <el-row :gutter="18">
                <el-col v-for="property in connectionProperties" :key="property.id"
                        :xs="24" :sm="property.valueType.type === 'string' ? 24 : 12">
                  <el-form-item :label="property.name" :prop="'configuration.' + property.id">
                    <el-input v-if="property.valueType.type === 'string'" v-model="form.configuration[property.id]"
                              :placeholder="`请输入${property.name}`" clearable />

                    <el-input-number v-else-if="isNumericValueType(property.valueType)"
                                     v-model="form.configuration[property.id]" :min="property.valueType.min"
                                     :max="property.valueType.max" :precision="getValueTypePrecision(property.valueType)"
                                     :placeholder="`请输入${property.name}`"
                                     style="width: 100%" />

                    <el-select v-else-if="property.valueType.type === 'enum'"
                               v-model="form.configuration[property.id]" :multiple="property.valueType.multi"
                               collapse-tags collapse-tags-tooltip :placeholder="`请选择${property.name}`"
                               style="width: 100%" clearable>
                      <el-option v-for="option in property.valueType.elements || []" :key="option.value"
                                 :label="option.text" :value="option.value">
                        <div class="option-content">
                          <div class="option-text">{{ option.text }}</div>
                          <div class="option-desc">{{ option.description }}</div>
                        </div>
                      </el-option>
                    </el-select>

                    <el-select v-else-if="isBooleanType(property.valueType)"
                               v-model="form.configuration[property.id]" :placeholder="`请选择${property.name}`"
                               style="width: 100%" clearable>
                      <el-option v-for="option in getBooleanOptions(property.valueType)" :key="option.value"
                                 :label="option.label" :value="option.value" />
                    </el-select>

                    <el-input v-else v-model="form.configuration[property.id]"
                              :placeholder="`请输入${property.name}`" clearable />

                    <div v-if="property.valueType.unit" class="prop-hint">
                      单位: {{ property.valueType.unit }}
                    </div>
                    <div v-if="property.valueType.min !== undefined || property.valueType.max !== undefined"
                         class="prop-hint">
                      {{ getRangeText(property.valueType) }}
                    </div>
                    <div v-if="property.valueType.type === 'enum' && form.configuration[property.id]" class="prop-hint">
                      {{ getEnumDescription(property, form.configuration[property.id]) }}
                    </div>
                  </el-form-item>
                </el-col>
              </el-row>
              </div>
            </template>
            <el-empty v-else-if="form.protocolId" description="当前协议无需额外连接参数" :image-size="58" />
          </el-form>
          <template #footer>
            <div class="dialog-footer">
              <el-button @click="cancel">取 消</el-button>
              <el-button type="primary" :loading="submitting" @click="submitForm">
                {{ operator === 'edit' ? '保存修改' : '创建网关' }}
              </el-button>
            </div>
          </template>
        </el-dialog>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup name="EdgeDevice">
import { listEdgeDevice, listAllEdgeDevice, getEdgeDevice, delEdgeDevice, addEdgeDevice, updateEdgeDevice, disableEdgeDevice, enableEdgeDevice } from "@/api/iot/edgeDevice";
import { listAllProtocol } from "@/api/iot/protocol";
import IoTWorkspaceHeader from "@/components/IoTWorkspaceHeader";

const { proxy } = getCurrentInstance();
const router = useRouter();
const route = useRoute();

const edgeDeviceList = ref([]);
const open = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
const protocolsList = ref([]);
const protocolCatalog = ref([]);
const gatewayInventory = ref([]);
const selectedProtocol = ref("");
const connectionProperties = ref([]);
const submitting = ref(false);
const statusUpdatingIds = ref(new Set());

const selectedDriver = computed(() =>
  protocolsList.value.find(item => String(item.value) === String(selectedProtocol.value))
);

const gatewayStats = computed(() => {
  const inventory = gatewayInventory.value;
  const online = inventory.filter(item => item.linkStatus === "online").length;
  const offline = inventory.filter(item => item.linkStatus === "offline").length;
  const enabled = inventory.filter(item => item.status === "enable").length;
  return [
    { label: "网关总数", value: inventory.length, icon: "Connection", hint: "全部驱动统计" },
    { label: "在线网关", value: online, icon: "CircleCheck", tone: "success", hint: "链路运行正常" },
    { label: "离线网关", value: offline, icon: "Warning", tone: "danger", hint: "需要排查链路" },
    { label: "已启用", value: enabled, icon: "SwitchButton", tone: "warning", hint: "当前启用规模" },
  ];
});

function getProtocolGatewayStats(protocolId) {
  const gateways = gatewayInventory.value.filter(
    item => String(item.protocolId) === String(protocolId)
  );
  return {
    total: gateways.length,
    online: gateways.filter(item => item.linkStatus === "online").length
  };
}

// 基础校验规则（连接属性规则会在此基础上动态叠加，避免污染）
const baseRules = {
  id: [
    { required: true, message: "网关 ID 不能为空", trigger: "blur" },
    { pattern: /^[A-Za-z0-9_.-]{2,64}$/, message: "仅支持字母、数字、点、横线和下划线", trigger: "blur" }
  ],
  name: [{ required: true, message: "名称不能为空", trigger: "blur" }],
  protocolId: [{ required: true, message: "协议不能为空", trigger: "change" }]
};

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    status: null,
    linkStatus: null,
    protocolId: null,
    configuration: null,
    description: null,
    statusTime: null,
  },
  rules: { ...baseRules },
  operator: ""
});

const { queryParams, form, rules, operator } = toRefs(data);

// 连接状态映射
const STATUS_MAP = {
  online: { type: "success", label: "在线" },
  offline: { type: "danger", label: "离线" },
  inactive: { type: "warning", label: "停用" },
};

function getStatusType(status) {
  return STATUS_MAP[status]?.type || "info";
}

function getStatusLabel(status) {
  return STATUS_MAP[status]?.label || status || "未知";
}

function isStatusUpdating(id) {
  return statusUpdatingIds.value.has(id);
}

/** 处理侧边栏协议选择 */
function handleProtocolSelect(index) {
  selectedProtocol.value = index;
  connectionProperties.value = [];
  queryParams.value.protocolId = index;
  queryParams.value.pageNum = 1;
  getList();
}

/** 启停状态切换 */
function handleSwitchChange(row) {
  if (isStatusUpdating(row.id)) return;
  const request = row.status === "enable" ? enableEdgeDevice : disableEdgeDevice;
  const successMsg = row.status === "enable" ? "启用成功" : "停用成功";
  statusUpdatingIds.value = new Set(statusUpdatingIds.value).add(row.id);
  request(row.id)
    .then(() => {
      proxy.$modal.msgSuccess(successMsg);
      refreshGatewayInventory();
    })
    .catch(() => {
      row.status = row.status === "enable" ? "disable" : "enable";
    })
    .finally(() => {
      const next = new Set(statusUpdatingIds.value);
      next.delete(row.id);
      statusUpdatingIds.value = next;
    });
}

/** 查询设备接入网关列表 */
function getList() {
  if (!selectedProtocol.value) {
    edgeDeviceList.value = [];
    total.value = 0;
    loading.value = false;
    return;
  }
  queryParams.value.protocolId = selectedProtocol.value;
  loading.value = true;
  listEdgeDevice(queryParams.value)
    .then(response => {
      edgeDeviceList.value = Array.isArray(response?.rows) ? response.rows : [];
      total.value = Number(response?.total || 0);
    })
    .catch(error => {
      edgeDeviceList.value = [];
      total.value = 0;
      console.error("获取边缘网关列表失败:", error);
    })
    .finally(() => {
      loading.value = false;
    });
  refreshGatewayInventory();
}

function refreshGatewayInventory() {
  return listAllEdgeDevice()
    .then(response => {
      gatewayInventory.value = Array.isArray(response?.data) ? response.data : [];
    })
    .catch(error => {
      console.error("获取边缘网关概览失败:", error);
    });
}

// 取消按钮
function cancel() {
  open.value = false;
  reset();
}

// 表单重置
function reset() {
  form.value = {
    id: null,
    name: null,
    status: "enable",
    linkStatus: null,
    protocolId: null,
    configuration: {},
    description: null,
    statusTime: null,
    createBy: null,
    createTime: null,
    updateTime: null
  };
  connectionProperties.value = [];
  rules.value = { ...baseRules };
  proxy.resetForm("edgeDeviceRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.protocolId = selectedProtocol.value;
  queryParams.value.pageNum = 1;
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef");
  queryParams.value.protocolId = selectedProtocol.value;
  handleQuery();
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 新增按钮操作 */
function handleAdd() {
  if (!selectedProtocol.value) {
    proxy.$modal.msgWarning("请先选择一个边缘驱动");
    return;
  }
  data.operator = "add";
  reset();
  const selected = protocolsList.value.find(item => String(item.value) === String(selectedProtocol.value));
  form.value.protocolId = selected?.value ?? selectedProtocol.value;
  fetchConnectionProperties(form.value.protocolId);
  open.value = true;
  title.value = "添加设备接入网关";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  data.operator = "edit";
  reset();
  const _id = row?.id || ids.value[0];
  if (!_id) return;
  getEdgeDevice(_id).then(response => {
    form.value = {
      ...response.data,
      configuration: parseConfiguration(response.data?.configuration),
    };
    open.value = true;
    title.value = "修改设备接入网关";
    fetchConnectionProperties(response.data.protocolId);
  });
}

function parseConfiguration(configuration) {
  if (!configuration) return {};
  if (typeof configuration === "object") return {...configuration};
  try {
    return JSON.parse(configuration);
  } catch (error) {
    console.error("解析网关配置失败:", error);
    return {};
  }
}

/** 提交按钮 */
function submitForm() {
  if (submitting.value) return;
  proxy.$refs["edgeDeviceRef"].validate(valid => {
    if (!valid) return;
    const payload = { ...form.value, configuration: JSON.stringify(form.value.configuration) };
    const request = data.operator === "edit" ? updateEdgeDevice : addEdgeDevice;
    const successMsg = data.operator === "edit" ? "修改成功" : "新增成功";
    submitting.value = true;
    request(payload)
      .then(() => {
        proxy.$modal.msgSuccess(successMsg);
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
  const _ids = row?.id || ids.value;
  if (!_ids || (Array.isArray(_ids) && !_ids.length)) return;
  proxy.$modal.confirm('是否确认删除设备接入网关编号为"' + _ids + '"的数据项？').then(function () {
    return delEdgeDevice(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => { });
}

/** 导出按钮操作 */
function handleExport() {
  if (!selectedProtocol.value) return;
  proxy.download('iot/edgeDevice/export', {
    ...queryParams.value
  }, `edgeDevice_${new Date().getTime()}.xlsx`);
}

/** 获取协议列表 */
const fetchProtocolList = async () => {
  try {
    const response = await listAllProtocol({ protocolType: 'edge' });
    protocolCatalog.value = Array.isArray(response?.data) ? response.data : [];
    protocolsList.value = protocolCatalog.value.map(item => ({
      label: item.name,
      value: item.id,
      description: item.description,
      elTagType: 'default'
    }));
  } catch (error) {
    console.error("获取协议列表失败:", error);
  }
};

/** 生成校验规则：基础规则 + 连接属性规则 */
function generateRules(properties) {
  const generatedRules = { ...baseRules };
  if (!Array.isArray(properties)) {
    console.warn("连接属性必须是一个数组");
    return generatedRules;
  }
  properties.forEach(property => {
    if (!property.id || !property.name || !property.valueType) {
      console.warn("属性缺少必要信息，跳过验证规则生成");
      return;
    }
    generatedRules['configuration.' + property.id] = getFieldRules(property);
  });
  return generatedRules;
}

/** 获取单个字段的校验规则 */
function getFieldRules(property) {
  const fieldRules = [];

  if (property.required === true) {
    fieldRules.push({
      required: true,
      message: `请输入${property.name}`,
      trigger: isSelectType(property.valueType) ? 'change' : 'blur'
    });
  }

  // 数值范围验证
  if (property.valueType.type === 'int') {
    if (property.valueType.min !== undefined) {
      fieldRules.push({
        type: 'number',
        min: property.valueType.min,
        message: `${property.name}不能小于${property.valueType.min}`,
        trigger: 'blur'
      });
    }
    if (property.valueType.max !== undefined) {
      fieldRules.push({
        type: 'number',
        max: property.valueType.max,
        message: `${property.name}不能大于${property.valueType.max}`,
        trigger: 'blur'
      });
    }
  }

  // IP地址验证
  if (property.id === 'ip_address') {
    fieldRules.push({
      pattern: /^(\d{1,3}\.){3}\d{1,3}$/,
      message: '请输入有效的IP地址',
      trigger: 'blur'
    });
  }

  return fieldRules;
}

/** 生成设备ID：协议ID + 随机ID */
function generateDeviceId(protocolId) {
  if (!form.value.id) {
    const timestamp = Date.now().toString(36);
    const random = Math.random().toString(36).substr(2, 5);
    form.value.id = `${protocolId}_${timestamp}_${random}`;
  }
}

/** 获取范围提示文本 */
function getRangeText(valueType) {
  if (valueType.min !== undefined && valueType.max !== undefined) {
    return `范围: ${valueType.min} - ${valueType.max}`;
  } else if (valueType.min !== undefined) {
    return `最小值: ${valueType.min}`;
  } else if (valueType.max !== undefined) {
    return `最大值: ${valueType.max}`;
  }
  return '';
}

/** 获取枚举描述 */
function getEnumDescription(property, value) {
  const elements = property.valueType.elements || [];
  if (Array.isArray(value)) {
    return value
      .map(item => getEnumDescription(property, item))
      .filter(Boolean)
      .join('，');
  }
  const element = elements.find(el => String(el.value) === String(value));
  return element ? element.description : '';
}

/** 判断是否布尔类型 */
function isBooleanType(valueType) {
  return ['boolean', 'bool'].includes(valueType?.type);
}

function isNumericValueType(valueType) {
  return ['int', 'long', 'float', 'double', 'number'].includes(valueType?.type);
}

function getValueTypePrecision(valueType) {
  if (['int', 'long'].includes(valueType?.type)) return 0;
  return valueType?.scale ?? undefined;
}

/** 判断是否下拉选择类型 */
function isSelectType(valueType) {
  return valueType?.type === 'enum' || isBooleanType(valueType);
}

/** 获取布尔选项 */
function getBooleanOptions(valueType) {
  return [
    {
      label: valueType?.trueText || '是',
      value: valueType?.trueValue ?? 'true'
    },
    {
      label: valueType?.falseText || '否',
      value: valueType?.falseValue ?? 'false'
    }
  ];
}

/** 根据协议获取连接属性并生成校验规则 */
const fetchConnectionProperties = async (protocolId) => {
  if (!protocolId) {
    connectionProperties.value = [];
    rules.value = { ...baseRules };
    return;
  }
  try {
    if (!protocolCatalog.value.length) {
      await fetchProtocolList();
    }
    const protocol = protocolCatalog.value.find(item => String(item.id) === String(protocolId));
    if (!protocol) {
      connectionProperties.value = [];
      rules.value = { ...baseRules };
      return;
    }
    // 新增模式下自动生成设备ID
    if (data.operator === 'add') {
      generateDeviceId(protocolId);
    }
    let configuration = protocol.configuration;
    if (typeof configuration === "string" && configuration.length > 0) {
      configuration = JSON.parse(configuration);
    }
    if (configuration && configuration.connectionProperties) {
      connectionProperties.value = configuration.connectionProperties;
      rules.value = generateRules(connectionProperties.value);
    } else {
      connectionProperties.value = [];
      rules.value = { ...baseRules };
    }
  } catch (error) {
    console.error("获取连接属性失败:", error);
    connectionProperties.value = [];
    rules.value = { ...baseRules };
  }
};

function goToDataPoints(row) {
  router.push({
    path: "/edge/edgeDataPoint",
    query: { protocolId: row.protocolId, gatewayId: row.id }
  });
}

async function initializePage() {
  await Promise.all([fetchProtocolList(), refreshGatewayInventory()]);
  const requestedProtocol = route.query.protocolId;
  const matched = protocolsList.value.find(item => String(item.value) === String(requestedProtocol));
  selectedProtocol.value = String(matched?.value ?? protocolsList.value[0]?.value ?? "");
  queryParams.value.protocolId = selectedProtocol.value || null;
  getList();
}

function handleFormProtocolChange(protocolId) {
  form.value.configuration = {};
  fetchConnectionProperties(protocolId);
}

initializePage();
</script>

<style scoped lang="scss">
.gateway-page .app-content {
  align-items: flex-start;
}

.gateway-page .protocol-sidebar {
  position: sticky;
  top: 14px;
  min-height: 420px;
}

.protocol-menu :deep(.el-menu-item) {
  gap: 4px;
  margin: 4px 10px;
  height: 58px;
  padding: 0 12px !important;
  border-radius: 8px;
}

.driver-menu-copy {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-width: 0;
  line-height: 1.25;
}

.driver-menu-copy strong,
.driver-menu-copy small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.driver-menu-copy strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.driver-menu-copy small {
  margin-top: 4px;
  color: var(--ui-text-secondary);
  font-family: "SFMono-Regular", Consolas, monospace;
  font-size: 10px;
}

.protocol-count {
  display: flex;
  flex: 0 0 auto;
  flex-direction: column;
  min-width: 44px;
  margin-left: auto;
  padding: 4px 7px;
  color: var(--ui-text-secondary);
  line-height: 1.15;
  text-align: center;
  background: var(--ui-surface-soft);
  border-radius: 9px;
}

.protocol-count strong {
  color: var(--ui-text-primary);
  font-size: 12px;
}

.protocol-count small {
  margin-top: 3px;
  font-size: 9px;
}

.protocol-menu :deep(.el-menu-item.is-active) .protocol-count {
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 10%, var(--ui-surface));
}

.driver-scope-card {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 18px;
  padding: 16px 18px;
  background: linear-gradient(120deg,
    color-mix(in srgb, var(--el-color-primary) 9%, var(--ui-surface)),
    var(--ui-surface));
  border: 1px solid color-mix(in srgb, var(--el-color-primary) 18%, var(--ui-border));
  border-radius: 14px;
  box-shadow: var(--ui-shadow-sm);
}

.driver-scope-icon {
  display: grid;
  flex: 0 0 42px;
  width: 42px;
  height: 42px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 18px;
  background: var(--ui-surface);
  border-radius: 12px;
}

.driver-scope-card > div {
  flex: 1;
  min-width: 0;
}

.driver-scope-card small,
.driver-scope-card strong {
  display: block;
}

.driver-scope-card small {
  color: var(--el-color-primary);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.driver-scope-card strong {
  margin-top: 3px;
  color: var(--ui-text-primary);
  font-size: 15px;
}

.driver-scope-card p {
  margin: 3px 0 0;
  color: var(--ui-text-secondary);
  font-size: 12px;
}

.driver-empty-state {
  min-height: 420px;
  background: var(--ui-surface);
  border: 1px dashed var(--ui-border);
  border-radius: 14px;
}

.asset-filter-panel {
  margin-bottom: 18px;
  padding: 18px 20px 4px;
  background: var(--ui-surface);
  border: 1px solid var(--ui-border);
  border-radius: 14px;
  box-shadow: var(--ui-shadow-sm);
}

.gateway-identity {
  display: flex;
  align-items: center;
  gap: 11px;
  min-width: 0;
}

.gateway-instance-link {
  width: 100%;
  padding: 4px 6px;
  color: inherit;
  text-align: left;
  background: transparent;
  border: 0;
  border-radius: 10px;
  cursor: pointer;
  transition: background-color 0.2s ease, box-shadow 0.2s ease;
}

.gateway-instance-link:hover,
.gateway-instance-link:focus-visible {
  background: color-mix(in srgb, var(--el-color-primary) 7%, transparent);
  outline: none;
  box-shadow: 0 0 0 2px color-mix(in srgb, var(--el-color-primary) 16%, transparent);
}

.gateway-link-arrow {
  margin-left: auto;
  color: var(--el-color-primary);
  opacity: 0;
  transform: translateX(-4px);
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.gateway-instance-link:hover .gateway-link-arrow,
.gateway-instance-link:focus-visible .gateway-link-arrow {
  opacity: 1;
  transform: translateX(0);
}

.gateway-identity > div {
  min-width: 0;
}

.gateway-identity strong,
.gateway-identity small {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.gateway-identity strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.gateway-identity small {
  margin-top: 4px;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.gateway-node-icon {
  display: grid;
  flex: 0 0 38px;
  width: 38px;
  height: 38px;
  place-items: center;
  color: var(--ui-text-secondary);
  font-size: 17px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.gateway-node-icon.is-online {
  color: var(--el-color-success);
  background: color-mix(in srgb, var(--el-color-success) 9%, var(--ui-surface));
  border-color: color-mix(in srgb, var(--el-color-success) 20%, var(--ui-border));
}

.gateway-editor-intro {
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

.gateway-editor-intro > span {
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

.gateway-editor-intro strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.gateway-editor-intro p {
  margin: 3px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.gateway-form-section {
  display: flex;
  align-items: center;
  gap: 9px;
  margin: 2px 0 15px;
  color: var(--ui-text-primary);
  font-size: 13px;
  font-weight: 700;
}

.gateway-form-section span {
  display: inline-grid;
  width: 25px;
  height: 25px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 10px;
  background: color-mix(in srgb, var(--el-color-primary) 9%, transparent);
  border-radius: 7px;
}

.gateway-config-panel {
  margin-bottom: 4px;
  padding: 16px 16px 1px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 11px;
}

.prop-hint {
  width: 100%;
  font-size: 12px;
  color: var(--ui-text-secondary);
  line-height: 1.4;
}

.option-content {
  display: flex;
  flex-direction: column;
  line-height: 1.3;
}

.option-desc {
  font-size: 12px;
  color: var(--ui-text-secondary);
}

.gateway-editor-dialog :deep(.el-dialog__body) {
  padding-top: 20px;
}

.gateway-editor-dialog :deep(.el-input-number) {
  width: 100%;
}

@media (max-width: 991px) {
  .gateway-page .protocol-sidebar {
    position: static;
    min-height: auto;
  }

  .protocol-menu {
    display: flex;
    overflow-x: auto;
  }

  .protocol-menu :deep(.el-menu-item) {
    flex: 0 0 auto;
  }
}

</style>
