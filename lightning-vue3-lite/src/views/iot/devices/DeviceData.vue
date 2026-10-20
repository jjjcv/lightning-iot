<template>
  <div class="device-data">
    <section class="data-console-head">
      <div>
        <span class="section-eyebrow">REAL-TIME TELEMETRY</span>
        <h3>实时属性</h3>
        <p>查看设备最新上报值，可写属性支持直接下置。</p>
      </div>
      <div class="data-console-actions">
        <span class="refresh-state" :class="{ 'is-error': refreshError }">
          <i></i>
          {{ refreshError ? '刷新异常' : lastRefreshedText }}
        </span>
        <el-input
          v-model="keyword"
          clearable
          prefix-icon="Search"
          placeholder="搜索名称或标识"
          class="property-search"
        />
        <el-tooltip content="开启后每 5 秒静默刷新" placement="top">
          <el-switch
            v-model="autoRefresh"
            inline-prompt
            active-text="自动"
            inactive-text="手动"
          />
        </el-tooltip>
        <el-button icon="Refresh" :loading="loading" @click="getList(true)">刷新</el-button>
      </div>
    </section>

    <section class="data-overview">
      <article>
        <span class="overview-icon"><el-icon><Collection /></el-icon></span>
        <div><strong>{{ dataStats.total }}</strong><span>属性总数</span></div>
      </article>
      <article>
        <span class="overview-icon is-success"><el-icon><EditPen /></el-icon></span>
        <div><strong>{{ dataStats.writable }}</strong><span>可写属性</span></div>
      </article>
      <article>
        <span class="overview-icon is-cyan"><el-icon><Link /></el-icon></span>
        <div><strong>{{ dataStats.reported }}</strong><span>已有数据</span></div>
      </article>
      <article>
        <span class="overview-icon is-warning"><el-icon><Clock /></el-icon></span>
        <div><strong>{{ dataStats.pending }}</strong><span>等待上报</span></div>
      </article>
    </section>

    <el-table
        v-loading="loading"
        :data="filteredTemplateList"
        border
        stripe
        size="small"
        row-key="telemetryKey"
    >
      <el-table-column label="物模型名称" align="center" prop="name" min-width="130" show-overflow-tooltip/>
      <el-table-column label="物模型标识" align="center" prop="telemetryKey" min-width="140" show-overflow-tooltip/>
      <el-table-column label="数据类型" align="center" prop="type" width="100">
        <template #default="scope">
          <el-tag :type="getDataTypeTag(scope.row.type)" size="small" effect="plain">
            {{ scope.row.type }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="读写类型" align="center" prop="operationTpye" width="90">
        <template #default="scope">
          <dict-tag :options="data_type" :value="scope.row.operationTpye"/>
        </template>
      </el-table-column>
      <el-table-column label="属性值" align="center" prop="value" min-width="230">
        <template #default="scope">
          <template v-if="editingTelemetryKey === scope.row.telemetryKey">
            <div class="inline-value-editor">
              <!-- 枚举类型：下拉选择枚举项 -->
              <el-select
                  v-if="scope.row.type === 'enum'"
                  ref="inlineEditorRef"
                  v-model="editingValue"
                  size="small"
                  placeholder="请选择"
                  @keyup.escape="cancelInlineEdit"
              >
                <el-option
                    v-for="el in scope.row.valueType?.elements || []"
                    :key="el.value"
                    :label="el.text"
                    :value="el.value"
                />
              </el-select>
              <!-- 布尔类型：true/false 选择 -->
              <el-select
                  v-else-if="['boolean', 'bool'].includes(scope.row.type)"
                  ref="inlineEditorRef"
                  v-model="editingValue"
                  size="small"
                  placeholder="请选择"
                  @keyup.escape="cancelInlineEdit"
              >
                <el-option
                    :label="getBooleanText(scope.row.valueType, 'trueText', '是')"
                    :value="scope.row.valueType?.trueValue ?? 'true'"
                />
                <el-option
                    :label="getBooleanText(scope.row.valueType, 'falseText', '否')"
                    :value="scope.row.valueType?.falseValue ?? 'false'"
                />
              </el-select>
              <!-- 数字类型：步进仅调整草稿，确认后才下置 -->
              <el-input-number
                  v-else-if="['int', 'long', 'float', 'double'].includes(scope.row.type)"
                  ref="inlineEditorRef"
                  v-model="editingValue"
                  size="small"
                  controls-position="right"
                  :min="scope.row.valueType?.min ?? undefined"
                  :max="scope.row.valueType?.max ?? undefined"
                  :precision="getValuePrecision(scope.row)"
                  @keyup.enter="submitInlineValue(scope.row)"
                  @keyup.escape="cancelInlineEdit"
              />
              <!-- 日期类型：日期时间选择 -->
              <el-date-picker
                  v-else-if="scope.row.type === 'date'"
                  ref="inlineEditorRef"
                  v-model="editingValue"
                  type="datetime"
                  size="small"
                  placeholder="选择日期时间"
                  :format="scope.row.valueType?.format || 'YYYY-MM-DD HH:mm:ss'"
                  value-format="YYYY-MM-DD HH:mm:ss"
                  @keyup.escape="cancelInlineEdit"
              />
              <!-- 字符串及其它类型：文本输入框 -->
              <el-input
                  v-else
                  ref="inlineEditorRef"
                  v-model="editingValue"
                  size="small"
                  placeholder="输入新值"
                  clearable
                  :maxlength="scope.row.valueType?.maxLength || undefined"
                  @keyup.enter="submitInlineValue(scope.row)"
                  @keyup.escape="cancelInlineEdit"
              />
              <div class="inline-editor-actions">
                <el-tooltip content="确认下置" placement="top">
                  <el-button
                      type="primary"
                      icon="Check"
                      circle
                      size="small"
                      :disabled="!hasInlineValueChanged"
                      @click.stop="submitInlineValue(scope.row)"
                  />
                </el-tooltip>
                <el-tooltip content="取消编辑" placement="top">
                  <el-button icon="Close" circle size="small" @click.stop="cancelInlineEdit" />
                </el-tooltip>
              </div>
            </div>
          </template>
          <el-button
              v-else-if="canWrite(scope.row) && scope.row.value !== null && scope.row.value !== undefined"
              type="primary"
              link
              class="property-value is-writable"
              :loading="writingTelemetryKey === scope.row.telemetryKey"
              :disabled="Boolean(writingTelemetryKey)"
              @click="startInlineEdit(scope.row)"
          >
            {{ formatDisplayValue(scope.row) }}
            <el-icon><EditPen /></el-icon>
          </el-button>
          <span
              v-else-if="canWrite(scope.row)"
              class="no-value is-writable"
              :class="{ 'is-disabled': Boolean(writingTelemetryKey) }"
              @click="startInlineEdit(scope.row)"
          >{{ writingTelemetryKey === scope.row.telemetryKey ? '写入中…' : '点击设置' }}</span>
          <span v-else class="property-value">
            {{ scope.row.value !== null && scope.row.value !== undefined ? formatDisplayValue(scope.row) : '-' }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="单位" align="center" prop="unit" width="60"/>
      <el-table-column label="更新时间" align="center" prop="lastTime" width="175" show-overflow-tooltip/>
      <el-table-column label="历史记录" align="center" width="110" fixed="right">
        <template #default="scope">
          <el-button
              link
              type="primary"
              icon="Histogram"
              @click="queryHistory(scope.row)"
          >历史记录
          </el-button>
        </template>
      </el-table-column>

      <template #empty>
        <el-empty :description="loading ? '加载中...' : keyword ? '没有匹配的属性' : '暂无物模型属性'"/>
      </template>
    </el-table>

    <!-- 历史记录对话框 -->
    <el-dialog
        v-model="showHistoryDialog"
        title="历史记录"
        width="920px"
        append-to-body
        :close-on-click-modal="false"
        class="history-dialog"
        destroy-on-close
    >
      <!-- 属性信息 -->
      <div class="history-info-bar">
        <span class="history-info-item">
          <span class="info-label">属性：</span>
          <el-tag size="small" type="info" effect="plain">{{ form.telemetryKey }}</el-tag>
        </span>
        <span class="history-info-item" v-if="form.unit">
          <span class="info-label">单位：</span>{{ form.unit }}
        </span>
      </div>

      <!-- 时间筛选 -->
      <div class="history-filter">
        <el-date-picker
            v-model="dateRangeHistory"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            format="YYYY-MM-DD HH:mm"
            value-format="YYYY-MM-DD HH:mm:ss"
            :default-time="[new Date(2000, 0, 1), new Date(2000, 0, 1, 23, 59, 59)]"
            style="flex: 1"
        />
        <div class="history-shortcuts">
          <el-button @click="setHistoryRange(1)">近 1 小时</el-button>
          <el-button @click="setHistoryRange(24)">近 24 小时</el-button>
          <el-button type="primary" :loading="historyLoading" @click="fetchHistoryData">查询</el-button>
        </div>
      </div>

      <div v-if="chartsDisplay" class="history-summary">
        <span>数据点 <strong>{{ historyStats.count }}</strong></span>
        <span>最大值 <strong>{{ historyStats.max }}</strong></span>
        <span>最小值 <strong>{{ historyStats.min }}</strong></span>
        <span>平均值 <strong>{{ historyStats.average }}</strong></span>
      </div>

      <!-- 图表 -->
      <div v-loading="historyLoading" class="chart-container">
        <div v-show="chartsDisplay" ref="chartRef" class="echarts"></div>
        <el-empty v-show="!chartsDisplay && !historyLoading" description="当前时间范围暂无历史数据"/>
      </div>
    </el-dialog>
  </div>
</template>

<script setup name="DeviceData">
import {listAllBinding} from "@/api/iot/binding";
import {writeDevices} from "@/api/iot/devices";
import {listProductTemplates} from "@/api/iot/productTemplates";
import {listDeviceHistoryAll} from "@/api/iot/deviceHistory";
import moment from "moment";
import * as echarts from "echarts";
import {nextTick, onBeforeUnmount, onMounted, watch} from "vue";

const {proxy} = getCurrentInstance();
const {data_type} = proxy.useDict('data_type');

const chartRef = ref(null);
let chartInstance = null;

const bindingList = ref([]);
const productTemplateList = ref([]);
const showHistoryDialog = ref(false);
const chartsDisplay = ref(false);
const dateRangeHistory = ref([]);
const loading = ref(true);
const historyLoading = ref(false);
const historyPoints = ref([]);
const keyword = ref("");
const autoRefresh = ref(true);
const lastRefreshedAt = ref(null);
const refreshError = ref(false);

const editingTelemetryKey = ref(null);
const editingValue = ref("");
const editingOriginalValue = ref("");
const inlineEditorRef = ref(null);
const writingTelemetryKey = ref(null);

// 自动刷新定时器与并发标记
let refreshTimer = null;
let isRefreshing = false;

const props = defineProps({
  productId: [String, Number],
  id: [String, Number],
});

const data = reactive({
  form: {},
  queryParams: {
    productId: props.productId,
    deviceId: props.id,
  },
    option: {
    tooltip: {
      trigger: "axis",
      axisPointer: {
        type: "cross",
        label: {
          backgroundColor: "#0b1c31",
        },
      },
    },
    legend: {
      data: ["历史记录"],
      top: "bottom",
      left: "center",
    },
    toolbox: {
      feature: {
        saveAsImage: {title: "保存图片"},
        dataView: {title: "数据视图"},
      },
    },
    dataZoom: [
      {type: "slider", start: 0, end: 100, height: 24, bottom: 10},
      {type: "inside", start: 0, end: 100},
    ],
    grid: {
      left: 60,
      right: 24,
      top: 40,
      bottom: 60,
    },
    xAxis: [
      {
        type: "time",
        boundaryGap: false,
        axisLabel: {
          formatter: {
            type: "time",
            template: "{HH}:{mm}",
          },
        },
      },
    ],
    yAxis: [
      {
        type: "value",
        splitLine: {
          lineStyle: {
            type: "dashed",
          },
        },
      },
    ],
    series: [
      {
        name: "历史记录",
        type: "line",
        smooth: true,
        symbol: "none",
        lineStyle: {
          width: 2,
          color: "#06b6d4",
        },
        itemStyle: { color: "#06b6d4" },
        areaStyle: {
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              {offset: 0, color: "rgba(6,182,212,0.34)"},
              {offset: 1, color: "rgba(37,99,235,0.02)"},
            ],
          },
        },
        emphasis: {
          focus: "series",
        },
        data: [],
        markPoint: {
          data: [
            {type: "max", name: "最大值"},
            {type: "min", name: "最小值"},
          ],
        },
        markLine: {
          data: [{type: "average", name: "平均值"}],
          label: {
            formatter: "平均: {c}",
          },
        },
      },
    ],
  },
});

