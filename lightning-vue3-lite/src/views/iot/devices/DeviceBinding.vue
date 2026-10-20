<template>
  <div class="device-binding">
    <section class="binding-console-head">
      <div>
        <span class="section-eyebrow">DATA POINT MAPPING</span>
        <h3>物模型绑定</h3>
        <p>将产品属性映射到当前网关的数据点，建立设备采集链路。</p>
      </div>
      <div class="binding-console-actions">
        <el-input
          v-model="keyword"
          clearable
          prefix-icon="Search"
          placeholder="搜索名称、标识或数据点"
          class="binding-search"
        />
        <el-segmented v-model="bindingFilter" :options="bindingFilterOptions" />
        <el-button icon="Refresh" :loading="loading" @click="getList">刷新</el-button>
      </div>
    </section>

    <el-alert
      v-if="!props.gatewayId"
      title="当前设备尚未关联边缘网关，关联网关后才能配置数据点绑定。"
      type="warning"
      :closable="false"
      show-icon
      class="gateway-warning"
    />

    <section class="binding-overview">
      <article>
        <span class="overview-icon"><el-icon><Collection /></el-icon></span>
        <div><strong>{{ bindingStats.total }}</strong><span>物模型属性</span></div>
      </article>
      <article>
        <span class="overview-icon is-success"><el-icon><CircleCheck /></el-icon></span>
        <div><strong>{{ bindingStats.bound }}</strong><span>已绑定</span></div>
      </article>
      <article>
        <span class="overview-icon is-warning"><el-icon><Link /></el-icon></span>
        <div><strong>{{ bindingStats.unbound }}</strong><span>待绑定</span></div>
      </article>
      <div class="binding-progress">
        <div>
          <span>绑定完成度</span>
          <strong>{{ bindingStats.rate }}%</strong>
        </div>
        <el-progress :percentage="bindingStats.rate" :stroke-width="8" :show-text="false" />
      </div>
    </section>

    <!-- 绑定列表 -->
    <el-table
      v-loading="loading"
      :data="filteredTemplateList"
      border
      stripe
      size="small"
      row-key="telemetryKey"
    >
      <el-table-column label="物模型名称" align="center" prop="name" min-width="130" show-overflow-tooltip />
      <el-table-column label="物模型标识" align="center" prop="telemetryKey" min-width="140" show-overflow-tooltip />
      <el-table-column label="数据类型" align="center" prop="type" width="100">
        <template #default="scope">
          <el-tag :type="getDataTypeTag(scope.row.type)" size="small" effect="plain">
            {{ scope.row.type }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="读写类型" align="center" prop="operationTpye" width="100">
        <template #default="scope">
          <el-tag
            :type="isWritable(scope.row) ? 'warning' : 'info'"
            size="small"
            effect="plain"
          >
            {{ isWritable(scope.row) ? '读写' : '只读' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="网关数据点" align="center" prop="edgePointName" min-width="150" show-overflow-tooltip>
        <template #default="scope">
          <div v-if="scope.row.edgePointName" class="point-binding">
            <el-tag size="small" type="success" effect="light">{{ scope.row.edgePointName }}</el-tag>
            <small v-if="scope.row.edgeDeviceName">{{ scope.row.edgeDeviceName }}</small>
          </div>
          <span v-else class="unbound-text"><i></i>未绑定</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" fixed="right">
        <template #default="scope">
          <el-button
            link
            type="primary"
            icon="Link"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['iot:edgeDevice:edit']"
            :disabled="!props.gatewayId"
          >{{ scope.row.bindingId ? '换绑' : '绑点' }}</el-button>
          <el-button
            link
            type="danger"
            icon="Unlink"
            @click="handleDelete(scope.row)"
            v-hasPermi="['iot:edgeDataPoint:remove']"
            :disabled="!scope.row.bindingId"
          >解绑</el-button>
        </template>
      </el-table-column>

      <template #empty>
        <el-empty :description="loading ? '加载中...' : keyword || bindingFilter !== 'all' ? '没有匹配的绑定项' : '暂无物模型数据'" />
      </template>
    </el-table>

    <!-- 绑点对话框 -->
    <el-dialog
      v-model="showDialog"
      title="配置数据点绑定"
      width="560px"
      append-to-body
      :close-on-click-modal="false"
      destroy-on-close
    >
      <div class="mapping-preview">
        <div>
          <span>设备属性</span>
          <strong>{{ form.telemetryKey || '—' }}</strong>
        </div>
        <el-icon><Right /></el-icon>
        <div>
          <span>边缘网关</span>
          <strong>{{ gatewayName }}</strong>
        </div>
        <el-icon><Right /></el-icon>
        <div>
          <span>数据点</span>
          <strong>{{ selectedPointName }}</strong>
        </div>
      </div>
      <el-form ref="bindingRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="当前绑定" v-if="form.edgePointName">
          <el-tag type="success" effect="light" closable @close="form.edgePointId = null; form.edgePointName = ''">
            {{ form.edgePointName }}
          </el-tag>
        </el-form-item>
        <el-form-item label="选择数据点" prop="edgePointId">
          <el-select
            v-model="form.edgePointId"
            placeholder="请搜索并选择数据点"
            filterable
            size="large"
            :loading="pointLoading"
            @change="handlePointChange"
            style="width: 100%"
          >
            <el-option
              v-for="item in edgeDataPointOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <div class="point-option">
                <span>{{ item.label }}</span>
                <small>ID: {{ item.value }}</small>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="数据类型" v-if="form.dataType">
          <el-tag size="small" type="info" effect="plain">{{ form.dataType }}</el-tag>
        </el-form-item>
        <el-form-item label="单位" v-if="form.unitSymbol">
          <span>{{ form.unitSymbol }}</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancel">取 消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitForm">确认绑定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="DeviceBinding">
import { listAllBinding, delBinding, addBinding, updateBinding } from "@/api/iot/binding";
import { listAllEdgeDataPoint } from "@/api/iot/edgeDataPoint";
import { listProductTemplates } from "@/api/iot/productTemplates";
import { watch } from "vue";

const { proxy } = getCurrentInstance();

const bindingList = ref([]);
const edgeDataPointOptions = ref([]);
const productTemplateList = ref([]);
const showDialog = ref(false);
const loading = ref(true);
const pointLoading = ref(false);
const submitting = ref(false);
const keyword = ref("");
const bindingFilter = ref("all");
const bindingFilterOptions = [
  {label: "全部", value: "all"},
  {label: "已绑定", value: "bound"},
  {label: "未绑定", value: "unbound"},
];

const props = defineProps({
  gatewayId: [String, Number],
  productId: [String, Number],
  id: [String, Number],
});

const data = reactive({
  form: {},
  queryParams: {
    id: null,
    productId: null,
    deviceId: null,
    productTemplateId: null,
    telemetryKey: null,
    gatewayId: null,
    edgePointId: null,
    edgePointName: null,
    value: null,
    lastTime: null,
  },
  rules: {
    edgePointId: [{required: true, message: "请选择网关数据点", trigger: "change"}],
  },
});

const { queryParams, form, rules } = toRefs(data);

const filteredTemplateList = computed(() => {
  const search = keyword.value.trim().toLowerCase();
  return productTemplateList.value.filter((item) => {
    const matchesStatus =
      bindingFilter.value === "all"
      || (bindingFilter.value === "bound" && item.bindingId)
      || (bindingFilter.value === "unbound" && !item.bindingId);
    const matchesKeyword =
      !search
      || [item.name, item.telemetryKey, item.edgePointName, item.edgeDeviceName]
        .some((field) => String(field || "").toLowerCase().includes(search));
    return matchesStatus && matchesKeyword;
  });
});

const bindingStats = computed(() => {
  const total = productTemplateList.value.length;
  const bound = productTemplateList.value.filter(item => item.bindingId).length;
  return {
    total,
    bound,
    unbound: total - bound,
    rate: total ? Math.round((bound / total) * 100) : 0,
  };
});

const selectedPointName = computed(() => {
  const point = edgeDataPointOptions.value.find(item => String(item.value) === String(form.value.edgePointId));
  return point?.label || "待选择";
});

const gatewayName = computed(() => form.value.edgeDeviceName || props.gatewayId || "未关联网关");

function handlePointChange(pointId) {
  const point = edgeDataPointOptions.value.find(item => String(item.value) === String(pointId));
  form.value.edgePointName = point?.label || "";
}

/** 数据类型标签映射 */
function getDataTypeTag(type) {
  const map = {
    int: "primary",
    long: "primary",
    float: "success",
    double: "success",
    string: "warning",
    bool: "danger",
    boolean: "danger",
    enum: "info",
    date: "warning",
    text: "",
  };
  return map[type?.toLowerCase()] || "info";
}

/** 获取数据点选项 */
async function getEdgeDataPointOptions() {
  if (!props.gatewayId) {
    edgeDataPointOptions.value = [];
    return;
  }
  pointLoading.value = true;
  try {
    const response = await listAllEdgeDataPoint({gatewayId: props.gatewayId});
    edgeDataPointOptions.value = (Array.isArray(response?.data) ? response.data : []).map((item) => ({
      value: item.id,
      label: item.name,
      elTagType: "default",
    }));
  } catch (error) {
    edgeDataPointOptions.value = [];
    console.error("获取网关数据点失败:", error);
  } finally {
    pointLoading.value = false;
  }
}

function isWritable(row) {
  return String(row.operationTpye || "").toLowerCase().includes("w");
}

/** 查询绑定列表 */
async function getList() {
  loading.value = true;
  try {
    queryParams.value.productId = props.productId;
    queryParams.value.deviceId = props.id;
    const [bindingResponse, templateResponse] = await Promise.all([
      listAllBinding(queryParams.value),
      listProductTemplates(queryParams.value),
    ]);
    bindingList.value = Array.isArray(bindingResponse?.data) ? bindingResponse.data : [];
    const bindingMap = new Map(bindingList.value.map(item => [item.telemetryKey, item]));
    const templates = Array.isArray(templateResponse?.data) ? templateResponse.data : [];

    productTemplateList.value = templates.map((item) => {
      const binding = bindingMap.get(item.telemetryKey);
      return {
        ...item,
        edgePointId: binding?.edgePointId,
        gatewayId: binding?.gatewayId,
        edgeDeviceName: binding?.edgeDeviceName,
        edgePointName: binding?.edgePointName,
        bindingId: binding?.id,
      };
    });
  } catch (error) {
    console.error("获取绑定数据时发生错误:", error);
  } finally {
    loading.value = false;
  }
}

/** 表单重置 */
function reset() {
  form.value = {
    id: null,
    productId: null,
    deviceId: null,
    productTemplateId: null,
    telemetryKey: null,
    gatewayId: null,
    edgePointId: null,
    edgePointName: null,
    edgeDeviceName: null,
    dataType: null,
    unitSymbol: null,
    value: null,
    lastTime: null,
  };
  proxy.resetForm("bindingRef");
}

/** 取消 */
function cancel() {
  showDialog.value = false;
  reset();
}

/** 绑点/换绑 */
function handleUpdate(row) {
  if (!props.gatewayId) {
    proxy.$modal.msgWarning("请先为设备关联边缘网关");
    return;
  }
  reset();
  showDialog.value = true;
  form.value.id = row.bindingId;
  form.value.productId = props.productId;
  form.value.deviceId = props.id;
  form.value.productTemplateId = row.id;
  form.value.telemetryKey = row.telemetryKey;
  form.value.gatewayId = props.gatewayId;
  form.value.edgePointId = row.edgePointId;
  form.value.edgePointName = row.edgePointName;
  form.value.edgeDeviceName = row.edgeDeviceName;
  form.value.dataType = row.type;

  if (row.define) {
    try {
      const define = JSON.parse(row.define);
      form.value.unitSymbol = define.valueType?.unit || "";
    } catch {
      form.value.unitSymbol = "";
    }
  }
}

/** 提交绑定 */
function submitForm() {
  proxy.$refs["bindingRef"].validate((valid) => {
    if (!valid) return;
    submitting.value = true;
    const action = form.value.id != null ? updateBinding(form.value) : addBinding(form.value);
    action
      .then(() => {
        proxy.$modal.msgSuccess(form.value.id != null ? "换绑成功" : "绑定成功");
        showDialog.value = false;
        getList();
      })
      .finally(() => {
        submitting.value = false;
      });
  });
}

/** 解绑 */
function handleDelete(row) {
  const idsToDelete = row.bindingId;
  proxy.$modal
    .confirm('是否确认解绑设备属性标识 "' + row.telemetryKey + '" 的数据项？')
    .then(() => delBinding(idsToDelete))
    .then(() => {
      getList();
      proxy.$modal.msgSuccess("解绑成功");
    })
    .catch(() => {});
}

watch(
  () => [props.productId, props.id, props.gatewayId],
  ([productId, deviceId]) => {
    queryParams.value.productId = productId;
    queryParams.value.deviceId = deviceId;
    if (productId && deviceId) getList();
    getEdgeDataPointOptions();
  },
  {immediate: true}
);
</script>

<style lang="scss" scoped>
.device-binding {
  width: 100%;
}

.binding-console-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 14px;
}

.section-eyebrow {
  display: block;
  margin-bottom: 3px;
  color: var(--el-color-primary);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.13em;
}

.binding-console-head h3 {
  margin: 0;
  color: var(--ui-text-primary);
  font-size: 17px;
}

.binding-console-head p {
  margin: 5px 0 0;
  color: var(--ui-text-secondary);
  font-size: 12px;
}

.binding-console-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
}

.binding-search {
  width: 240px;
}

.gateway-warning {
  margin-bottom: 14px;
}

.binding-overview {
  display: grid;
  grid-template-columns: repeat(3, minmax(120px, 0.65fr)) minmax(220px, 1.3fr);
  gap: 10px;
  margin-bottom: 14px;
}

.binding-overview article,
.binding-progress {
  min-width: 0;
  padding: 11px 13px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.binding-overview article {
  display: flex;
  align-items: center;
  gap: 10px;
}

.binding-overview article > div {
  display: flex;
  flex-direction: column;
}

.binding-overview strong {
  color: var(--ui-text-primary);
  font-size: 19px;
  line-height: 1.1;
}

.binding-overview article span:not(.overview-icon),
.binding-progress span {
  margin-top: 3px;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.overview-icon {
  display: grid;
  flex: 0 0 32px;
  width: 32px;
  height: 32px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 10%, transparent);
  border-radius: 8px;
}

.overview-icon.is-success {
  color: var(--el-color-success);
  background: color-mix(in srgb, var(--el-color-success) 10%, transparent);
}

.overview-icon.is-warning {
  color: var(--el-color-warning);
  background: color-mix(in srgb, var(--el-color-warning) 10%, transparent);
}

.binding-progress {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.binding-progress > div {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

.binding-progress strong {
  font-size: 15px;
}

.device-binding :deep(.el-table) {
  border-radius: 10px;
}

.point-binding {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
}

.point-binding small {
  max-width: 120px;
  overflow: hidden;
  color: var(--ui-text-secondary);
  font-size: 11px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.unbound-text {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--el-color-warning);
  font-size: 12px;
}

.unbound-text i {
  width: 6px;
  height: 6px;
  background: currentColor;
  border-radius: 50%;
}

.mapping-preview {
  display: grid;
  grid-template-columns: 1fr auto 1fr auto 1fr;
  align-items: center;
  gap: 10px;
  margin-bottom: 22px;
  padding: 14px;
  background: linear-gradient(135deg, var(--ui-surface-soft), color-mix(in srgb, var(--el-color-primary) 5%, var(--ui-surface)));
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.mapping-preview > div {
  min-width: 0;
}

.mapping-preview span {
  display: block;
  margin-bottom: 4px;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.mapping-preview strong {
  display: block;
  overflow: hidden;
  color: var(--ui-text-primary);
  font-size: 12px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.mapping-preview > .el-icon {
  color: var(--el-color-primary);
}

.point-option {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.point-option small {
  color: var(--ui-text-secondary);
  font-size: 11px;
}

// 空状态间距
:deep(.el-empty) {
  padding: 20px 0;
}

@media (max-width: 980px) {
  .binding-console-head {
    flex-direction: column;
  }

  .binding-console-actions {
    width: 100%;
    justify-content: flex-start;
    flex-wrap: wrap;
  }

  .binding-overview {
    grid-template-columns: repeat(3, 1fr);
  }

  .binding-progress {
    grid-column: 1 / -1;
  }
}

@media (max-width: 640px) {
  .binding-search {
    width: 100%;
  }

  .binding-overview {
    grid-template-columns: 1fr;
  }

  .binding-progress {
    grid-column: auto;
  }

  .mapping-preview {
    grid-template-columns: 1fr;
  }

  .mapping-preview > .el-icon {
    transform: rotate(90deg);
  }
}
</style>
