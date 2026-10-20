<template>
  <div class="app-container iot-asset-page edge-point-page">
    <IoTWorkspaceHeader
      title="边缘数据点"
      eyebrow="EDGE DATA POINT REGISTRY"
      description="按边缘驱动隔离编排网关点位，并直接呈现每种驱动独有的地址与采集属性。"
      :stats="pointStats"
    >
      <template #icon><el-icon><Aim /></el-icon></template>
      <template #actions>
        <el-button icon="Refresh" @click="getList">刷新点位</el-button>
        <el-button type="primary" icon="Plus" :disabled="!selectedGateway" @click="handleAdd"
                   v-hasPermi="['iot:edgeDataPoint:add']">
          新增点位
        </el-button>
      </template>
    </IoTWorkspaceHeader>

    <div class="app-content">
      <!-- 驱动与网关侧边栏 -->
      <div class="protocol-sidebar">
        <div class="sidebar-header">
          <el-icon><Link /></el-icon>
          <span>边缘驱动</span>
        </div>
        <el-menu class="protocol-menu driver-menu" :default-active="selectedProtocol" @select="handleProtocolSelect">
          <el-menu-item v-for="protocol in protocolsList" :key="protocol.value" :index="protocol.value.toString()">
            <el-icon><Link /></el-icon>
            <span class="driver-menu-copy">
              <strong>{{ protocol.label }}</strong>
              <small>{{ protocol.value }}</small>
            </span>
            <span class="driver-gateway-count">
              <strong>{{ getProtocolGatewayStats(protocol.value).total }}</strong>
              <small>{{ getProtocolGatewayStats(protocol.value).online }} 在线</small>
            </span>
          </el-menu-item>
        </el-menu>
        <el-empty v-if="!protocolsList.length" description="尚未安装边缘驱动" :image-size="52" />

        <template v-if="selectedProtocol">
          <div class="gateway-scope-header">
            <span>网关范围</span>
            <small>{{ selectedDriverGatewayStats.total }} 个 · {{ selectedDriverGatewayStats.online }} 在线</small>
          </div>
          <el-menu class="protocol-menu gateway-menu" :default-active="selectedEdgeDevice" @select="handleEdgeDeviceSelect">
          <el-menu-item v-for="edgeDevice in edgeDeviceList" :key="edgeDevice.value"
                        :index="edgeDevice.value.toString()">
            <el-icon><Cpu /></el-icon>
            <span class="gateway-menu-copy">
              <strong>{{ edgeDevice.label }}</strong>
              <small>{{ edgeDevice.status === 'enable' ? '运行中 · 配置已锁定' : '已停用 · 可维护' }}</small>
            </span>
            <span class="gateway-point-count">{{ countGatewayPoints(edgeDevice.value) }}</span>
          </el-menu-item>
        </el-menu>
        </template>
      </div>

      <div class="main-content">
        <div v-if="selectedDriver" class="driver-scope-card">
          <span class="driver-scope-icon"><el-icon><Link /></el-icon></span>
          <div>
            <small>驱动隔离点位视图</small>
            <strong>{{ selectedDriver.label }}</strong>
            <p>{{ listDataPointProperties.length
              ? `列表已展开 ${listDataPointProperties.length} 项驱动自有属性`
              : '该驱动没有额外的点位属性' }}</p>
          </div>
          <el-tag v-if="selectedGateway" :type="selectedGateway.status === 'enable' ? 'warning' : 'success'"
                  effect="light" round>
            {{ selectedGateway.status === 'enable' ? '网关运行中 · 配置锁定' : '网关已停用 · 可维护' }}
          </el-tag>
          <el-tag v-else effect="plain" round>{{ selectedDriver.value }}</el-tag>
        </div>

        <el-empty v-if="!selectedProtocol" class="driver-empty-state"
                  description="请先安装并选择一个边缘驱动" />
        <template v-else>
        <el-empty v-if="!selectedGateway" class="driver-empty-state"
                  description="当前驱动尚未创建网关，请先前往边缘网关页面添加" />
        <template v-else>
        <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch"
                 label-width="auto" class="asset-filter-panel">
          <el-form-item label="数据点位名称" prop="name">
            <el-input v-model="queryParams.name" placeholder="请输入数据点位名称" clearable @keyup.enter="handleQuery" />
          </el-form-item>
          <el-form-item label="传输协议" prop="protocolId">
            <el-select v-model="queryParams.protocolId" placeholder="当前驱动" style="width: 180px" disabled>
              <el-option v-for="protocol in protocolsList" :key="protocol.value" :label="protocol.label"
                         :value="protocol.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="边缘网关设备" prop="gatewayId">
            <el-select v-model="queryParams.gatewayId" placeholder="请选择一个边缘网关" style="width: 220px"
                       @change="handleGatewayQueryChange">
              <el-option v-for="edgeDevice in edgeDeviceList" :key="edgeDevice.value" :label="edgeDevice.label"
                         :value="edgeDevice.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="读写类型" prop="operationTpye">
            <el-select v-model="queryParams.operationTpye" placeholder="全部读写类型" style="width: 160px" clearable>
              <el-option v-for="dict in data_type" :key="dict.value" :label="dict.label"
                         :value="dict.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="数据类型" prop="type">
            <el-select v-model="queryParams.type" placeholder="全部数据类型" style="width: 160px" clearable>
              <el-option v-for="dict in point_value_type" :key="dict.value" :label="dict.label"
                         :value="dict.value" />
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
              <span class="asset-table-title">点位列表</span>
              <span class="asset-table-caption">{{ selectedGateway.label }} · 展示 {{ edgeDataPointList.length }} 个数据点</span>
            </div>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
          </div>

        <el-row :gutter="10" class="mb8 asset-toolbar">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="Plus" :disabled="!selectedGateway" @click="handleAdd"
                       v-hasPermi="['iot:edgeDataPoint:add']">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
                       v-hasPermi="['iot:edgeDataPoint:edit']">修改</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
                       v-hasPermi="['iot:edgeDataPoint:remove']">删除</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="warning" plain icon="Download" :disabled="!queryParams.gatewayId" @click="handleExport"
                       v-hasPermi="['iot:edgeDataPoint:export']">导出</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="info" plain icon="Upload" @click="handleImport"
                       v-hasPermi="['iot:edgeDataPoint:add']">导入</el-button>
          </el-col>
        </el-row>

        <el-table v-loading="loading" :data="edgeDataPointList" row-key="id"
                  @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" align="center" :selectable="canMaintainPoint" />
          <el-table-column label="点位信息" prop="name" min-width="210">
            <template #default="scope">
              <div class="point-identity">
                <span class="point-type-icon"><el-icon><Aim /></el-icon></span>
                <div>
                  <strong>{{ scope.row.name || '未命名点位' }}</strong>
                  <small>{{ scope.row.id }}</small>
                </div>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="传输协议" align="center" prop="protocolId">
            <template #default="scope">
              <dict-tag :options="protocolsList" :value="scope.row.protocolId" />
            </template>
          </el-table-column>
          <el-table-column v-for="property in listDataPointProperties" :key="property.id"
                           :prop="`config.${property.id}`" min-width="140" show-overflow-tooltip>
            <template #header>
              <span class="driver-property-header">
                {{ property.name }}
                <el-tooltip v-if="property.description" :content="property.description" placement="top">
                  <el-icon><QuestionFilled /></el-icon>
                </el-tooltip>
              </span>
            </template>
            <template #default="scope">
              <span class="driver-property-value">{{ formatDriverProperty(scope.row, property) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="数据类型" align="center" prop="type" width="100">
            <template #default="scope">
              <dict-tag :options="point_value_type" :value="scope.row.type" />
            </template>
          </el-table-column>
          <el-table-column label="读写类型" align="center" prop="operationTpye" width="105">
            <template #default="scope">
              <dict-tag :options="data_type" :value="scope.row.operationTpye" />
            </template>
          </el-table-column>
          <el-table-column label="点位值" min-width="250" align="center" prop="value">
            <template #default="scope">
              <div v-if="editingPointId === scope.row.id" class="point-value-edit">
                <el-input-number
                  v-if="isNumericPoint(scope.row)"
                  v-model="editingPointValue"
                  size="small"
                  controls-position="right"
                />
                <el-select v-else-if="isBooleanPoint(scope.row)" v-model="editingPointValue"
                           size="small" placeholder="请选择">
                  <el-option label="true" value="true" />
                  <el-option label="false" value="false" />
                </el-select>
                <el-input v-else v-model="editingPointValue" size="small" placeholder="请输入下置值"
                          clearable @keyup.enter="savePointValue(scope.row)" />
                <el-tooltip content="确认下置" placement="top">
                  <el-button size="small" type="primary" icon="Check" circle
                             :loading="isWritingPoint(scope.row.id)"
                             :disabled="Boolean(writingPointId)" @click.stop="savePointValue(scope.row)" />
                </el-tooltip>
                <el-tooltip content="取消编辑" placement="top">
                  <el-button size="small" icon="Close" circle :disabled="Boolean(writingPointId)"
                             @click.stop="cancelPointEdit" />
                </el-tooltip>
              </div>
              <div v-else-if="canWritePoint(scope.row)" class="point-value-display"
                   :class="{ 'is-disabled': Boolean(writingPointId) }"
                   @click="startPointEdit(scope.row)">
                <span>{{ formatPointValue(scope.row) }}</span>
                <el-icon><EditPen /></el-icon>
              </div>
              <span v-else class="point-readonly-value">{{ formatPointValue(scope.row) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="点位值更新时间" align="center" prop="lastTime" width="180" />
          <el-table-column label="操作" align="center" width="180" class-name="small-padding fixed-width">
            <template #default="scope">
              <el-button link type="primary" icon="Edit" :disabled="isPointLocked(scope.row)"
                         @click="handleUpdate(scope.row)"
                         v-hasPermi="['iot:edgeDataPoint:edit']">修改</el-button>
              <el-button link type="danger" icon="Delete" :disabled="isPointLocked(scope.row)"
                         @click="handleDelete(scope.row)"
                         v-hasPermi="['iot:edgeDataPoint:remove']">删除</el-button>
            </template>
          </el-table-column>
          <template #empty>
            <el-empty description="暂无数据点位" />
          </template>
        </el-table>

        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
                    v-model:limit="queryParams.pageSize" @pagination="getList" />
        </section>

        <!-- 添加或修改网关数据点位对话框 -->
        <el-dialog :title="title" v-model="open" width="760px" append-to-body destroy-on-close
                   :close-on-click-modal="false" class="point-editor-dialog">
          <div class="point-editor-intro">
            <span><el-icon><Aim /></el-icon></span>
            <div>
              <strong>{{ data.operator === 'edit' ? '维护边缘点位映射' : '创建新的边缘数据点' }}</strong>
              <p>点位关联指定网关和协议，协议变化会同步刷新可配置的地址参数。</p>
            </div>
          </div>
          <el-form ref="edgeDataPointRef" :model="form" :rules="rules" label-position="top"
                   :validate-on-rule-change="false">
            <div class="point-form-section"><span>01</span>点位定义</div>
            <el-row :gutter="20">
              <el-col :xs="24" :sm="12">
                <el-form-item label="点位名称" prop="name">
                  <el-input v-model="form.name" placeholder="请输入数据点位名称" maxlength="50" show-word-limit />
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="传输协议" prop="protocolId">
                  <el-select v-model="form.protocolId" placeholder="请选择传输协议类型"
                             disabled style="width: 100%">
                    <el-option v-for="protocol in protocolsList" :key="protocol.value" :label="protocol.label"
                               :value="protocol.value" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="边缘网关" prop="gatewayId">
                  <el-select v-model="form.gatewayId" placeholder="当前网关" disabled style="width: 100%">
                    <el-option v-for="edgeDevice in availableGatewayOptions" :key="edgeDevice.value" :label="edgeDevice.label"
                               :value="edgeDevice.value" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="数据类型" prop="type">
                  <el-select v-model="form.type" placeholder="请选择数据类型" style="width: 100%">
                    <el-option v-for="dict in point_value_type" :key="dict.value" :label="dict.label"
                               :value="dict.value" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :xs="24" :sm="12">
                <el-form-item label="读写类型" prop="operationTpye">
                  <el-select v-model="form.operationTpye" placeholder="请选择读写类型" style="width: 100%">
                    <el-option v-for="dict in data_type" :key="dict.value" :label="dict.label"
                               :value="dict.value" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>

            <!-- 协议数据点位属性 -->
            <template v-if="dataPointProperties.length > 0">
              <div class="point-form-section"><span>02</span>协议点位配置</div>
              <div class="point-config-panel">
              <el-row :gutter="18">
                <el-col v-for="property in dataPointProperties" :key="property.id"
                        :xs="24" :sm="property.valueType.type === 'string' ? 24 : 12">
                  <el-form-item :label="property.name" :prop="'config.' + property.id">
                    <el-input v-if="property.valueType.type === 'string'" v-model="form.config[property.id]"
                              :placeholder="`请输入${property.name}`" clearable />

                    <el-input-number v-else-if="isNumericValueType(property.valueType)" v-model="form.config[property.id]"
                                     :min="property.valueType.min" :max="property.valueType.max"
                                     :precision="getValueTypePrecision(property.valueType)"
                                     :placeholder="`请输入${property.name}`" style="width: 100%" />

                    <el-select v-else-if="property.valueType.type === 'enum'" v-model="form.config[property.id]"
                               :multiple="property.valueType.multi" collapse-tags collapse-tags-tooltip
                               :placeholder="`请选择${property.name}`" style="width: 100%" clearable>
                      <el-option v-for="option in property.valueType.elements || []" :key="option.value"
                                 :label="option.text" :value="option.value">
                        <div class="option-content">
                          <div class="option-text">{{ option.text }}</div>
                          <div class="option-desc">{{ option.description }}</div>
                        </div>
                      </el-option>
                    </el-select>

                    <el-select v-else-if="isBooleanType(property.valueType)" v-model="form.config[property.id]"
                               :placeholder="`请选择${property.name}`" style="width: 100%" clearable>
                      <el-option v-for="option in getBooleanOptions(property.valueType)" :key="option.value"
                                 :label="option.label" :value="option.value" />
                    </el-select>

                    <el-input v-else v-model="form.config[property.id]"
                              :placeholder="`请输入${property.name}`" clearable />

                    <div v-if="property.valueType.unit" class="prop-hint">
                      单位: {{ property.valueType.unit }}
                    </div>
                    <div v-if="property.valueType.min !== undefined || property.valueType.max !== undefined"
                         class="prop-hint">
                      {{ getRangeText(property.valueType) }}
                    </div>
                    <div v-if="property.valueType.type === 'enum' && form.config[property.id]" class="prop-hint">
                      {{ getEnumDescription(property, form.config[property.id]) }}
                    </div>
                  </el-form-item>
                </el-col>
              </el-row>
              </div>
            </template>
            <el-empty v-else-if="form.protocolId" description="当前协议无需额外点位参数" :image-size="58" />
          </el-form>
          <template #footer>
            <div class="dialog-footer">
              <el-button @click="cancel">取 消</el-button>
              <el-button type="primary" :loading="submitting" @click="submitForm">
                {{ data.operator === 'edit' ? '保存修改' : '创建点位' }}
              </el-button>
            </div>
          </template>
        </el-dialog>

        <!-- 点位导入对话框 -->
        <el-dialog :title="upload.title" v-model="upload.open" width="460px" append-to-body
                   destroy-on-close class="point-import-dialog">
          <el-alert :title="`导入目标：${getGatewayLabel(queryParams.gatewayId)}`"
                    type="info" :closable="false" show-icon class="import-target-alert" />
          <el-upload ref="uploadRef" :limit="1" accept=".xlsx, .xls" :headers="upload.headers"
                     :action="upload.url + '?updateSupport=' + upload.updateSupport + '&gatewayId=' + queryParams.gatewayId"
                     :disabled="upload.isUploading" :on-progress="handleFileUploadProgress"
                     :on-success="handleFileSuccess" :on-error="handleFileError" :auto-upload="false" drag>
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
            <template #tip>
              <div class="el-upload__tip text-center">
                <div class="el-upload__tip">
                  <el-checkbox v-model="upload.updateSupport" :disabled="isGatewayRunning(queryParams.gatewayId)" />
                  是否更新已经存在的点位数据
                </div>
                <span v-if="isGatewayRunning(queryParams.gatewayId)" class="import-lock-hint">
                  网关运行中，仅允许导入新点位，不能覆盖已有点位。
                </span>
                <span>仅允许导入xls、xlsx格式文件。</span>
              </div>
            </template>
          </el-upload>
          <template #footer>
            <div class="dialog-footer">
              <el-button @click="upload.open = false">取 消</el-button>
              <el-button type="primary" :loading="upload.isUploading" @click="submitFileForm">开始导入</el-button>
            </div>
          </template>
        </el-dialog>
        </template>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup name="EdgeDataPoint">
import { getToken } from "@/utils/auth";
import { listEdgeDataPoint, listAllEdgeDataPoint, getEdgeDataPoint, delEdgeDataPoint, addEdgeDataPoint, updateEdgeDataPoint, writeEdgeDataPoint } from "@/api/iot/edgeDataPoint";
import { listAllProtocol } from "@/api/iot/protocol";
import { listAllEdgeDevice } from "@/api/iot/edgeDevice";
import IoTWorkspaceHeader from "@/components/IoTWorkspaceHeader";

const { proxy } = getCurrentInstance();
const route = useRoute();

const { data_type } = proxy.useDict('data_type');
const { point_value_type } = proxy.useDict('point_value_type');

const edgeDataPointList = ref([]);
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
const edgeDeviceList = ref([]);
const edgeDeviceCatalog = ref([]);
const gatewayInventory = ref([]);
const pointInventory = ref([]);
const globalPointInventory = ref([]);
const selectedProtocol = ref("");
const selectedEdgeDevice = ref("");
const dataPointProperties = ref([]);
const submitting = ref(false);
const editingPointId = ref(null);
const editingPointValue = ref("");
const writingPointId = ref(null);

const selectedDriver = computed(() =>
  protocolsList.value.find(item => String(item.value) === String(selectedProtocol.value))
);

const selectedGateway = computed(() => {
  return edgeDeviceList.value.find(
    item => String(item.value) === String(selectedEdgeDevice.value)
  ) || null;
});

const selectedDriverGatewayStats = computed(() =>
  getProtocolGatewayStats(selectedProtocol.value)
);

const listDataPointProperties = computed(() => {
  const protocol = protocolCatalog.value.find(
    item => String(item.id) === String(selectedProtocol.value)
  );
  const configuration = parseProtocolConfiguration(protocol?.configuration);
  return Array.isArray(configuration?.dataPointProperties)
    ? configuration.dataPointProperties
    : [];
});

const upload = reactive({
  // 是否显示弹出层（点位导入）
  open: false,
  // 弹出层标题（点位导入）
  title: "",
  // 是否禁用上传
  isUploading: false,
  // 是否更新已经存在的点位数据
  updateSupport: 0,
  // 设置上传的请求头部
  headers: { Authorization: "Bearer " + getToken() },
  // 上传的地址
  url: import.meta.env.VITE_APP_BASE_API + "/iot/edgeDataPoint/importData"
});

// 基础校验规则（点位属性规则会在此基础上动态叠加，避免污染）
const baseRules = {
  name: [{ required: true, message: "数据点位名称不能为空", trigger: "blur" }],
  protocolId: [{ required: true, message: "协议不能为空", trigger: "change" }],
  gatewayId: [{ required: true, message: "请选择边缘网关", trigger: "change" }],
  type: [{ required: true, message: "请选择数据类型", trigger: "change" }],
  operationTpye: [{ required: true, message: "请选择读写类型", trigger: "change" }]
};

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    protocolId: null, 
    gatewayId: null,
    type: null,
    operationTpye: null,
    config: null,
    value: null,
    lastTime: null,
  },
  rules: { ...baseRules },
  operator: ""
});

const { queryParams, form, rules } = toRefs(data);

const pointStats = computed(() => {
  const rows = globalPointInventory.value;
  const writable = rows.filter(canWritePoint).length;
  const onlineGateways = gatewayInventory.value.filter(item => item.linkStatus === "online").length;
  return [
    {label: "点位总数", value: rows.length, icon: "Aim", hint: "全部驱动统计"},
    {label: "可写点位", value: writable, icon: "EditPen", tone: "success", hint: "全部可下置点位"},
    {label: "网关总数", value: gatewayInventory.value.length, icon: "Cpu", tone: "warning", hint: "全部驱动统计"},
    {label: "在线网关", value: onlineGateways, icon: "CircleCheck", tone: "success", hint: "链路运行正常"},
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

const availableGatewayOptions = computed(() => {
  if (!form.value.protocolId) return edgeDeviceList.value;
  return edgeDeviceList.value.filter(item =>
    item.protocolId == null || String(item.protocolId) === String(form.value.protocolId)
  );
});

function parseProtocolConfiguration(configuration) {
  if (!configuration) return {};
  if (typeof configuration === "object") return configuration;
  try {
    return JSON.parse(configuration);
  } catch (error) {
    console.error("解析驱动配置失败:", error);
    return {};
  }
}

function getGateway(gatewayId) {
  return edgeDeviceList.value.find(item => String(item.value) === String(gatewayId));
}

function isGatewayRunning(gatewayId) {
  return getGateway(gatewayId)?.status === "enable";
}

function isPointLocked(row) {
  return isGatewayRunning(row.gatewayId);
}

function canMaintainPoint(row) {
  return !isPointLocked(row);
}

function formatDriverProperty(row, property) {
  const config = parsePointConfiguration(row.config);
  const value = config[property.id];
  if (value === null || value === undefined || value === "") return "—";
  if (property.valueType?.type === "enum") {
    const values = Array.isArray(value) ? value : [value];
    return values.map(item =>
      property.valueType.elements?.find(option => String(option.value) === String(item))?.text ?? item
    ).join("、");
  }
  if (isBooleanType(property.valueType)) {
    const normalized = String(value).toLowerCase();
    return value === true || value === 1 || normalized === "1" || normalized === "true" ? "是" : "否";
  }
  return Array.isArray(value) ? value.join("、") : String(value);
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

/** 根据协议获取数据点位属性并生成校验规则 */
const fetchDataPointProperties = async (protocolId) => {
  if (!protocolId) {
    dataPointProperties.value = [];
    rules.value = { ...baseRules };
    return;
  }
  try {
    if (!protocolCatalog.value.length) {
      await fetchProtocolList();
    }
    const protocol = protocolCatalog.value.find(item => String(item.id) === String(protocolId));
    if (!protocol) {
      dataPointProperties.value = [];
      rules.value = { ...baseRules };
      return;
    }
    let configuration = protocol.configuration;
    if (typeof configuration === "string" && configuration.length > 0) {
      configuration = JSON.parse(configuration);
    }
    if (configuration && configuration.dataPointProperties) {
      dataPointProperties.value = configuration.dataPointProperties;
      rules.value = generateRules(dataPointProperties.value);
    } else {
      dataPointProperties.value = [];
      rules.value = { ...baseRules };
    }
  } catch (error) {
    console.error("获取数据点位属性失败:", error);
    dataPointProperties.value = [];
    rules.value = { ...baseRules };
  }
};

function canWritePoint(row) {
  return String(row.operationTpye || "").toLowerCase().includes("w");
}

function isNumericPoint(row) {
  return ["int", "long", "float", "double", "number"].includes(String(row.type || "").toLowerCase());
}

function isBooleanPoint(row) {
  return ["boolean", "bool"].includes(String(row.type || "").toLowerCase());
}

function formatPointValue(row) {
  if (row.value === null || row.value === undefined || row.value === "") {
    return canWritePoint(row) ? "点击设置" : "—";
  }
  if (isBooleanPoint(row)) {
    return ["true", "1"].includes(String(row.value).toLowerCase()) ? "true" : "false";
  }
  return row.value;
}

function isWritingPoint(id) {
  return writingPointId.value === id;
}

function startPointEdit(row) {
  if (!canWritePoint(row) || writingPointId.value) return;
  editingPointId.value = row.id;
  if (isNumericPoint(row)) {
    editingPointValue.value = row.value === null || row.value === undefined || row.value === ""
      ? undefined
      : Number(row.value);
  } else if (isBooleanPoint(row)) {
    editingPointValue.value = row.value === null || row.value === undefined || row.value === ""
      ? ""
      : [true, 1, "1", "true"].includes(row.value) ? "true" : "false";
  } else {
    editingPointValue.value = row.value ?? "";
  }
}

function cancelPointEdit() {
  editingPointId.value = null;
  editingPointValue.value = "";
}

/** 显式确认后下发点位值 */
function savePointValue(row) {
  if (!editingPointId.value || writingPointId.value) return;
  if (isNumericPoint(row)) {
    const value = Number(editingPointValue.value);
    if (editingPointValue.value === null || editingPointValue.value === undefined || !Number.isFinite(value)) {
      proxy.$modal.msgWarning("请输入有效的数字");
      return;
    }
    editingPointValue.value = value;
  }
  writingPointId.value = row.id;
  writeEdgeDataPoint({
    id: row.id,
    gatewayId: row.gatewayId,
    value: editingPointValue.value
  })
    .then(() => {
      proxy.$modal.msgSuccess("下发成功");
      cancelPointEdit();
      getList();
    })
    .catch(() => {
      proxy.$modal.msgError("下发失败，请检查网关连接状态");
    })
    .finally(() => {
      writingPointId.value = null;
    });
}

/** 查询网关数据点位列表 */
function getList() {
  if (!selectedProtocol.value || !queryParams.value.gatewayId) {
    edgeDataPointList.value = [];
    total.value = 0;
    loading.value = false;
    if (selectedProtocol.value) refreshPointInventory();
    refreshGlobalPointInventory();
    return;
  }
  queryParams.value.protocolId = selectedProtocol.value;
  loading.value = true;
  listEdgeDataPoint(queryParams.value)
    .then(response => {
      edgeDataPointList.value = Array.isArray(response?.rows) ? response.rows : [];
      total.value = Number(response?.total || 0);
    })
    .catch(error => {
      edgeDataPointList.value = [];
      total.value = 0;
      console.error("获取边缘数据点列表失败:", error);
    })
    .finally(() => {
      loading.value = false;
    });
  refreshPointInventory();
  refreshGlobalPointInventory();
  fetchGatewayInventory();
}

function refreshPointInventory() {
  if (!selectedProtocol.value) return Promise.resolve();
  return listAllEdgeDataPoint({ protocolId: selectedProtocol.value })
    .then(response => {
      pointInventory.value = Array.isArray(response?.data) ? response.data : [];
    })
    .catch(error => {
      console.error("获取边缘数据点概览失败:", error);
    });
}

function refreshGlobalPointInventory() {
  return listAllEdgeDataPoint()
    .then(response => {
      globalPointInventory.value = Array.isArray(response?.data) ? response.data : [];
    })
    .catch(error => {
      console.error("获取全局边缘数据点统计失败:", error);
    });
}

function countGatewayPoints(gatewayId) {
  return pointInventory.value.filter(item => String(item.gatewayId) === String(gatewayId)).length;
}

function getGatewayLabel(gatewayId) {
  return edgeDeviceList.value.find(item => String(item.value) === String(gatewayId))?.label || gatewayId || "未选择网关";
}

// 取消按钮
function cancel() {
  open.value = false;
  reset();
}

/** 导入按钮操作 */
function handleImport() {
  if (!queryParams.value.gatewayId) {
    proxy.$modal.msgWarning("请先从左侧选择一个目标网关，再导入点位");
    return;
  }
  if (isGatewayRunning(queryParams.value.gatewayId)) {
    upload.updateSupport = 0;
  }
  upload.title = "点位导入";
  upload.open = true;
}

/** 文件上传中处理 */
const handleFileUploadProgress = (event, file, fileList) => {
  upload.isUploading = true;
};

/** 文件上传成功处理 */
const handleFileSuccess = (response, file, fileList) => {
  upload.open = false;
  upload.isUploading = false;
  proxy.$refs["uploadRef"].handleRemove(file);
  proxy.$alert(response?.msg || "点位导入完成", "导入结果");
  getList();
};

const handleFileError = () => {
  upload.isUploading = false;
  proxy.$modal.msgError("导入失败，请检查文件内容或网络状态");
};

/** 提交上传文件 */
function submitFileForm() {
  if (upload.isUploading) return;
  proxy.$refs["uploadRef"].submit();
}

// 表单重置
function reset() {
  form.value = {
    id: null,
    name: null,
    protocolId: null,
    gatewayId: null,
    type: null,
    operationTpye: null,
    config: {},
    value: null,
    lastTime: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  };
  dataPointProperties.value = [];
  rules.value = { ...baseRules };
  proxy.resetForm("edgeDataPointRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.protocolId = selectedProtocol.value;
  queryParams.value.gatewayId = selectedGateway.value?.value ?? null;
  selectedEdgeDevice.value = queryParams.value.gatewayId == null ? "" : String(queryParams.value.gatewayId);
  queryParams.value.pageNum = 1;
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  const currentGatewayId = selectedGateway.value?.value ?? null;
  proxy.resetForm("queryRef");
  queryParams.value.protocolId = selectedProtocol.value;
  queryParams.value.gatewayId = currentGatewayId;
  selectedEdgeDevice.value = currentGatewayId == null ? "" : String(currentGatewayId);
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
  if (!selectedGateway.value) {
    proxy.$modal.msgWarning("请先选择一个边缘网关");
    return;
  }
  data.operator = "add";
  reset();
  form.value.protocolId = selectedProtocol.value;
  form.value.gatewayId = selectedGateway.value.value;
  fetchDataPointProperties(form.value.protocolId);
  open.value = true;
  title.value = "添加网关数据点位";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  const _id = row?.id || ids.value[0];
  if (!_id) return;
  const selectedRow = row || edgeDataPointList.value.find(item => String(item.id) === String(_id));
  if (selectedRow && isPointLocked(selectedRow)) {
    proxy.$modal.msgWarning("网关运行中，请先停用网关后再修改点位");
    return;
  }
  data.operator = "edit";
  reset();
  getEdgeDataPoint(_id).then(response => {
    form.value = {
      ...response.data,
      config: parsePointConfiguration(response.data?.config),
    };
    open.value = true;
    title.value = "修改网关数据点位";
    fetchDataPointProperties(response.data.protocolId);
  });
}

function parsePointConfiguration(configuration) {
  if (!configuration) return {};
  if (typeof configuration === "object") return {...configuration};
  try {
    return JSON.parse(configuration);
  } catch (error) {
    console.error("解析点位配置失败:", error);
    return {};
  }
}

/** 提交按钮 */
function submitForm() {
  if (submitting.value) return;
  if (data.operator === "edit" && isGatewayRunning(form.value.gatewayId)) {
    proxy.$modal.msgWarning("网关运行中，请先停用网关后再修改点位");
    return;
  }
  proxy.$refs["edgeDataPointRef"].validate(valid => {
    if (!valid) return;
    const payload = { ...form.value, config: JSON.stringify(form.value.config) };
    const request = data.operator === "edit" ? updateEdgeDataPoint : addEdgeDataPoint;
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
  const targetRows = row
    ? [row]
    : edgeDataPointList.value.filter(item => ids.value.some(id => String(id) === String(item.id)));
  if (targetRows.some(isPointLocked)) {
    proxy.$modal.msgWarning("选中点位所属网关正在运行，请先停用网关后再删除");
    return;
  }
  proxy.$modal.confirm(`是否确认删除选中的 ${Array.isArray(_ids) ? _ids.length : 1} 个数据点位？`).then(function () {
    return delEdgeDataPoint(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => { });
}

/** 导出按钮操作 */
function handleExport() {
  if (!queryParams.value.gatewayId) {
    proxy.$modal.msgWarning("请选择一个目标网关后再导出点位");
    return;
  }
  proxy.download('iot/edgeDataPoint/export', {
    ...queryParams.value
  }, `edgeDataPoint_${new Date().getTime()}.xlsx`);
}

/** 生成校验规则：基础规则 + 点位属性规则 */
function generateRules(properties) {
  const generatedRules = { ...baseRules };
  if (!Array.isArray(properties)) {
    console.warn("点位属性必须是一个数组");
    return generatedRules;
  }
  properties.forEach(property => {
    if (!property.id || !property.name || !property.valueType) {
      console.warn("属性缺少必要信息，跳过验证规则生成");
      return;
    }
    generatedRules['config.' + property.id] = getFieldRules(property);
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

/** 获取边缘设备列表 */
const fetchEdgeDeviceList = async () => {
  if (!selectedProtocol.value) {
    edgeDeviceCatalog.value = [];
    edgeDeviceList.value = [];
    return;
  }
  try {
    const response = await listAllEdgeDevice({ protocolId: selectedProtocol.value });
    edgeDeviceCatalog.value = Array.isArray(response?.data) ? response.data : [];
    edgeDeviceList.value = edgeDeviceCatalog.value.map(item => ({
      label: item.name,
      value: item.id,
      protocolId: item.protocolId,
      linkStatus: item.linkStatus,
      status: item.status,
      elTagType: 'default'
    }));
  } catch (error) {
    console.error("获取边缘设备列表失败:", error);
  }
};

const fetchGatewayInventory = async () => {
  try {
    const response = await listAllEdgeDevice();
    gatewayInventory.value = Array.isArray(response?.data) ? response.data : [];
  } catch (error) {
    console.error("获取边缘网关统计失败:", error);
  }
};

function selectGateway(preferredGatewayId) {
  const gateway = edgeDeviceList.value.find(
    item => String(item.value) === String(preferredGatewayId)
  ) || edgeDeviceList.value[0];
  selectedEdgeDevice.value = gateway ? String(gateway.value) : "";
  queryParams.value.gatewayId = gateway?.value ?? null;
}

/** 处理侧边栏网关选择 */
function handleEdgeDeviceSelect(index) {
  selectedEdgeDevice.value = index;
  queryParams.value.gatewayId = index;
  queryParams.value.pageNum = 1;
  getList();
}

function handleGatewayQueryChange(gatewayId) {
  selectGateway(gatewayId);
  queryParams.value.pageNum = 1;
  getList();
}

async function handleProtocolSelect(protocolId) {
  selectedProtocol.value = protocolId;
  selectedEdgeDevice.value = "";
  queryParams.value.protocolId = protocolId;
  queryParams.value.gatewayId = null;
  queryParams.value.pageNum = 1;
  cancelPointEdit();
  await fetchEdgeDeviceList();
  selectGateway();
  getList();
}

function handleFormProtocolChange(protocolId) {
  form.value.config = {};
  const selectedGateway = edgeDeviceList.value.find(
    item => String(item.value) === String(form.value.gatewayId)
  );
  if (selectedGateway && String(selectedGateway.protocolId) !== String(protocolId)) {
    form.value.gatewayId = null;
  }
  fetchDataPointProperties(protocolId);
}

async function applyRouteSelection(requestedProtocol, requestedGateway) {
  const matchedProtocol = protocolsList.value.find(
    item => String(item.value) === String(requestedProtocol)
  );
  selectedProtocol.value = String(matchedProtocol?.value ?? protocolsList.value[0]?.value ?? "");
  queryParams.value.protocolId = selectedProtocol.value || null;
  queryParams.value.pageNum = 1;
  selectedEdgeDevice.value = "";
  cancelPointEdit();
  await fetchEdgeDeviceList();
  selectGateway(requestedGateway);
  getList();
}

async function initializePage() {
  await Promise.all([fetchProtocolList(), fetchGatewayInventory()]);
  await applyRouteSelection(route.query.protocolId, route.query.gatewayId);
}

const initializationPromise = initializePage();

watch(
  () => [route.path, route.query.protocolId, route.query.gatewayId],
  async ([path, protocolId, gatewayId], previousRouteSelection) => {
    if (path !== "/edge/edgeDataPoint" || previousRouteSelection == null) return;
    await initializationPromise;
    await applyRouteSelection(protocolId, gatewayId);
  }
);
</script>

<style scoped lang="scss">
.edge-point-page .app-content {
  align-items: flex-start;
}

.edge-point-page .protocol-sidebar {
  position: sticky;
  top: 14px;
  min-height: 420px;
}

.protocol-menu :deep(.el-menu-item) {
  gap: 4px;
  margin: 4px 10px;
  padding: 0 12px !important;
  border-radius: 8px;
}

.driver-menu :deep(.el-menu-item),
.gateway-menu :deep(.el-menu-item:not(:first-child)) {
  height: 58px;
}

.driver-menu-copy,
.gateway-menu-copy {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-width: 0;
  line-height: 1.25;
}

.driver-menu-copy strong,
.driver-menu-copy small,
.gateway-menu-copy strong,
.gateway-menu-copy small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.driver-menu-copy strong,
.gateway-menu-copy strong {
  color: var(--ui-text-primary);
  font-size: 12px;
}

.driver-menu-copy small,
.gateway-menu-copy small {
  margin-top: 4px;
  color: var(--ui-text-secondary);
  font-size: 9px;
}

.driver-menu-copy small {
  font-family: "SFMono-Regular", Consolas, monospace;
}

.driver-gateway-count {
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

.driver-gateway-count strong {
  color: var(--ui-text-primary);
  font-size: 12px;
}

.driver-gateway-count small {
  margin-top: 3px;
  font-size: 9px;
}

.driver-menu :deep(.el-menu-item.is-active) .driver-gateway-count {
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 10%, var(--ui-surface));
}

.gateway-scope-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 14px 14px 6px;
  padding-top: 14px;
  color: var(--ui-text-primary);
  font-size: 12px;
  font-weight: 700;
  border-top: 1px solid var(--ui-border);
}

.gateway-scope-header small {
  color: var(--ui-text-secondary);
  font-weight: 500;
}

.gateway-point-count {
  min-width: 26px;
  margin-left: auto;
  padding: 1px 7px;
  color: var(--ui-text-secondary);
  font-size: 11px;
  line-height: 20px;
  text-align: center;
  background: var(--ui-surface-soft);
  border-radius: 10px;
}

.protocol-menu :deep(.el-menu-item.is-active) .gateway-point-count {
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

.point-identity {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}

.point-identity > div {
  min-width: 0;
}

.point-identity strong,
.point-identity small {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.point-identity strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.point-identity small {
  margin-top: 3px;
  color: var(--el-color-primary);
  font-family: "SFMono-Regular", Consolas, monospace;
  font-size: 10px;
}

.point-type-icon {
  display: grid;
  flex: 0 0 34px;
  width: 34px;
  height: 34px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 9%, var(--ui-surface));
  border-radius: 9px;
}

.driver-property-header {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  color: var(--ui-text-primary);
}

.driver-property-header .el-icon {
  color: var(--ui-text-secondary);
  font-size: 13px;
}

.driver-property-value {
  color: var(--el-color-primary);
  font-family: "SFMono-Regular", Consolas, monospace;
  font-size: 12px;
  font-weight: 600;
}

.point-value-display {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  color: var(--el-color-primary);
  cursor: pointer;
  font-weight: 600;
  transition: color 0.2s ease;
}

.point-value-display:hover {
  color: var(--el-color-primary-light-3);
  text-decoration: underline;
}

.point-value-display.is-disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.point-readonly-value {
  color: var(--ui-text-primary);
  font-weight: 600;
}

.point-value-edit {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}

.point-value-edit > .el-input,
.point-value-edit > .el-select,
.point-value-edit > .el-input-number {
  width: 150px;
}

.point-value-edit > .el-input-number :deep(.el-input-number__increase),
.point-value-edit > .el-input-number :deep(.el-input-number__decrease) {
  box-sizing: border-box;
  height: 50%;
  line-height: 1;
}

.point-value-edit > .el-input-number :deep(.el-input-number__increase) {
  top: 0;
  bottom: auto;
}

.point-value-edit > .el-input-number :deep(.el-input-number__decrease) {
  top: 50%;
  bottom: auto;
}

.point-value-edit .el-button + .el-button {
  margin-left: 0;
}

.point-editor-intro {
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

.point-editor-intro > span {
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

.point-editor-intro strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.point-editor-intro p {
  margin: 3px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.point-form-section {
  display: flex;
  align-items: center;
  gap: 9px;
  margin: 2px 0 15px;
  color: var(--ui-text-primary);
  font-size: 13px;
  font-weight: 700;
}

.point-form-section span {
  display: inline-grid;
  width: 25px;
  height: 25px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 10px;
  background: color-mix(in srgb, var(--el-color-primary) 9%, transparent);
  border-radius: 7px;
}

.point-config-panel {
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

.import-target-alert {
  margin-bottom: 16px;
}

.import-lock-hint {
  display: block;
  color: var(--el-color-warning);
}

.point-import-dialog :deep(.el-upload),
.point-import-dialog :deep(.el-upload-dragger) {
  width: 100%;
}

@media (max-width: 991px) {
  .edge-point-page .protocol-sidebar {
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