const {queryParams, form, option} = toRefs(data);

const filteredTemplateList = computed(() => {
  const value = keyword.value.trim().toLowerCase();
  if (!value) return productTemplateList.value;
  return productTemplateList.value.filter((item) =>
    [item.name, item.telemetryKey, item.type]
      .some((field) => String(field || "").toLowerCase().includes(value))
  );
});

const dataStats = computed(() => {
  const rows = productTemplateList.value;
  const reported = rows.filter(hasValue).length;
  return {
    total: rows.length,
    writable: rows.filter(canWrite).length,
    reported,
    pending: rows.length - reported,
  };
});

const lastRefreshedText = computed(() => {
  if (!lastRefreshedAt.value) return "等待首次刷新";
  return `更新于 ${moment(lastRefreshedAt.value).format("HH:mm:ss")}`;
});

const hasInlineValueChanged = computed(() =>
  String(editingValue.value ?? "") !== String(editingOriginalValue.value ?? "")
);

const historyStats = computed(() => {
  const values = historyPoints.value
    .map((item) => Number(item.value?.[1]))
    .filter(Number.isFinite);
  if (!values.length) return {count: historyPoints.value.length, max: "-", min: "-", average: "-"};
  const total = values.reduce((sum, value) => sum + value, 0);
  return {
    count: historyPoints.value.length,
    max: Math.max(...values),
    min: Math.min(...values),
    average: Number((total / values.length).toFixed(2)),
  };
});

