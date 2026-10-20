<template>
  <div ref="homeRef" class="app-container home-dashboard">
    <section class="home-hero">
      <div class="hero-content">
        <span class="hero-eyebrow">LIGHTNING OPERATIONS CENTER</span>
        <h1>{{ greeting }}，{{ displayName }}</h1>
        <p>今天是 {{ currentDate }}。{{ healthSummary }}</p>
        <div class="hero-status">
          <span><i :class="overallHealth.tone"></i>{{ overallHealth.label }}</span>
          <span>数据更新于 {{ lastUpdatedText }}</span>
        </div>
      </div>
      <div class="hero-actions">
        <el-button icon="Refresh" :loading="loading" @click="loadOverview">刷新总览</el-button>
        <el-button type="primary" icon="Monitor" @click="navigateTo('/device/devices')">进入设备中心</el-button>
      </div>
      <div class="hero-orbit orbit-one"></div>
      <div class="hero-orbit orbit-two"></div>
    </section>

    <el-alert
      v-if="failedModules.length"
      :title="`${failedModules.join('、')}暂时不可用，其余数据已正常展示`"
      type="warning"
      show-icon
      :closable="false"
      class="partial-error-alert"
    />

    <section class="metric-grid" v-loading="loading && !hasLoaded">
      <article
        v-for="card in kpiCards"
        :key="card.key"
        class="metric-card"
        :class="`is-${card.tone}`"
        tabindex="0"
        @click="navigateTo(card.route)"
        @keyup.enter="navigateTo(card.route)"
      >
        <span class="metric-icon"><el-icon><component :is="card.icon" /></el-icon></span>
        <div class="metric-copy">
          <span>{{ card.label }}</span>
          <strong>{{ formatNumber(card.value) }}</strong>
          <small>{{ card.hint }}</small>
        </div>
        <el-icon class="metric-arrow"><ArrowRight /></el-icon>
      </article>
    </section>

    <section class="dashboard-grid dashboard-primary">
      <article class="dashboard-panel connectivity-panel">
        <header class="panel-header">
          <div>
            <span class="panel-eyebrow">CONNECTIVITY</span>
            <h2>全域连接态势</h2>
            <p>设备与边缘网关的实时连接健康度。</p>
          </div>
          <el-tag :type="overallHealth.tagType" effect="plain" round>{{ overallHealth.label }}</el-tag>
        </header>
        <div class="connectivity-content">
          <div ref="deviceStatusRef" class="chart chart-donut"></div>
          <div class="health-stack">
            <div class="health-row">
              <div><span>设备在线率</span><strong>{{ deviceOnlineRate }}%</strong></div>
              <el-progress :percentage="deviceOnlineRate" :stroke-width="9" :show-text="false"
                           :color="getProgressColor(deviceOnlineRate)" />
              <small>{{ formatNumber(deviceStatsData.online) }} / {{ formatNumber(deviceTotal) }} 台在线</small>
            </div>
            <div class="health-row">
              <div><span>网关在线率</span><strong>{{ edgeOnlineRate }}%</strong></div>
              <el-progress :percentage="edgeOnlineRate" :stroke-width="9" :show-text="false"
                           :color="getProgressColor(edgeOnlineRate)" />
              <small>{{ formatNumber(edgeStatsData.online) }} / {{ formatNumber(edgeTotal) }} 个在线</small>
            </div>
            <div class="health-notes">
              <span><i class="is-online"></i>在线 {{ totalOnline }}</span>
              <span><i class="is-offline"></i>离线 {{ totalOffline }}</span>
              <span><i class="is-disabled"></i>停用 {{ totalDisabled }}</span>
            </div>
          </div>
        </div>
      </article>

      <article class="dashboard-panel action-panel">
        <header class="panel-header">
          <div>
            <span class="panel-eyebrow">QUICK ACCESS</span>
            <h2>常用工作台</h2>
            <p>快速进入核心资产与边缘配置。</p>
          </div>
        </header>
        <div class="quick-grid">
          <button v-for="action in quickActions" :key="action.route" type="button"
                  class="quick-action" @click="navigateTo(action.route)">
            <span :class="`is-${action.tone}`"><el-icon><component :is="action.icon" /></el-icon></span>
            <div><strong>{{ action.label }}</strong><small>{{ action.hint }}</small></div>
            <el-icon><ArrowRight /></el-icon>
          </button>
        </div>
      </article>
    </section>

    <section class="dashboard-grid dashboard-charts">
      <article class="dashboard-panel">
        <header class="panel-header">
          <div>
            <span class="panel-eyebrow">DEVICE PORTFOLIO</span>
            <h2>设备类型分布</h2>
            <p>基于当前全部设备资产聚合。</p>
          </div>
        </header>
        <div ref="deviceTypeRef" class="chart chart-wide"></div>
      </article>
      <article class="dashboard-panel">
        <header class="panel-header">
          <div>
            <span class="panel-eyebrow">ALARM TREND</span>
            <h2>近 7 日告警趋势</h2>
            <p>由真实告警记录按告警时间聚合。</p>
          </div>
          <el-button link type="primary" @click="navigateTo('/alarm/alarmLog')">查看全部</el-button>
        </header>
        <div ref="alarmTrendRef" class="chart chart-wide"></div>
      </article>
    </section>

    <section class="dashboard-grid dashboard-feed">
      <article class="dashboard-panel">
        <header class="panel-header">
          <div>
            <span class="panel-eyebrow">RECENT ALARMS</span>
            <h2>最新告警</h2>
            <p>优先关注尚未处理的设备异常。</p>
          </div>
          <span class="panel-count">{{ recentAlarms.length }} 条</span>
        </header>
        <div v-if="recentAlarms.length" class="feed-list alarm-feed">
          <div v-for="alarm in recentAlarms" :key="alarm.id" class="feed-item">
            <span class="feed-indicator" :class="getAlarmTone(alarm.level)"></span>
            <div class="feed-copy">
              <div><strong>{{ alarm.telemetryName || alarm.deviceName || '设备告警' }}</strong>
                <el-tag size="small" :type="getAlarmTagType(alarm.level)" effect="plain">
                  {{ getAlarmLevelText(alarm.level) }}
                </el-tag>
              </div>
              <p>{{ alarm.alarmDesc || alarm.triggerDesc || alarm.description || '暂无告警说明' }}</p>
              <small>{{ alarm.deviceName || alarm.deviceId || '未知设备' }} · {{ formatDateTime(alarm.alarmTime || alarm.createTime) }}</small>
            </div>
          </div>
        </div>
        <el-empty v-else description="暂无告警记录" :image-size="64" />
      </article>

      <article class="dashboard-panel">
        <header class="panel-header">
          <div>
            <span class="panel-eyebrow">PLATFORM NOTICE</span>
            <h2>平台公告</h2>
            <p>关注平台变更与运维通知。</p>
          </div>
          <span class="panel-count">{{ notices.length }} 条</span>
        </header>
        <div v-if="notices.length" class="feed-list notice-feed">
          <div v-for="notice in notices" :key="notice.noticeId" class="feed-item">
            <span class="notice-icon"><el-icon><Bell /></el-icon></span>
            <div class="feed-copy">
              <div><strong>{{ notice.noticeTitle }}</strong>
                <el-tag v-if="!isNoticeRead(notice)" size="small" type="danger" effect="plain">未读</el-tag>
              </div>
              <p>{{ notice.remark || notice.noticeContentText || '点击公告中心查看详细内容' }}</p>
              <small>{{ notice.createByName || notice.createBy || '平台管理员' }} · {{ formatDateTime(notice.createTime) }}</small>
            </div>
          </div>
        </div>
        <el-empty v-else description="暂无平台公告" :image-size="64" />
      </article>
    </section>
  </div>
