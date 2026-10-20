<template>
  <div class="app-container iot-asset-page alarm-log-page">
    <IoTWorkspaceHeader
      title="告警中心"
      eyebrow="ALARM OPERATIONS"
      description="只读查看设备告警来源与触发信息，集中完成告警确认和处置记录。"
      :stats="alarmStats"
    >
      <template #icon>
        <el-icon><Bell /></el-icon>
      </template>
      <template #actions>
        <el-button icon="Download" @click="handleExport" v-hasPermi="['iot:alarmLog:export']">
          导出记录
        </el-button>
      </template>
    </IoTWorkspaceHeader>

    <el-form
      v-show="showSearch"
      ref="queryRef"
      :model="queryParams"
      :inline="true"
      label-width="82px"
      class="asset-filter-panel alarm-filter-panel"
    >
      <el-form-item label="产品名称" prop="productName">
        <el-input
          v-model="queryParams.productName"
          placeholder="请输入产品名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备名称" prop="deviceName">
        <el-input
          v-model="queryParams.deviceName"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="告警等级" prop="level">
        <el-select v-model="queryParams.level" placeholder="全部等级" clearable>
          <el-option
            v-for="item in levelOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="告警状态" prop="state">
        <el-select v-model="queryParams.state" placeholder="全部状态" clearable>
          <el-option
            v-for="item in stateOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="告警日期" prop="alarmTime">
        <el-date-picker
          v-model="queryParams.alarmTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择告警日期"
          clearable
        />
      </el-form-item>

      <template v-if="advancedSearch">
        <el-form-item label="产品 ID" prop="productId">
          <el-input
            v-model="queryParams.productId"
            placeholder="请输入产品 ID"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="设备 ID" prop="deviceId">
          <el-input
            v-model="queryParams.deviceId"
            placeholder="请输入设备 ID"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="物模型标识" prop="telemetryKey">
          <el-input
            v-model="queryParams.telemetryKey"
            placeholder="请输入物模型标识"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="点位名称" prop="telemetryName">
          <el-input
            v-model="queryParams.telemetryName"
            placeholder="请输入属性名称"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="处理日期" prop="handleTime">
          <el-date-picker
            v-model="queryParams.handleTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择处理日期"
            clearable
          />
        </el-form-item>
        <el-form-item label="说明" prop="description">
          <el-input
            v-model="queryParams.description"
            placeholder="请输入说明"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
      </template>

      <el-form-item class="filter-actions">
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        <el-button link type="primary" @click="advancedSearch = !advancedSearch">
          {{ advancedSearch ? "收起筛选" : "更多筛选" }}
          <el-icon class="filter-toggle-icon" :class="{ 'is-expanded': advancedSearch }">
            <ArrowDown />
          </el-icon>
        </el-button>
      </el-form-item>
    </el-form>

    <section class="asset-table-panel">
      <div class="asset-table-heading">
        <div>
          <span class="asset-table-title">告警记录</span>
          <span class="asset-table-caption">
            共 {{ formatNumber(total) }} 条，当前页 {{ alarmLogList.length }} 条
            <template v-if="activeFilterCount"> · 已启用 {{ activeFilterCount }} 项筛选</template>
          </span>
        </div>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
      </div>

      <el-row :gutter="10" class="mb8 asset-toolbar">
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="CircleCheck"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['iot:alarmLog:edit']"
          >处理告警</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Download"
            @click="handleExport"
            v-hasPermi="['iot:alarmLog:export']"
          >导出</el-button>
        </el-col>
      </el-row>

      <el-table
        v-loading="loading"
        :data="alarmLogList"
        row-key="id"
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="48" align="center" />
        <el-table-column label="设备信息" min-width="205">
          <template #default="{ row }">
            <div class="device-cell">
              <span class="device-cell__icon">
                <el-icon><Monitor /></el-icon>
              </span>
              <div>
                <strong>{{ row.deviceName || "未命名设备" }}</strong>
                <small>{{ row.productName || "未关联产品" }}</small>
                <small class="device-cell__id">ID：{{ row.deviceId || "—" }}</small>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="告警内容" min-width="250">
          <template #default="{ row }">
            <div class="alarm-content">
              <strong>{{ row.alarmDesc || row.description || "设备告警" }}</strong>
              <span>{{ row.triggerDesc || "暂无触发条件说明" }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="监测点位" min-width="150">
          <template #default="{ row }">
            <div class="telemetry-cell">
              <span>{{ row.telemetryName || "—" }}</span>
              <code v-if="row.telemetryKey">{{ row.telemetryKey }}</code>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="告警等级" align="center" width="105">
          <template #default="{ row }">
            <el-tag :type="getLevelType(row.level)" effect="light" round>
              {{ getLevelText(row.level) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="告警状态" align="center" width="110">
          <template #default="{ row }">
            <span class="alarm-state" :class="getStateClass(row.state)">
              <i></i>{{ getStateText(row.state) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="告警时间" prop="alarmTime" width="168">
          <template #default="{ row }">
            <div class="time-cell">
              <el-icon><Clock /></el-icon>
              <span>{{ formatDateTime(row.alarmTime) }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="处置信息" min-width="190">
          <template #default="{ row }">
            <div class="handle-cell">
              <el-tag size="small" type="info" effect="plain">
                {{ getHandleTypeText(row.handleType) }}
              </el-tag>
              <span v-if="row.handleMessage">{{ row.handleMessage }}</span>
              <small v-if="row.handleTime">{{ formatDateTime(row.handleTime) }}</small>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="90" fixed="right">
          <template #default="{ row }">
            <el-button
              link
              type="primary"
              icon="CircleCheck"
              @click="handleUpdate(row)"
              v-hasPermi="['iot:alarmLog:edit']"
            >处理</el-button>
          </template>
        </el-table-column>
        <template #empty>
          <el-empty description="暂无符合条件的告警记录" :image-size="88" />
        </template>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </section>

    <el-dialog
      v-model="open"
      :title="title"
      width="860px"
      class="alarm-workspace-dialog"
      append-to-body
      destroy-on-close
      draggable
      @closed="reset"
    >
      <el-form ref="alarmLogRef" :model="form" :rules="rules" label-width="94px">
        <div class="form-section is-readonly">
          <div class="form-section__heading">
            <span class="form-section__icon"><el-icon><Monitor /></el-icon></span>
            <div>
              <strong>设备与点位</strong>
              <small>告警来源信息由系统生成，不可修改</small>
            </div>
            <el-tag type="info" effect="plain" size="small">只读</el-tag>
          </div>
          <div class="readonly-grid">
            <article>
              <span>产品名称</span>
              <strong>{{ form.productName || "—" }}</strong>
              <small>ID：{{ form.productId || "—" }}</small>
            </article>
            <article>
              <span>设备名称</span>
              <strong>{{ form.deviceName || "—" }}</strong>
              <small>ID：{{ form.deviceId || "—" }}</small>
            </article>
            <article>
              <span>监测点位</span>
              <strong>{{ form.telemetryName || "—" }}</strong>
              <small>{{ form.telemetryKey || "无物模型标识" }}</small>
            </article>
          </div>
        </div>

        <div class="form-section is-readonly">
          <div class="form-section__heading">
            <span class="form-section__icon is-warning"><el-icon><Warning /></el-icon></span>
            <div>
              <strong>告警信息</strong>
              <small>告警等级、时间和触发内容不可修改</small>
            </div>
            <el-tag type="info" effect="plain" size="small">只读</el-tag>
          </div>
          <div class="alarm-readonly-summary">
            <div>
              <span>告警等级</span>
              <el-tag :type="getLevelType(form.level)" effect="light" round>
                {{ getLevelText(form.level) }}
              </el-tag>
            </div>
            <div>
              <span>告警时间</span>
              <strong>{{ formatDateTime(form.alarmTime) }}</strong>
            </div>
          </div>
          <div class="readonly-description">
            <span>告警描述</span>
            <p>{{ form.alarmDesc || form.description || "暂无告警描述" }}</p>
          </div>
          <div class="readonly-description">
            <span>触发条件</span>
            <p>{{ form.triggerDesc || "暂无触发条件说明" }}</p>
          </div>
        </div>

        <div class="form-section">
          <div class="form-section__heading">
            <span class="form-section__icon is-success"><el-icon><CircleCheck /></el-icon></span>
            <div>
              <strong>处置记录</strong>
              <small>补充处理状态、方式与处置说明</small>
            </div>
          </div>
          <el-row :gutter="18">
            <el-col :xs="24" :sm="12">
              <el-form-item label="告警状态" prop="state">
                <el-select
                  v-model="form.state"
                  placeholder="请选择告警状态"
                  @change="handleStateChange"
                >
                  <el-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :xs="24" :sm="12">
              <el-form-item label="处理类型" prop="handleType">
                <el-select v-model="form.handleType" placeholder="请选择处理类型">
                  <el-option
                    v-for="item in handleTypeOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :xs="24" :sm="12">
              <el-form-item label="处理时间" prop="handleTime">
                <el-date-picker
                  v-model="form.handleTime"
                  type="datetime"
                  value-format="YYYY-MM-DD HH:mm:ss"
                  placeholder="请选择处理时间"
                  clearable
                />
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="处理说明" prop="handleMessage">
                <el-input
                  v-model="form.handleMessage"
                  type="textarea"
                  :rows="3"
                  maxlength="500"
                  show-word-limit
                  placeholder="请输入处理过程或结果"
                />
              </el-form-item>
            </el-col>
          </el-row>
        </div>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancel">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitForm">
            {{ submitting ? "保存中" : "保存处置" }}
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="AlarmLog">
import IoTWorkspaceHeader from "@/components/IoTWorkspaceHeader";
import {
  getAlarmLog,
  listAlarmLog,
  updateAlarmLog,
} from "@/api/iot/alarmLog";

const { proxy } = getCurrentInstance();

const levelOptions = [
  { label: "严重", value: "1" },
  { label: "重要", value: "2" },
  { label: "一般", value: "3" },
  { label: "提示", value: "4" },
];

const stateOptions = [
  { label: "未确认", value: "0" },
  { label: "已确认", value: "1" },
  { label: "已恢复", value: "2" },
  { label: "已关闭", value: "3" },
];

const handleTypeOptions = [
  { label: "未处理", value: "0" },
  { label: "自动恢复", value: "1" },
  { label: "人工确认", value: "2" },
  { label: "人工关闭", value: "3" },
  { label: "忽略告警", value: "4" },
  { label: "误报", value: "5" },
  { label: "转工单", value: "6" },
  { label: "自动处理", value: "7" },
  { label: "联动处理", value: "8" },
];

const createEmptyForm = () => ({
  id: null,
  productId: null,
  productName: null,
  deviceId: null,
  deviceName: null,
  telemetryKey: null,
  telemetryName: null,
  triggerDesc: null,
  alarmDesc: null,
  alarmTime: null,
  handleMessage: null,
  handleTime: null,
  level: null,
  state: null,
  handleType: null,
  description: null,
  createTime: null,
});

const createEmptyQuery = () => ({
  pageNum: 1,
  pageSize: 10,
  productId: null,
  productName: null,
  deviceId: null,
  deviceName: null,
  telemetryKey: null,
  telemetryName: null,
  triggerDesc: null,
  alarmDesc: null,
  alarmTime: null,
  handleMessage: null,
  handleTime: null,
  level: null,
  state: null,
  handleType: null,
  description: null,
});

const alarmLogList = ref([]);
const open = ref(false);
const loading = ref(false);
const submitting = ref(false);
const showSearch = ref(true);
const advancedSearch = ref(false);
const ids = ref([]);
const single = ref(true);
const total = ref(0);
const title = ref("");

const data = reactive({
  form: createEmptyForm(),
  queryParams: createEmptyQuery(),
  rules: {
    state: [
      { required: true, message: "请选择告警状态", trigger: "change" },
    ],
  },
});

const { queryParams, form, rules } = toRefs(data);

const activeFilterCount = computed(() =>
  Object.entries(queryParams.value).filter(
    ([key, value]) => !["pageNum", "pageSize"].includes(key) && value !== null && value !== ""
  ).length
);

const pendingCount = computed(() =>
  alarmLogList.value.filter((item) => isPending(item.state)).length
);

const handledCount = computed(() => alarmLogList.value.length - pendingCount.value);

const urgentCount = computed(() =>
  alarmLogList.value.filter((item) =>
    String(item.level ?? "") === "1"
  ).length
);

const alarmStats = computed(() => [
  {
    label: "告警总量",
    value: formatNumber(total.value),
    icon: "DataLine",
    hint: "符合当前筛选",
  },
  {
    label: "本页未确认",
    value: pendingCount.value,
    icon: "Warning",
    tone: pendingCount.value ? "danger" : "success",
    hint: "需要及时关注",
  },
  {
    label: "本页已处置",
    value: handledCount.value,
    icon: "CircleCheck",
    tone: "success",
    hint: "处置完成",
  },
  {
    label: "本页严重告警",
    value: urgentCount.value,
    icon: "BellFilled",
    tone: urgentCount.value ? "warning" : "",
    hint: "等级 1",
  },
]);

function formatNumber(value) {
  return new Intl.NumberFormat("zh-CN").format(Number(value || 0));
}

function formatDateTime(value) {
  return value ? proxy.parseTime(value, "{y}-{m}-{d} {h}:{i}:{s}") : "—";
}

function getLevelText(level) {
  const value = String(level ?? "");
  if (value === "1") return "严重";
  if (value === "2") return "重要";
  if (value === "3") return "一般";
  if (value === "4") return "提示";
  return level || "未分级";
}

function getLevelType(level) {
  const value = String(level ?? "");
  if (value === "1") return "danger";
  if (value === "2") return "warning";
  if (value === "4") return "info";
  return "";
}

function isPending(state) {
  return state === null || state === undefined || state === "" || String(state) === "0";
}

function getStateText(state) {
  const value = String(state ?? "0");
  return stateOptions.find((item) => item.value === value)?.label || "未知状态";
}

function getStateClass(state) {
  const value = String(state ?? "0");
  if (value === "1") return "is-confirmed";
  if (value === "2") return "is-restored";
  if (value === "3") return "is-closed";
  return "is-unconfirmed";
}

function getHandleTypeText(handleType) {
  const value = String(handleType ?? "0");
  return handleTypeOptions.find((item) => item.value === value)?.label || "未知处理类型";
}

async function getList() {
  loading.value = true;
  try {
    const response = await listAlarmLog(queryParams.value);
    alarmLogList.value = Array.isArray(response?.rows) ? response.rows : [];
    total.value = Number(response?.total || 0);
  } finally {
    loading.value = false;
  }
}

function cancel() {
  open.value = false;
}

function reset() {
  form.value = createEmptyForm();
  proxy.resetForm("alarmLogRef");
}

function handleQuery() {
  queryParams.value.pageNum = 1;
  getList();
}

function resetQuery() {
  Object.assign(queryParams.value, createEmptyQuery());
  proxy.resetForm("queryRef");
  advancedSearch.value = false;
  handleQuery();
}

function handleSelectionChange(selection) {
  ids.value = selection.map((item) => item.id);
  single.value = selection.length !== 1;
}

async function handleUpdate(row) {
  reset();
  const rowId = row && typeof row === "object" && "id" in row ? row.id : null;
  const id = rowId || ids.value[0];
  if (!id) return;

  const response = await getAlarmLog(id);
  const detail = response?.data || {};
  form.value = {
    ...createEmptyForm(),
    ...detail,
    level: detail.level == null ? null : String(detail.level),
    state: detail.state == null ? null : String(detail.state),
    handleType: detail.handleType == null ? "0" : String(detail.handleType),
  };
  title.value = "处理告警记录";
  open.value = true;
}

function handleStateChange(state) {
  if (String(state) !== "0" && !form.value.handleTime) {
    form.value.handleTime = proxy.parseTime(new Date(), "{y}-{m}-{d} {h}:{i}:{s}");
  }
}

function submitForm() {
  proxy.$refs.alarmLogRef.validate(async (valid) => {
    if (!valid || submitting.value || form.value.id == null) return;

    submitting.value = true;
    try {
      await updateAlarmLog({
        id: form.value.id,
        state: form.value.state,
        handleType: form.value.handleType,
        handleTime: form.value.handleTime,
        handleMessage: form.value.handleMessage,
      });
      proxy.$modal.msgSuccess("告警处置已保存");
      open.value = false;
      await getList();
    } finally {
      submitting.value = false;
    }
  });
}

function handleExport() {
  proxy.download(
    "iot/alarmLog/export",
    { ...queryParams.value },
    `alarmLog_${Date.now()}.xlsx`
  );
}

getList();
</script>

<style scoped lang="scss">
.alarm-filter-panel {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;

  :deep(.el-form-item) {
    margin-right: 18px;
    margin-bottom: 16px;
  }

  :deep(.el-input),
  :deep(.el-select),
  :deep(.el-date-editor) {
    width: 210px;
  }

  .filter-actions {
    margin-left: auto;
  }
}

.filter-toggle-icon {
  margin-left: 4px;
  transition: transform 0.2s ease;

  &.is-expanded {
    transform: rotate(180deg);
  }
}

.device-cell {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
  padding: 3px 0;

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

  .device-cell__id {
    color: var(--ui-text-placeholder);
  }
}

.device-cell__icon {
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

.alarm-content,
.telemetry-cell,
.handle-cell {
  display: flex;
  flex-direction: column;
  gap: 5px;
  min-width: 0;

  > * {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.alarm-content {
  strong {
    color: var(--ui-text-primary);
    font-size: 13px;
    font-weight: 600;
  }

  span {
    color: var(--ui-text-secondary);
    font-size: 12px;
  }
}

.telemetry-cell {
  span {
    color: var(--ui-text-primary);
    font-size: 13px;
  }

  code {
    width: fit-content;
    max-width: 100%;
    padding: 2px 6px;
    color: var(--el-color-primary);
    font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
    font-size: 11px;
    background: color-mix(in srgb, var(--el-color-primary) 7%, var(--ui-surface));
    border-radius: 4px;
  }
}

.alarm-state {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: var(--el-color-danger);
  font-size: 12px;
  font-weight: 600;

  i {
    width: 7px;
    height: 7px;
    background: currentColor;
    border-radius: 50%;
    box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-danger) 10%, transparent);
  }

  &.is-confirmed {
    color: var(--el-color-primary);

    i {
      box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-primary) 10%, transparent);
    }
  }

  &.is-restored {
    color: var(--el-color-success);

    i {
      box-shadow: 0 0 0 4px color-mix(in srgb, var(--el-color-success) 10%, transparent);
    }
  }

  &.is-closed {
    color: var(--ui-text-secondary);

    i {
      box-shadow: 0 0 0 4px color-mix(in srgb, var(--ui-text-secondary) 10%, transparent);
    }
  }
}

.time-cell {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--ui-text-secondary);
  font-size: 12px;

  .el-icon {
    color: var(--ui-text-placeholder);
  }
}

.handle-cell {
  align-items: flex-start;

  span {
    color: var(--ui-text-primary);
    font-size: 12px;
  }

  small {
    color: var(--ui-text-secondary);
    font-size: 11px;
  }
}

.empty-text {
  color: var(--ui-text-placeholder);
  font-size: 12px;
}

.form-section {
  padding: 18px 18px 2px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 12px;

  + .form-section {
    margin-top: 14px;
  }

  :deep(.el-select),
  :deep(.el-date-editor) {
    width: 100%;
  }

  &.is-readonly {
    padding-bottom: 18px;
  }
}

.form-section__heading {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 18px;

  > div {
    display: flex;
    flex-direction: column;
    gap: 2px;
  }

  > .el-tag {
    margin-left: auto;
  }

  strong {
    color: var(--ui-text-primary);
    font-size: 14px;
  }

  small {
    color: var(--ui-text-secondary);
    font-size: 11px;
  }
}

.form-section__icon {
  display: grid;
  width: 34px;
  height: 34px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 10%, var(--ui-surface));
  border-radius: 9px;

  &.is-warning {
    color: var(--el-color-warning);
    background: color-mix(in srgb, var(--el-color-warning) 10%, var(--ui-surface));
  }

  &.is-success {
    color: var(--el-color-success);
    background: color-mix(in srgb, var(--el-color-success) 10%, var(--ui-surface));
  }
}

.readonly-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;

  article {
    min-width: 0;
    padding: 12px 14px;
    background: var(--ui-surface);
    border: 1px solid var(--ui-border);
    border-radius: 9px;
  }

  span,
  strong,
  small {
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  span {
    margin-bottom: 6px;
    color: var(--ui-text-secondary);
    font-size: 11px;
  }

  strong {
    color: var(--ui-text-primary);
    font-size: 13px;
  }

  small {
    margin-top: 4px;
    color: var(--ui-text-placeholder);
    font-size: 11px;
  }
}

.alarm-readonly-summary {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
  margin-bottom: 10px;

  > div {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    min-height: 46px;
    padding: 10px 14px;
    background: var(--ui-surface);
    border: 1px solid var(--ui-border);
    border-radius: 9px;
  }

  span {
    color: var(--ui-text-secondary);
    font-size: 11px;
  }

  strong {
    color: var(--ui-text-primary);
    font-size: 12px;
  }
}

.readonly-description {
  padding: 12px 14px;
  background: var(--ui-surface);
  border: 1px solid var(--ui-border);
  border-radius: 9px;

  + .readonly-description {
    margin-top: 10px;
  }

  span {
    display: block;
    margin-bottom: 5px;
    color: var(--ui-text-secondary);
    font-size: 11px;
  }

  p {
    margin: 0;
    color: var(--ui-text-primary);
    font-size: 13px;
    line-height: 1.65;
    white-space: pre-wrap;
    word-break: break-word;
  }
}

@media (max-width: 900px) {
  .alarm-filter-panel {
    .filter-actions {
      width: 100%;
      margin-left: 0;
    }
  }

  .readonly-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 600px) {
  .alarm-readonly-summary {
    grid-template-columns: 1fr;
  }
}
</style>