function hasValue(row) {
  return row.value !== null && row.value !== undefined && row.value !== "";
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

/** 数字类型的精度：整型为 0，浮点型取定义的小数位数 */
function getValuePrecision(row) {
  if (["int", "long"].includes(row.type)) return 0;
  if (["float", "double"].includes(row.type)) return row.valueType?.scale ?? undefined;
  return undefined;
}

/** 展示值格式化：枚举/布尔显示对应文本 */
function formatDisplayValue(row) {
  const value = row.value;
  if (value === null || value === undefined) return value;
  if (row.type === "enum") {
    const el = (row.valueType?.elements || []).find(
        (e) => String(e.value) === String(value)
    );
    return el ? el.text : value;
  }
  if (["boolean", "bool"].includes(row.type)) {
    const vt = row.valueType || {};
    if (String(value) === String(vt.trueValue ?? "true")) return getBooleanText(vt, "trueText", "是");
    if (String(value) === String(vt.falseValue ?? "false")) return getBooleanText(vt, "falseText", "否");
  }
  return value;
}

function getBooleanText(valueType, key, fallback) {
  return valueType?.[key] || fallback;
}

/** 查询设备属性列表 */
async function getList(showLoading = true) {
  // 避免自动刷新与手动请求叠加
  if (isRefreshing) return;
  isRefreshing = true;
  if (showLoading) loading.value = true;
  refreshError.value = false;

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
      let valueType = {};
      if (item.define) {
        try {
          const define = JSON.parse(item.define);
          valueType = define.valueType || {};
        } catch {
          valueType = {};
        }
      }
      return {
        ...item,
        value: binding?.value,
        lastTime: binding?.lastTime,
        valueType,
        unit: valueType.unit || "",
      };
    });
    lastRefreshedAt.value = new Date();
  } catch (error) {
    refreshError.value = true;
    console.error("获取数据时发生错误:", error);
  } finally {
    if (showLoading) loading.value = false;
    isRefreshing = false;
  }
}