</template>

<script setup name="Index">
import * as echarts from "echarts";
import moment from "moment";

import { statisticsDevices } from "@/api/iot/devices";
import { statisticsEdgeDevice } from "@/api/iot/edgeDevice";
import { statisticsEdgeDataPoint } from "@/api/iot/edgeDataPoint";
import { listAlarmLog } from "@/api/iot/alarmLog";
import { listNoticeTop } from "@/api/system/notice";
import useUserStore from "@/store/modules/user";

const { proxy } = getCurrentInstance();
const router = useRouter();
const userStore = useUserStore();
// 设备类型字典，用于将 deviceType 字典值映射为中文标签
const { device_type } = proxy.useDict("device_type");

const loading = ref(false);
const hasLoaded = ref(false);
const lastUpdatedAt = ref(null);
const failedModules = ref([]);
const recentAlarms = ref([]);
const alarmRecords = ref([]);
const notices = ref([]);
const deviceStatsData = ref({});
const edgeStatsData = ref({});
const homeRef = ref(null);
let resizeObserver = null;
let themeObserver = null;

// === KPI 指标 ===
const deviceTotal = ref(0);
const edgeTotal = ref(0);
const pointTotal = ref(0);
const alarmTotal = ref(0);

// 连接状态映射（与 devices / edgeDevice 视图保持一致）
const STATUS_MAP = {
  online: { label: "在线", color: "#16a34a" },
  offline: { label: "离线", color: "#dc2626" },
  disabled: { label: "停用", color: "#d97706" },
};

const kpiCards = computed(() => [
  {key: "device", label: "设备资产", value: deviceTotal.value, icon: "Cpu", tone: "primary",
    hint: `${deviceOnlineRate.value}% 在线`, route: "/device/devices"},
  {key: "edge", label: "边缘网关", value: edgeTotal.value, icon: "Connection", tone: "success",
    hint: `${edgeOnlineRate.value}% 在线`, route: "/edge/edgeDevice"},
  {key: "point", label: "边缘数据点", value: pointTotal.value, icon: "DataAnalysis", tone: "warning",
    hint: "协议点位映射", route: "/edge/edgeDataPoint"},
  {key: "alarm", label: "告警记录", value: alarmTotal.value, icon: "Bell", tone: "danger",
    hint: `${pendingAlarmCount.value} 条待关注`, route: "/alarm/alarmLog"},
]);

const quickActions = [
  {label: "产品中心", hint: "产品与物模型", icon: "Box", tone: "primary", route: "/product/products"},
  {label: "设备中心", hint: "设备资产管理", icon: "Cpu", tone: "cyan", route: "/device/devices"},
  {label: "边缘网关", hint: "现场协议接入", icon: "Connection", tone: "success", route: "/edge/edgeDevice"},
  {label: "边缘数据点", hint: "点位映射下置", icon: "Aim", tone: "warning", route: "/edge/edgeDataPoint"},
];

// === 顶部欢迎语 ===
const currentDate = ref(moment().format("YYYY年MM月DD日 dddd"));
const greeting = computed(() => {
  const h = moment().hour();
  if (h < 6) return "凌晨好";
  if (h < 9) return "早上好";
  if (h < 12) return "上午好";
  if (h < 14) return "中午好";
  if (h < 17) return "下午好";
  if (h < 19) return "傍晚好";
  return "晚上好";
});

const displayName = computed(() => userStore.nickName || userStore.name || "管理员");
const deviceOnlineRate = computed(() => getOnlineRate(deviceStatsData.value));
const edgeOnlineRate = computed(() => getOnlineRate(edgeStatsData.value));
const totalOnline = computed(() => Number(deviceStatsData.value.online || 0) + Number(edgeStatsData.value.online || 0));
const totalOffline = computed(() => Number(deviceStatsData.value.offline || 0) + Number(edgeStatsData.value.offline || 0));
const totalDisabled = computed(() =>
  Number(deviceStatsData.value.disabled || deviceStatsData.value.inactive || 0)
  + Number(edgeStatsData.value.disabled || edgeStatsData.value.inactive || 0)
);
const pendingAlarmCount = computed(() => alarmRecords.value.filter(isPendingAlarm).length);
const lastUpdatedText = computed(() =>
  lastUpdatedAt.value ? moment(lastUpdatedAt.value).format("HH:mm:ss") : "等待首次同步"
);
const overallHealth = computed(() => {
  const activeRates = [];
  if (deviceTotal.value) activeRates.push(deviceOnlineRate.value);
  if (edgeTotal.value) activeRates.push(edgeOnlineRate.value);
  if (!activeRates.length) {
    return {label: "等待资产数据", tone: "is-idle", tagType: "info"};
  }
  const lowestRate = Math.min(...activeRates);
  if (lowestRate >= 90 && pendingAlarmCount.value === 0) {
    return {label: "运行状态良好", tone: "is-healthy", tagType: "success"};
  }
  if (lowestRate >= 70) {
    return {label: "存在待关注项", tone: "is-warning", tagType: "warning"};
  }
  return {label: "连接健康度偏低", tone: "is-danger", tagType: "danger"};
});
const healthSummary = computed(() => {
  if (!hasLoaded.value) return "正在同步设备、网关和告警数据。";
  if (pendingAlarmCount.value) return `当前有 ${pendingAlarmCount.value} 条告警需要关注。`;
  return "当前未发现待处理告警，请继续关注连接状态变化。";
});

// === 图表 DOM 引用与实例 ===
const deviceStatusRef = ref(null);
const deviceTypeRef = ref(null);
const alarmTrendRef = ref(null);

const charts = {}; // key -> echarts 实例

/** 初始化单个图表实例 */
function initChart(key, el) {
  if (!el || charts[key]) return;
  charts[key] = echarts.init(el);
}

/** 设置图表配置 */
function setChartOption(key, option) {
  if (charts[key]) charts[key].setOption(option);
}

/** 窗口尺寸变化时自适应 */
function handleResize() {
  Object.values(charts).forEach((c) => c && c.resize());
}

/** 从全局设计令牌读取图表配色，保证亮色与暗色界面保持一致 */
function getChartPalette() {
  const styles = getComputedStyle(document.documentElement);
  const read = (name, fallback) => styles.getPropertyValue(name).trim() || fallback;
  return {
    primary: read("--el-color-primary", "#2563eb"),
    cyan: read("--ui-accent-cyan", "#06b6d4"),
    text: read("--ui-text-regular", "#475467"),
    muted: read("--ui-text-secondary", "#667085"),
    border: read("--ui-border", "#e4eaf2"),
    surface: read("--ui-surface", "#ffffff"),
    soft: read("--ui-surface-soft", "#f8fafc"),
    tooltip: "rgba(5, 15, 32, 0.94)",
  };
}

/** 构建饼图通用配置 */
function buildPieOption(data, totalLabel) {
  const theme = getChartPalette();
  return {
    color: [theme.cyan, theme.primary, "#8b5cf6", "#f59e0b"],
    tooltip: {
      trigger: "item",
      formatter: "{b}: {c} ({d}%)",
      backgroundColor: theme.tooltip,
      borderColor: "rgba(34,211,238,0.28)",
      textStyle: { color: "#eaf6ff" },
    },
    legend: { bottom: 0, left: "center", textStyle: { color: theme.muted } },
    series: [
      {
        name: totalLabel,
        type: "pie",
        radius: ["40%", "68%"],
        center: ["50%", "45%"],
        avoidLabelOverlap: true,
        itemStyle: { borderRadius: 8, borderColor: theme.surface, borderWidth: 3 },
        label: { show: true, formatter: "{b}\n{d}%", color: theme.text },
        labelLine: { lineStyle: { color: theme.border } },
        emphasis: { label: { show: true, fontSize: 16, fontWeight: "bold" } },
        data,
      },
    ],
  };
}