/** 查询历史数据 */
async function fetchHistoryData() {
  if (historyLoading.value) return;
  if (!dateRangeHistory.value || dateRangeHistory.value.length !== 2) {
    proxy.$modal.msgWarning("请选择时间范围");
    return;
  }

  const params = {
    productId: props.productId,
    deviceId: props.id,
    telemetryKey: form.value.telemetryKey,
    startTime: dateRangeHistory.value[0],
    endTime: dateRangeHistory.value[1],
  };

  historyLoading.value = true;
  try {
    const response = await listDeviceHistoryAll(params);
    const historyData = (Array.isArray(response?.data) ? response.data : []).map((item) => ({
      name: item.telemetryKey,
      value: [item.createTime, item.value],
    }));

    historyPoints.value = historyData;
    option.value.series[0].data = historyData;
    option.value.dataZoom = [
      {type: "slider", start: 0, end: 100, height: 24, bottom: 10},
      {type: "inside", start: 0, end: 100},
    ];
    chartsDisplay.value = historyData.length > 0;
    if (chartsDisplay.value) renderChart();
  } catch (error) {
    chartsDisplay.value = false;
    historyPoints.value = [];
    console.error("获取历史数据时发生错误:", error);
    proxy.$modal.msgError("历史数据加载失败");
  } finally {
    historyLoading.value = false;
  }
}