/** 构建柱状图配置 */
function buildBarOption(data) {
  const theme = getChartPalette();
  return {
    tooltip: {
      trigger: "axis",
      axisPointer: { type: "shadow", shadowStyle: { color: "rgba(6,182,212,0.07)" } },
      backgroundColor: theme.tooltip,
      borderColor: "rgba(34,211,238,0.28)",
      textStyle: { color: "#eaf6ff" },
    },
    legend: { bottom: 0, textStyle: { color: theme.muted } },
    grid: { left: 40, right: 24, top: 30, bottom: 40 },
    xAxis: {
      type: "category",
      data: data.map((d) => d.name),
      axisLabel: { interval: 0, rotate: data.length > 6 ? 30 : 0, color: theme.muted },
      axisLine: { lineStyle: { color: theme.border } },
      axisTick: { show: false },
    },
    yAxis: {
      type: "value",
      minInterval: 1,
      axisLabel: { color: theme.muted },
      splitLine: { lineStyle: { color: theme.border, type: "dashed" } },
    },
    series: [
      {
        name: "设备数",
        type: "bar",
        barMaxWidth: 40,
        itemStyle: {
          borderRadius: [4, 4, 0, 0],
          color: {
            type: "linear",
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: theme.cyan },
              { offset: 1, color: theme.primary },
            ],
          },
        },
        data: data.map((d) => d.value),
      },
    ],
  };
}

/** 近 7 日告警趋势：由真实告警记录按日期聚合 */
function buildAlarmTrend(records = []) {
  const theme = getChartPalette();
  const days = [];
  const dayKeys = [];
  for (let i = 6; i >= 0; i--) {
    const day = moment().subtract(i, "days");
    days.push(day.format("MM-DD"));
    dayKeys.push(day.format("YYYY-MM-DD"));
  }
  const counter = Object.fromEntries(dayKeys.map(day => [day, 0]));
  records.forEach((item) => {
    const time = item.alarmTime || item.createTime;
    if (!time) return;
    const key = moment(time).format("YYYY-MM-DD");
    if (Object.prototype.hasOwnProperty.call(counter, key)) counter[key] += 1;
  });
  const values = dayKeys.map(day => counter[day]);
  return {
    tooltip: {
      trigger: "axis",
      backgroundColor: theme.tooltip,
      borderColor: "rgba(34,211,238,0.28)",
      textStyle: { color: "#eaf6ff" },
    },
    legend: { bottom: 0, data: ["告警数"], textStyle: { color: theme.muted } },
    grid: { left: 40, right: 24, top: 30, bottom: 40 },
    toolbox: { feature: { saveAsImage: { title: "保存图片" } } },
    xAxis: {
      type: "category",
      boundaryGap: false,
      data: days,
      axisLabel: { color: theme.muted },
      axisLine: { lineStyle: { color: theme.border } },
      axisTick: { show: false },
    },
    yAxis: {
      type: "value",
      minInterval: 1,
      axisLabel: { color: theme.muted },
      splitLine: { lineStyle: { color: theme.border, type: "dashed" } },
    },
    series: [
      {
        name: "告警数",
        type: "line",
        smooth: true,
        symbol: "circle",
        symbolSize: 6,
        lineStyle: { width: 2, color: "#dc2626" },
        itemStyle: { color: "#dc2626" },
        areaStyle: {
          color: {
            type: "linear",
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: "rgba(220,38,38,0.28)" },
              { offset: 1, color: "rgba(220,38,38,0.02)" },
            ],
          },
        },
        data: values,
      },
    ],
  };
}

/** 由 statistics 接口返回值构建连接状态饼图数据 */
function buildStatusData(stats) {
  return ["online", "offline", "disabled"].map((key) => ({
    name: STATUS_MAP[key].label,
    value: stats?.[key] || 0,
    itemStyle: { color: STATUS_MAP[key].color },
  }));
}

/** 将设备类型统计转换为图表数据（deviceType 字典值 -> 中文标签） */
function aggregateDeviceType(deviceTypeCount = {}) {
  const dictMap = {};
  (device_type.value || []).forEach((d) => {
    dictMap[String(d.value)] = d.label;
  });
  return Object.entries(deviceTypeCount).map(([key, value]) => ({
    name: dictMap[key] || key,
    value: Number(value || 0),
  }));
}

function normalizeStats(stats = {}) {
  return {
    total: Number(stats.total || 0),
    online: Number(stats.online || 0),
    offline: Number(stats.offline || 0),
    disabled: Number(stats.disabled ?? stats.disable ?? stats.inactive ?? 0),
    deviceTypeCount: stats.deviceTypeCount && typeof stats.deviceTypeCount === "object"
      ? stats.deviceTypeCount
      : {},
  };
}

function getOnlineRate(stats) {
  const total = Number(stats?.total || 0);
  return total ? Math.round((Number(stats?.online || 0) / total) * 100) : 0;
}

function getProgressColor(rate) {
  if (rate >= 90) return "#16a34a";
  if (rate >= 70) return "#f59e0b";
  return "#ef4444";
}

function formatNumber(value) {
  return new Intl.NumberFormat("zh-CN").format(Number(value || 0));
}

function formatDateTime(value) {
  if (!value || !moment(value).isValid()) return "—";
  return moment(value).format("MM-DD HH:mm");
}

function navigateTo(path) {
  if (!path || router.currentRoute.value.path === path) return;
  router.push(path);
}

function isPendingAlarm(alarm) {
  const state = String(alarm?.state ?? "").toLowerCase();
  return !["1", "handled", "resolved", "closed", "已处理"].includes(state);
}

function getAlarmLevelText(level) {
  const value = String(level ?? "").toLowerCase();
  if (["1", "low", "minor", "提示"].includes(value)) return "提示";
  if (["2", "medium", "warning", "一般"].includes(value)) return "一般";
  if (["3", "high", "major", "重要"].includes(value)) return "重要";
  if (["4", "critical", "fatal", "紧急"].includes(value)) return "紧急";
  return level || "告警";
}

function getAlarmTagType(level) {
  const value = String(level ?? "").toLowerCase();
  if (["4", "critical", "fatal", "紧急"].includes(value)) return "danger";
  if (["3", "high", "major", "重要"].includes(value)) return "warning";
  if (["1", "low", "minor", "提示"].includes(value)) return "info";
  return "warning";
}

function getAlarmTone(level) {
  return `is-${getAlarmTagType(level)}`;
}

function isNoticeRead(notice) {
  return [true, 1, "1", "read"].includes(notice?.readStatus)
    || [true, 1, "1"].includes(notice?.isRead);
}

function extractRows(response) {
  if (Array.isArray(response?.rows)) return response.rows;
  if (Array.isArray(response?.data)) return response.data;
  if (Array.isArray(response?.data?.rows)) return response.data.rows;
  return [];
}

function renderOverviewCharts() {
  setChartOption("deviceStatus", buildPieOption(buildStatusData(deviceStatsData.value), "设备状态"));
  setChartOption("deviceType", buildBarOption(aggregateDeviceType(deviceStatsData.value.deviceTypeCount)));
  setChartOption("alarmTrend", buildAlarmTrend(alarmRecords.value));
}

/** 加载总览数据 */
async function loadOverview() {
  if (loading.value) return;
  loading.value = true;
  const requests = [
    {label: "设备统计", task: statisticsDevices()},
    {label: "网关统计", task: statisticsEdgeDevice()},
    {label: "点位统计", task: statisticsEdgeDataPoint()},
    {label: "告警记录", task: listAlarmLog({pageNum: 1, pageSize: 500})},
    {label: "平台公告", task: listNoticeTop()},
  ];
  try {
    const results = await Promise.allSettled(requests.map(item => item.task));
    const failures = [];
    results.forEach((result, index) => {
      const label = requests[index].label;
      if (result.status === "rejected") {
        failures.push(label);
        console.error(`加载${label}失败:`, result.reason);
        return;
      }
      const response = result.value;
      if (index === 0) deviceStatsData.value = normalizeStats(response?.data);
      if (index === 1) edgeStatsData.value = normalizeStats(response?.data);
      if (index === 2) pointTotal.value = Number(response?.data?.total || 0);
      if (index === 3) {
        alarmRecords.value = extractRows(response);
        alarmTotal.value = Number(response?.total ?? response?.data?.total ?? alarmRecords.value.length);
        recentAlarms.value = [...alarmRecords.value]
          .sort((a, b) => moment(b.alarmTime || b.createTime).valueOf() - moment(a.alarmTime || a.createTime).valueOf())
          .slice(0, 6);
      }
      if (index === 4) notices.value = extractRows(response).slice(0, 6);
    });

    deviceTotal.value = deviceStatsData.value.total;
    edgeTotal.value = edgeStatsData.value.total;
    failedModules.value = failures;
    hasLoaded.value = true;
    if (results.some(result => result.status === "fulfilled")) lastUpdatedAt.value = new Date();
    await nextTick();
    renderOverviewCharts();
    if (failures.length === requests.length) proxy.$modal.msgError("首页数据暂时无法加载");
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  initChart("deviceStatus", deviceStatusRef.value);
  initChart("deviceType", deviceTypeRef.value);
  initChart("alarmTrend", alarmTrendRef.value);

  window.addEventListener("resize", handleResize);
  if (typeof ResizeObserver !== "undefined" && homeRef.value) {
    resizeObserver = new ResizeObserver(handleResize);
    resizeObserver.observe(homeRef.value);
  }
  themeObserver = new MutationObserver(() => {
    renderOverviewCharts();
  });
  themeObserver.observe(document.documentElement, {attributes: true, attributeFilter: ["class"]});
  loadOverview();
});