function setHistoryRange(hours) {
  dateRangeHistory.value = [
    moment().subtract(hours, "h").format("YYYY-MM-DD HH:mm:ss"),
    moment().format("YYYY-MM-DD HH:mm:ss"),
  ];
  fetchHistoryData();
}

/** 渲染/更新 ECharts 图表 */
function renderChart() {
  nextTick(() => {
    if (!chartRef.value) return;
    if (!chartInstance) {
      chartInstance = echarts.init(chartRef.value);
    }
    chartInstance.setOption(option.value);
    chartInstance.resize();
  });
}

/** 窗口尺寸变化时自适应 */
function handleResize() {
  chartInstance && chartInstance.resize();
}

onMounted(() => {
  window.addEventListener("resize", handleResize);
  // 页面可见且未编辑时，每 5 秒静默刷新。
  refreshTimer = setInterval(() => {
    if (!autoRefresh.value || document.hidden || editingTelemetryKey.value || writingTelemetryKey.value) return;
    getList(false);
  }, 5000);
});

watch(
  () => [props.productId, props.id],
  ([productId, deviceId]) => {
    queryParams.value.productId = productId;
    queryParams.value.deviceId = deviceId;
    if (productId && deviceId) getList(true);
  },
  {immediate: true}
);

watch(showHistoryDialog, (visible) => {
  if (!visible && chartInstance) {
    chartInstance.dispose();
    chartInstance = null;
  }
});

onBeforeUnmount(() => {
  window.removeEventListener("resize", handleResize);
  if (refreshTimer) {
    clearInterval(refreshTimer);
    refreshTimer = null;
  }
  if (chartInstance) {
    chartInstance.dispose();
    chartInstance = null;
  }
});

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
    value: null,
    lastTime: null,
  };
}

/** 是否可写（下发）：读写类型包含 w 写 */
function canWrite(row) {
  return String(row.operationTpye || "").toLowerCase().includes("w");
}