onBeforeUnmount(() => {
  window.removeEventListener("resize", handleResize);
  resizeObserver?.disconnect();
  themeObserver?.disconnect();
  Object.values(charts).forEach((c) => c && c.dispose());
});
</script>

<style scoped lang="scss">
.home {
  padding: var(--ui-page-padding);

  .welcome-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: relative;
    overflow: hidden;
    padding: 24px 28px;
    margin-bottom: 20px;
    background: linear-gradient(125deg, #1d4ed8 0%, #2563eb 52%, #3b82f6 100%);
    border: 1px solid rgba(255, 255, 255, 0.16);
    border-radius: var(--ui-radius-lg);
    color: #fff;
    box-shadow: 0 12px 28px rgba(37, 99, 235, 0.18);

    &::after {
      position: absolute;
      top: -90px;
      right: -45px;
      width: 260px;
      height: 260px;
      border: 42px solid rgba(255, 255, 255, 0.08);
      border-radius: 50%;
      content: "";
    }

    &::before {
      position: absolute;
      inset: 0;
      opacity: 0.16;
      background-image: linear-gradient(90deg, transparent 49.5%, rgba(255, 255, 255, 0.2) 50%, transparent 50.5%);
      background-size: 42px 100%;
      mask-image: linear-gradient(90deg, black, transparent 72%);
      content: "";
      pointer-events: none;
    }

    .welcome-text {
      h2 {
        margin: 0 0 6px;
        font-size: 22px;
        font-weight: 650;
        color: #fff;
      }

      p {
        margin: 0;
        font-size: 13px;
        opacity: 0.9;
      }
    }

    .welcome-actions {
      :deep(.el-button) {
        position: relative;
        z-index: 1;
        color: #1d4ed8;
        background: rgba(255, 255, 255, 0.94);
        border-color: rgba(255, 255, 255, 0.68);
        box-shadow: 0 4px 12px rgba(30, 64, 175, 0.18);
      }
    }
  }

  .kpi-row {
    margin-bottom: 4px;

    .kpi-card {
      position: relative;
      margin-bottom: 16px;

      &::before {
        position: absolute;
        inset: 0 auto 0 0;
        width: 3px;
        background: var(--el-color-primary);
        content: "";
      }

      .kpi-body {
        display: flex;
        align-items: center;
        gap: 18px;
      }

      .kpi-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 58px;
        height: 58px;
        border-radius: 14px;
        flex-shrink: 0;
      }

      .kpi-info {
        flex: 1;
        min-width: 0;
      }

      .kpi-value {
        font-size: 30px;
        font-weight: 700;
        color: var(--ui-text-primary);
        line-height: 1.2;
      }

      .kpi-label {
        margin-top: 6px;
        font-size: 13px;
        color: var(--ui-text-secondary);
      }
    }

    :deep(.el-col:nth-child(2) .kpi-card::before) { background: var(--ui-success); }
    :deep(.el-col:nth-child(3) .kpi-card::before) { background: var(--ui-warning); }
    :deep(.el-col:nth-child(4) .kpi-card::before) { background: var(--ui-danger); }
  }

  .chart-row {
    margin-bottom: 4px;

    .chart-card {
      position: relative;
      margin-bottom: 16px;

      &::after {
        position: absolute;
        top: 0;
        right: 18px;
        width: 48px;
        height: 2px;
        background: linear-gradient(90deg, transparent, var(--ui-accent-cyan));
        box-shadow: 0 0 10px color-mix(in srgb, var(--ui-accent-cyan) 32%, transparent);
        content: "";
      }

      :deep(.el-card__header) {
        padding: 15px 18px !important;
        font-size: 15px;
        font-weight: 600;

        .el-icon {
          vertical-align: middle;
          margin-right: 6px;
          color: var(--el-color-primary);
        }
      }

      .chart {
        width: 100%;
        height: 320px;
        background: radial-gradient(circle at 50% 42%, color-mix(in srgb, var(--ui-accent-cyan) 4%, transparent), transparent 54%);
      }
    }
  }
}
</style>

<style scoped lang="scss">
.home-dashboard {
  display: flex;
  flex-direction: column;
  gap: 18px;
  min-height: calc(100vh - 84px);
  padding: var(--ui-page-padding);
}

.home-hero {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 176px;
  padding: 30px 34px;
  overflow: hidden;
  color: #fff;
  background:
    radial-gradient(circle at 76% 20%, rgba(34, 211, 238, 0.2), transparent 32%),
    linear-gradient(125deg, #07172e 0%, #0b2e59 48%, #1257a6 100%);
  border: 1px solid rgba(96, 165, 250, 0.3);
  border-radius: 18px;
  box-shadow: 0 16px 36px rgba(10, 45, 88, 0.22);
}

.home-hero::before {
  position: absolute;
  inset: 0;
  opacity: 0.13;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.16) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.16) 1px, transparent 1px);
  background-size: 32px 32px;
  mask-image: linear-gradient(90deg, transparent, #000 46%, #000);
  content: "";
  pointer-events: none;
}

.hero-content,
.hero-actions {
  position: relative;
  z-index: 2;
}

.hero-content {
  min-width: 0;
}

.hero-eyebrow,
.panel-eyebrow {
  color: #67e8f9;
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 1.6px;
}

.hero-content h1 {
  margin: 7px 0 6px;
  color: #fff;
  font-size: 25px;
  font-weight: 680;
  letter-spacing: -0.4px;
}

.hero-content > p {
  margin: 0;
  color: rgba(226, 240, 255, 0.82);
  font-size: 13px;
}

.hero-status {
  display: flex;
  align-items: center;
  gap: 18px;
  margin-top: 17px;
  color: rgba(226, 240, 255, 0.72);
  font-size: 11px;
}

.hero-status span {
  display: inline-flex;
  align-items: center;
  gap: 7px;
}

.hero-status i {
  width: 7px;
  height: 7px;
  background: #94a3b8;
  border-radius: 50%;
  box-shadow: 0 0 0 4px rgba(148, 163, 184, 0.13);
}

.hero-status i.is-healthy {
  background: #34d399;
  box-shadow: 0 0 0 4px rgba(52, 211, 153, 0.14);
}

.hero-status i.is-warning {
  background: #fbbf24;
  box-shadow: 0 0 0 4px rgba(251, 191, 36, 0.14);
}

.hero-status i.is-danger {
  background: #fb7185;
  box-shadow: 0 0 0 4px rgba(251, 113, 133, 0.14);
}

.hero-actions {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 0 0 auto;
}

.hero-actions :deep(.el-button:not(.el-button--primary)) {
  color: #dbeafe;
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(191, 219, 254, 0.28);
}

.hero-actions :deep(.el-button--primary) {
  color: #0b3c74;
  background: #eaf5ff;
  border-color: #eaf5ff;
}

.hero-orbit {
  position: absolute;
  z-index: 1;
  border: 1px solid rgba(103, 232, 249, 0.15);
  border-radius: 50%;
}

.orbit-one {
  right: 16%;
  width: 250px;
  height: 250px;
}

.orbit-two {
  right: 21%;
  width: 150px;
  height: 150px;
}

.partial-error-alert {
  border-radius: 11px;
}

.metric-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
  min-height: 112px;
}

.metric-card {
  position: relative;
  display: flex;
  align-items: center;
  gap: 13px;
  min-width: 0;
  padding: 18px;
  cursor: pointer;
  background: var(--ui-surface);
  border: 1px solid var(--ui-border);
  border-radius: 14px;
  box-shadow: var(--ui-shadow-sm);
  transition: transform 0.18s ease, border-color 0.18s ease, box-shadow 0.18s ease;
}

.metric-card:hover,
.metric-card:focus-visible {
  transform: translateY(-2px);
  border-color: color-mix(in srgb, var(--metric-color) 28%, var(--ui-border));
  box-shadow: 0 12px 28px color-mix(in srgb, var(--metric-color) 10%, transparent);
  outline: none;
}

.metric-card.is-primary { --metric-color: var(--el-color-primary); }
.metric-card.is-success { --metric-color: var(--el-color-success); }
.metric-card.is-warning { --metric-color: var(--el-color-warning); }
.metric-card.is-danger { --metric-color: var(--el-color-danger); }

.metric-icon {
  display: grid;
  flex: 0 0 46px;
  width: 46px;
  height: 46px;
  place-items: center;
  color: var(--metric-color);
  font-size: 21px;
  background: color-mix(in srgb, var(--metric-color) 10%, var(--ui-surface));
  border-radius: 12px;
}

.metric-copy {
  display: flex;
  flex: 1;
  min-width: 0;
  flex-direction: column;
}