/** 开始行内编辑 */
function startInlineEdit(row) {
  if (writingTelemetryKey.value) return;
  // 只读属性不允许设置属性值
  if (!canWrite(row)) {
    proxy.$modal.msgWarning("该属性不可写，无法下发");
    return;
  }
  editingTelemetryKey.value = row.telemetryKey;
  if (["int", "long", "float", "double"].includes(row.type)) {
    // 数字类型转换为数值，空值保持为 undefined 以便输入
    editingValue.value =
        row.value !== null && row.value !== undefined && row.value !== ""
            ? Number(row.value)
            : undefined;
  } else {
    editingValue.value = row.value ?? "";
  }
  editingOriginalValue.value = editingValue.value;
  nextTick(() => {
    const editor = Array.isArray(inlineEditorRef.value) ? inlineEditorRef.value[0] : inlineEditorRef.value;
    editor?.focus?.();
  });
}

/** 取消行内编辑 */
function cancelInlineEdit() {
  editingTelemetryKey.value = null;
  editingValue.value = "";
  editingOriginalValue.value = "";
}

/** 提交行内写入 */
function submitInlineValue(row) {
  if (!editingTelemetryKey.value || writingTelemetryKey.value) return;
  if (!hasInlineValueChanged.value) {
    cancelInlineEdit();
    return;
  }
  if (["int", "long", "float", "double"].includes(row.type)) {
    const numericValue = Number(editingValue.value);
    if (editingValue.value === null || editingValue.value === undefined || !Number.isFinite(numericValue)) {
      proxy.$modal.msgWarning("请输入有效的数字");
      return;
    }
    const min = row.valueType?.min;
    const max = row.valueType?.max;
    if (min != null && numericValue < Number(min)) {
      proxy.$modal.msgWarning(`属性值不能小于 ${min}`);
      return;
    }
    if (max != null && numericValue > Number(max)) {
      proxy.$modal.msgWarning(`属性值不能大于 ${max}`);
      return;
    }
    editingValue.value = numericValue;
  }
  const key = editingTelemetryKey.value;
  editingTelemetryKey.value = null; // 防止 blur 二次触发
  writingTelemetryKey.value = key;

  const params = {
    productId: props.productId,
    deviceId: props.id,
    productTemplateId: row.id,
    telemetryKey: key,
    value: editingValue.value,
  };

  writeDevices(params)
      .then((response) => {
        proxy.$modal.msgSuccess(response.data || "写入成功");
        editingValue.value = "";
        editingOriginalValue.value = "";
        getList();
      })
      .catch(() => {
        proxy.$modal.msgError("写入失败");
        editingValue.value = "";
        editingOriginalValue.value = "";
      })
      .finally(() => {
        writingTelemetryKey.value = null;
      });
}

/** 查看历史记录 */
function queryHistory(row) {
  reset();
  showHistoryDialog.value = true;
  form.value.productId = props.productId;
  form.value.deviceId = props.id;
  form.value.productTemplateId = row.id;
  form.value.telemetryKey = row.telemetryKey;
  form.value.value = row.value;
  form.value.unit = row.unit;

  // 默认最近1小时
  dateRangeHistory.value = [
    moment().subtract(1, "h").format("YYYY-MM-DD HH:mm:ss"),
    moment().format("YYYY-MM-DD HH:mm:ss"),
  ];

  chartsDisplay.value = false;

  nextTick(() => {
    fetchHistoryData();
  });
}
</script>

<style lang="scss" scoped>
.device-data {
  width: 100%;
}

.data-console-head {
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

.data-console-head h3 {
  margin: 0;
  color: var(--ui-text-primary);
  font-size: 17px;
}

.data-console-head p {
  margin: 5px 0 0;
  color: var(--ui-text-secondary);
  font-size: 12px;
}

.data-console-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
}

.property-search {
  width: 210px;
}

.refresh-state {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--ui-text-secondary);
  font-size: 12px;
  white-space: nowrap;
}