.metric-copy > span {
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.metric-copy strong {
  margin: 3px 0;
  color: var(--ui-text-primary);
  font-size: 25px;
  line-height: 1.1;
}

.metric-copy small {
  overflow: hidden;
  color: var(--ui-text-placeholder);
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.metric-arrow {
  color: var(--ui-text-placeholder);
  font-size: 14px;
}

.dashboard-grid {
  display: grid;
  gap: 18px;
}

.dashboard-primary {
  grid-template-columns: minmax(0, 1.65fr) minmax(320px, 0.85fr);
}

.dashboard-charts,
.dashboard-feed {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.dashboard-panel {
  min-width: 0;
  padding: 20px;
  background: var(--ui-surface);
  border: 1px solid var(--ui-border);
  border-radius: 15px;
  box-shadow: var(--ui-shadow-sm);
}

.panel-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 14px;
}

.panel-header > div {
  min-width: 0;
}

.panel-eyebrow {
  color: var(--el-color-primary);
  letter-spacing: 1.3px;
}

.panel-header h2 {
  margin: 4px 0 0;
  color: var(--ui-text-primary);
  font-size: 16px;
}

.panel-header p {
  margin: 4px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.panel-count {
  padding: 4px 9px;
  color: var(--ui-text-secondary);
  font-size: 10px;
  background: var(--ui-surface-soft);
  border-radius: 10px;
}

.connectivity-content {
  display: grid;
  grid-template-columns: minmax(260px, 0.95fr) minmax(260px, 1.05fr);
  align-items: center;
  min-height: 280px;
}

.chart {
  width: 100%;
}

.chart-donut {
  height: 280px;
}

.chart-wide {
  height: 290px;
}

.health-stack {
  display: flex;
  flex-direction: column;
  gap: 14px;
  padding: 0 8px 0 18px;
}

.health-row {
  padding: 14px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 11px;
}

.health-row > div {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 9px;
}

.health-row span {
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.health-row strong {
  color: var(--ui-text-primary);
  font-size: 17px;
}

.health-row small {
  display: block;
  margin-top: 7px;
  color: var(--ui-text-placeholder);
  font-size: 10px;
}

.health-notes {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  padding: 0 4px;
  color: var(--ui-text-secondary);
  font-size: 10px;
}

.health-notes span {
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.health-notes i,
.feed-indicator {
  flex: 0 0 auto;
  width: 7px;
  height: 7px;
  border-radius: 50%;
}

.health-notes .is-online { background: #16a34a; }
.health-notes .is-offline { background: #ef4444; }
.health-notes .is-disabled { background: #f59e0b; }

.quick-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
}

.quick-action {
  display: flex;
  align-items: center;
  gap: 9px;
  min-width: 0;
  min-height: 82px;
  padding: 12px;
  color: inherit;
  text-align: left;
  cursor: pointer;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 11px;
  transition: border-color 0.18s ease, transform 0.18s ease;
}

.quick-action:hover {
  transform: translateY(-1px);
  border-color: color-mix(in srgb, var(--el-color-primary) 28%, var(--ui-border));
}

.quick-action > span {
  display: grid;
  flex: 0 0 34px;
  width: 34px;
  height: 34px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 9%, var(--ui-surface));
  border-radius: 9px;
}

.quick-action > span.is-cyan { color: #0891b2; background: color-mix(in srgb, #06b6d4 10%, var(--ui-surface)); }
.quick-action > span.is-success { color: var(--el-color-success); background: color-mix(in srgb, var(--el-color-success) 10%, var(--ui-surface)); }
.quick-action > span.is-warning { color: var(--el-color-warning); background: color-mix(in srgb, var(--el-color-warning) 10%, var(--ui-surface)); }

.quick-action > div {
  display: flex;
  flex: 1;
  min-width: 0;
  flex-direction: column;
}

.quick-action strong {
  color: var(--ui-text-primary);
  font-size: 12px;
}

.quick-action small {
  margin-top: 3px;
  color: var(--ui-text-secondary);
  font-size: 10px;
}

.quick-action > .el-icon {
  flex: 0 0 auto;
  color: var(--ui-text-placeholder);
  font-size: 12px;
}

.feed-list {
  display: flex;
  max-height: 370px;
  overflow-y: auto;
  flex-direction: column;
}

.feed-item {
  display: flex;
  align-items: flex-start;
  gap: 11px;
  padding: 13px 4px;
  border-bottom: 1px solid var(--ui-border);
}

.feed-item:last-child {
  border-bottom: 0;
}

.feed-indicator {
  margin-top: 7px;
  background: var(--el-color-warning);
  box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-warning) 10%, transparent);
}

.feed-indicator.is-danger {
  background: var(--el-color-danger);
  box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-danger) 10%, transparent);
}

.feed-indicator.is-info {
  background: var(--el-color-info);
  box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-info) 10%, transparent);
}

.notice-icon {
  display: grid;
  flex: 0 0 31px;
  width: 31px;
  height: 31px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 9%, var(--ui-surface));
  border-radius: 8px;
}

.feed-copy {
  flex: 1;
  min-width: 0;
}

.feed-copy > div {
  display: flex;
  align-items: center;
  gap: 7px;
}

.feed-copy strong {
  overflow: hidden;
  color: var(--ui-text-primary);
  font-size: 12px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.feed-copy p {
  overflow: hidden;
  margin: 4px 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
  line-height: 1.5;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.feed-copy small {
  color: var(--ui-text-placeholder);
  font-size: 10px;
}

@media (max-width: 1180px) {
  .metric-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .dashboard-primary {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 900px) {
  .home-hero {
    align-items: flex-start;
    flex-direction: column;
    gap: 22px;
  }

  .dashboard-charts,
  .dashboard-feed {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 680px) {
  .home-dashboard {
    gap: 12px;
  }

  .home-hero {
    min-height: auto;
    padding: 24px 20px;
  }

  .hero-content h1 {
    font-size: 21px;
  }

  .hero-status,
  .hero-actions {
    align-items: flex-start;
    flex-direction: column;
  }

  .hero-actions,
  .hero-actions :deep(.el-button) {
    width: 100%;
  }

  .hero-actions :deep(.el-button + .el-button) {
    margin-left: 0;
  }

  .metric-grid,
  .quick-grid,
  .connectivity-content {
    grid-template-columns: 1fr;
  }

  .metric-card {
    padding: 15px;
  }

  .health-stack {
    padding: 0;
  }

  .health-notes {
    align-items: flex-start;
    flex-direction: column;
  }

  .dashboard-panel {
    padding: 16px;
  }
}
</style>