.refresh-state i {
  width: 7px;
  height: 7px;
  background: var(--el-color-success);
  border-radius: 50%;
  box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-success) 12%, transparent);
}

.refresh-state.is-error i {
  background: var(--el-color-danger);
  box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-danger) 12%, transparent);
}

.data-overview {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
  margin-bottom: 14px;
}

.data-overview article {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
  padding: 11px 13px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.data-overview article > div {
  display: flex;
  flex-direction: column;
}

.data-overview strong {
  color: var(--ui-text-primary);
  font-size: 19px;
  line-height: 1.1;
}

.data-overview article span:not(.overview-icon) {
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

.overview-icon.is-cyan {
  color: var(--ui-accent-cyan);
  background: color-mix(in srgb, var(--ui-accent-cyan) 10%, transparent);
}

.overview-icon.is-warning {
  color: var(--el-color-warning);
  background: color-mix(in srgb, var(--el-color-warning) 10%, transparent);
}

.device-data :deep(.el-table) {
  border-radius: 10px;
}

.property-value {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  color: var(--ui-text-primary);
  font-weight: 600;
}

.property-value.is-writable {
  max-width: 100%;
}

.no-value {
  color: var(--ui-text-placeholder);
}

.no-value.is-writable {
  cursor: pointer;
  color: var(--el-color-primary);
  font-size: 12px;
}

.no-value.is-disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.inline-value-editor {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  width: 100%;
}

.inline-value-editor > .el-select,
.inline-value-editor > .el-input,
.inline-value-editor > .el-input-number,
.inline-value-editor > .el-date-editor {
  flex: 1;
  min-width: 0;
  width: 145px;
}

.inline-editor-actions {
  display: inline-flex;
  flex: 0 0 auto;
  align-items: center;
  gap: 4px;
}

.inline-editor-actions .el-button + .el-button {
  margin-left: 0;
}

// 历史记录对话框
.history-dialog {
  .history-info-bar {
    display: flex;
    align-items: center;
    gap: 20px;
    background: var(--ui-surface-soft);
    padding: 10px 16px;
    border-radius: 6px;
    margin-bottom: 12px;
    font-size: 13px;
  }

  .history-info-item {
    display: flex;
    align-items: center;
    gap: 4px;
  }

  .info-label {
    color: var(--ui-text-secondary);
  }

  .history-filter {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
  }

  .history-shortcuts {
    display: flex;
    flex-shrink: 0;
  }

  .history-summary {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 8px;
    margin-bottom: 12px;
  }

  .history-summary span {
    padding: 9px 12px;
    color: var(--ui-text-secondary);
    font-size: 12px;
    background: var(--ui-surface-soft);
    border: 1px solid var(--ui-border);
    border-radius: 8px;
  }

  .history-summary strong {
    float: right;
    color: var(--ui-text-primary);
  }

  .chart-container {
    width: 100%;
    height: 520px;
    background: var(--ui-surface);
    border: 1px solid var(--ui-border);
    border-radius: var(--ui-radius);
    padding: 10px;
    box-sizing: border-box;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: inset 0 0 32px color-mix(in srgb, var(--ui-accent-cyan) 4%, transparent);

    .echarts {
      width: 100%;
      height: 100%;
    }
  }
}

// 空状态间距
:deep(.el-empty) {
  padding: 20px 0;
}

@media (max-width: 900px) {
  .data-console-head {
    flex-direction: column;
  }

  .data-console-actions {
    width: 100%;
    justify-content: flex-start;
    flex-wrap: wrap;
  }

  .data-overview {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 600px) {
  .property-search {
    width: 100%;
  }

  .data-overview,
  .history-dialog .history-summary {
    grid-template-columns: 1fr 1fr;
  }

  .history-dialog .history-filter {
    align-items: stretch;
    flex-direction: column;
  }

  .history-dialog .history-shortcuts {
    flex-wrap: wrap;
  }
}
</style>
