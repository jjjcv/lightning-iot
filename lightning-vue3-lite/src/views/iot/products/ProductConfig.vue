<template>
  <div class="product-model-workspace">
    <section class="model-console-head">
      <div>
        <span class="section-eyebrow">THING MODEL DESIGNER</span>
        <h3>物模型设计</h3>
        <p>定义产品属性、服务与事件，形成设备接入和数据解析的统一契约。</p>
      </div>
      <div class="model-console-actions">
        <el-input
          v-model="keyword"
          clearable
          prefix-icon="Search"
          placeholder="搜索名称或标识"
          class="model-search"
        />
        <el-segmented v-model="activeClassify" :options="classifyOptions" />
        <el-button icon="Refresh" :loading="loading" @click="getList">刷新</el-button>
        <el-button type="primary" icon="Plus" @click="handleAdd"
          v-hasPermi="['iot:productTemplates:add']">新增模型</el-button>
      </div>
    </section>

    <section class="model-overview">
      <article>
        <span class="overview-icon"><el-icon><Collection /></el-icon></span>
        <div><strong>{{ modelStats.total }}</strong><span>模型总数</span></div>
      </article>
      <article>
        <span class="overview-icon is-blue"><el-icon><DataLine /></el-icon></span>
        <div><strong>{{ modelStats.property }}</strong><span>属性</span></div>
      </article>
      <article>
        <span class="overview-icon is-purple"><el-icon><Operation /></el-icon></span>
        <div><strong>{{ modelStats.function }}</strong><span>服务</span></div>
      </article>
      <article>
        <span class="overview-icon is-warning"><el-icon><Bell /></el-icon></span>
        <div><strong>{{ modelStats.event }}</strong><span>事件</span></div>
      </article>
      <div class="model-coverage">
        <div><span>可写属性占比</span><strong>{{ modelStats.writableRate }}%</strong></div>
        <el-progress :percentage="modelStats.writableRate" :stroke-width="8" :show-text="false" />
      </div>
    </section>

    <section class="model-toolbar">
      <div>
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['iot:productTemplates:edit']">修改选中项</el-button>
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['iot:productTemplates:remove']">删除选中项</el-button>
        <el-button plain icon="Download" @click="handleExport"
          v-hasPermi="['iot:productTemplates:export']">导出模型</el-button>
      </div>
      <span>当前显示 {{ filteredProductTemplates.length }} 项</span>
    </section>

    <el-table
      v-loading="loading"
      :data="filteredProductTemplates"
      row-key="id"
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="模型定义" prop="name" min-width="210">
        <template #default="scope">
          <div class="model-identity">
            <span class="model-type-icon"><el-icon><SetUp /></el-icon></span>
            <div>
              <strong>{{ scope.row.name }}</strong>
              <small>{{ scope.row.telemetryKey }}</small>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="模型归类" align="center" prop="classify" width="110">
        <template #default="scope">
          <dict-tag :options="thing_model_type" :value="scope.row.classify" />
        </template>
      </el-table-column>
      <el-table-column label="数据类型" align="center" prop="type" width="105">
        <template #default="scope">
          <el-tag :type="getDataTypeTag(scope.row.type)" size="small" effect="plain">{{ scope.row.type }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="读写类型" align="center" prop="operationTpye" width="105">
        <template #default="scope">
          <el-tag :type="isWritable(scope.row) ? 'warning' : 'info'" size="small" effect="plain">
            {{ isWritable(scope.row) ? '读写' : '只读' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="数据定义" prop="define" min-width="220" show-overflow-tooltip>
        <template #default="scope">
          <span class="definition-summary">{{ formatDefinition(scope.row) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="170" align="center" class-name="small-padding fixed-width" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['iot:productTemplates:edit']">修改</el-button>
          <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['iot:productTemplates:remove']">删除</el-button>
        </template>
      </el-table-column>
      <template #empty>
        <el-empty :description="loading ? '加载中...' : keyword || activeClassify !== 'all' ? '没有匹配的物模型' : '暂未定义物模型'" />
      </template>
    </el-table>

    <!-- 添加枚举项对话框 -->
    <el-dialog v-model="enumDialogVisible" width="480px" :title="enumDialogTitle" append-to-body
      destroy-on-close @closed="resetEnumEditor">
      <el-form :model="newEnumItem" label-position="top">
        <el-form-item label="枚举值" required>
          <el-input v-model="newEnumItem.value" placeholder="例如：0、offline" />
        </el-form-item>
        <el-form-item label="显示文本" required>
          <el-input v-model="newEnumItem.text" placeholder="例如：离线" />
        </el-form-item>
        <el-form-item label="说明">
          <el-input v-model="newEnumItem.description" type="textarea" :rows="2"
            maxlength="100" show-word-limit placeholder="说明该枚举值对应的业务状态" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="enumDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmEnumItem">
          {{ enumEditingIndex >= 0 ? '保存修改' : '添加枚举项' }}
        </el-button>
      </template>
    </el-dialog>

    <!-- 添加或修改产品物模型对话框 -->
    <el-dialog :title="title" v-model="open" width="720px" append-to-body destroy-on-close class="model-editor-dialog">
      <div class="editor-intro">
        <span><el-icon><SetUp /></el-icon></span>
        <div>
          <strong>{{ data.operator === 'edit' ? '调整现有模型定义' : '创建新的模型契约' }}</strong>
          <p>模型标识创建后不可修改，数据类型变化会重置对应的数据约束。</p>
        </div>
      </div>
      <el-form ref="productTemplatesRef" :model="form" :rules="rules" label-position="top">
        <div class="form-section-title"><span>01</span>基础定义</div>
        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="模型归类" prop="classify">
              <el-select v-model="form.classify" placeholder="请选择物模型类型" style="width: 100%">
                <el-option v-for="dict in thing_model_type" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="名称" prop="name">
              <el-input v-model="form.name" placeholder="例如：环境温度" maxlength="50" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="数据类型" prop="type">
              <el-select v-model="form.type" placeholder="请选择数据类型" style="width: 100%" @change="changeType">
                <el-option v-for="dict in value_type" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="模型标识" prop="telemetryKey">
              <el-input v-model="form.telemetryKey" placeholder="例如：temperature"
                :disabled="data.operator === 'edit'" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="读写类型" prop="operationTpye">
              <el-select v-model="form.operationTpye" placeholder="请选择读写类型" style="width: 100%">
                <el-option v-for="dict in data_type" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="模型说明" prop="description">
              <el-input v-model="form.description" type="textarea" :rows="2" maxlength="200" show-word-limit
                placeholder="说明该模型的业务含义和使用场景" />
            </el-form-item>
          </el-col>
        </el-row>

        <template v-if="form.type">
          <div class="form-section-title"><span>02</span>数据约束</div>
          <div class="definition-panel">

        <!-- 数字类型特有参数 -->
        <template v-if="['int', 'long', 'float', 'double'].includes(form.define?.valueType?.type)">
          <el-form-item label="单位" prop="valueType.unit">
            <el-select v-model="form.define.valueType.unit" filterable placeholder="请选择单位" style="width: 100%">
              <el-option v-for="unit in unitOptions" :key="unit.symbol" :label="unit.description"
                :value="unit.symbol" />
            </el-select>
          </el-form-item>
          <template v-if="form.define.valueType.type === 'double' || form.define.valueType.type === 'float'">
            <el-form-item label="精度" prop="valueType.scale">
              <el-input-number v-model="form.define.valueType.scale" :min="0" :max="10" />
            </el-form-item>
          </template>
          <el-form-item label="最小值" prop="valueType.min">
            <el-input-number v-model="form.define.valueType.min" />
          </el-form-item>
          <el-form-item label="最大值" prop="valueType.max">
            <el-input-number v-model="form.define.valueType.max" />
          </el-form-item>
        </template>

        <!-- 字符串类型特有参数 -->
        <template v-if="form.define?.valueType?.type === 'string'">
          <el-form-item label="最大长度" prop="valueType.maxLength">
            <el-input-number v-model="form.define.valueType.maxLength" :min="1" />
          </el-form-item>
        </template>

        <!-- 布尔类型特有参数 -->
        <template v-if="['boolean', 'bool'].includes(form.define?.valueType?.type)">
          <el-form-item label="true值" prop="valueType.trueValue">
            <el-input v-model="form.define.valueType.trueValue" />
          </el-form-item>
          <el-form-item label="true文本" prop="valueType.trueText">
            <el-input v-model="form.define.valueType.trueText" />
          </el-form-item>
          <el-form-item label="false值" prop="valueType.falseValue">
            <el-input v-model="form.define.valueType.falseValue" />
          </el-form-item>
          <el-form-item label="false文本" prop="valueType.falseText">
            <el-input v-model="form.define.valueType.falseText" />
          </el-form-item>
        </template>

        <!-- 枚举类型特有参数 -->
        <template v-if="isEnumType(form.define?.valueType?.type)">
          <el-form-item label="枚举项">
            <div class="enum-toolbar">
              <span>共 {{ form.define.valueType.elements?.length || 0 }} 项，枚举值不可重复</span>
              <el-button type="primary" icon="Plus" @click="openEnumDialog()">添加枚举项</el-button>
            </div>
            <el-table :data="form.define.valueType.elements" row-key="value" class="enum-table">
              <el-table-column prop="value" label="值" />
              <el-table-column prop="text" label="文本" />
              <el-table-column prop="description" label="说明" show-overflow-tooltip />
              <el-table-column label="操作" width="135" align="center">
                <template #default="scope">
                  <el-button link type="primary" icon="Edit"
                    @click="openEnumDialog(scope.row, scope.$index)">修改</el-button>
                  <el-button link type="danger" icon="Delete"
                    @click="deleteEnumItem(form.define, scope.$index)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-form-item>
        </template>

        <!-- 日期类型特有参数 -->
        <template v-if="form.define?.valueType?.type === 'date'">
          <el-form-item label="格式" prop="valueType.format">
            <el-input v-model="form.define.valueType.format" placeholder="例如: yyyy-MM-dd HH:mm:ss" />
          </el-form-item>
          <el-form-item label="时区" prop="valueType.tz">
            <el-input v-model="form.define.valueType.tz" placeholder="例如: Asia/Shanghai" />
          </el-form-item>
        </template>

        <!-- 文件类型特有参数 -->
        <template v-if="form.define?.valueType?.type === 'file'">
          <el-form-item label="内容类型" prop="valueType.bodyType">
            <el-select v-model="form.define.valueType.bodyType" placeholder="请选择内容类型" style="width: 100%">
              <el-option label="URL" value="url" />
              <el-option label="Base64" value="base64" />
              <el-option label="二进制" value="binary" />
            </el-select>
          </el-form-item>
        </template>
          </div>
        </template>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancel">取 消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitForm">
            {{ data.operator === 'edit' ? '保存修改' : '创建模型' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ProductConfig">
import {
  listProductTemplates,
  getProductTemplates,
  delProductTemplates,
  addProductTemplates,
  updateProductTemplates
} from "@/api/iot/productTemplates";
import { listUnitAll } from "@/api/iot/unit";
import { watch } from "vue";

const { proxy } = getCurrentInstance();
const { thing_model_type } = proxy.useDict('thing_model_type');
const { data_type } = proxy.useDict('data_type');
const { value_type } = proxy.useDict('value_type');

const enumDialogVisible = ref(false);
const enumEditingIndex = ref(-1);

const productTemplatesList = ref([]);
const open = ref(false);
const loading = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const title = ref("");
const unitOptions = ref([]);
const submitting = ref(false);
const keyword = ref("");
const activeClassify = ref("all");
const classifyOptions = [
  {label: "全部", value: "all"},
  {label: "属性", value: "property"},
  {label: "服务", value: "function"},
  {label: "事件", value: "event"},
];

const props = defineProps({
  productId: {
    type: [String, Number],
    default: null
  }
});

const data = reactive({
  form: {},
  queryParams: {
    productId: props.productId,
  },
  rules: {
    classify: [{required: true, message: "请选择模型归类", trigger: "change"}],
    name: [{required: true, message: "请输入模型名称", trigger: "blur"}],
    type: [{required: true, message: "请选择数据类型", trigger: "change"}],
    telemetryKey: [
      {required: true, message: "请输入模型标识", trigger: "blur"},
      {pattern: /^[A-Za-z][A-Za-z0-9_.-]{1,63}$/, message: "请以字母开头，仅使用字母、数字、点、横线或下划线", trigger: "blur"},
      {
        validator: (_rule, value, callback) => {
          const duplicate = productTemplatesList.value.some(item =>
            item.id !== data.form.id && String(item.telemetryKey).toLowerCase() === String(value).toLowerCase()
          );
          duplicate ? callback(new Error("模型标识已存在")) : callback();
        },
        trigger: "blur",
      },
    ],
    operationTpye: [{required: true, message: "请选择读写类型", trigger: "change"}],
  },
  operator: ""
});

const { queryParams, form, rules } = toRefs(data);
const newEnumItem = reactive({ value: '', text: '', description: '' });
const enumDialogTitle = computed(() => enumEditingIndex.value >= 0 ? "修改枚举项" : "添加枚举项");

const filteredProductTemplates = computed(() => {
  const search = keyword.value.trim().toLowerCase();
  return productTemplatesList.value.filter(item => {
    const matchesClassify = activeClassify.value === "all" || item.classify === activeClassify.value;
    const matchesKeyword = !search || [item.name, item.telemetryKey, item.description, item.type]
      .some(field => String(field || "").toLowerCase().includes(search));
    return matchesClassify && matchesKeyword;
  });
});

const modelStats = computed(() => {
  const rows = productTemplatesList.value;
  const properties = rows.filter(item => item.classify === "property");
  const writable = properties.filter(isWritable).length;
  return {
    total: rows.length,
    property: properties.length,
    function: rows.filter(item => item.classify === "function").length,
    event: rows.filter(item => item.classify === "event").length,
    writableRate: properties.length ? Math.round((writable / properties.length) * 100) : 0,
  };
});

function isWritable(row) {
  return String(row.operationTpye || "").toLowerCase().includes("w");
}

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
    file: "info",
  };
  return map[String(type || "").toLowerCase()] || "info";
}

function parseDefinition(define) {
  if (!define) return {};
  if (typeof define === "object") return define;
  try {
    return JSON.parse(define);
  } catch {
    return {};
  }
}

function formatDefinition(row) {
  const valueType = parseDefinition(row.define).valueType || {};
  const type = valueType.type || row.type || "未知";
  if (["int", "long", "float", "double"].includes(type)) {
    const range = valueType.min != null || valueType.max != null
      ? `${valueType.min ?? "−∞"} ~ ${valueType.max ?? "+∞"}`
      : "未限制范围";
    return `${range}${valueType.unit ? ` · ${valueType.unit}` : ""}${valueType.scale != null ? ` · ${valueType.scale} 位小数` : ""}`;
  }
  if (type === "string") return `最大长度 ${valueType.maxLength || "未限制"}`;
  if (["boolean", "bool"].includes(type)) return `${getBooleanText(valueType, "trueText", "是")} / ${getBooleanText(valueType, "falseText", "否")}`;
  if (type === "enum") return `${valueType.elements?.length || 0} 个枚举项`;
  if (type === "date") return `${valueType.format || "YYYY-MM-DD HH:mm:ss"} · ${valueType.tz || "本地时区"}`;
  if (type === "file") return `内容类型：${valueType.bodyType || "未指定"}`;
  return row.description || "使用默认数据定义";
}

function isEnumType(type) {
  return String(type || "").toLowerCase() === "enum";
}

function getBooleanText(valueType, key, fallback) {
  return valueType?.[key] || fallback;
}

function resetEnumEditor() {
  enumEditingIndex.value = -1;
  Object.assign(newEnumItem, {value: "", text: "", description: ""});
}

/** 打开枚举项编辑器 */
function openEnumDialog(item, index = -1) {
  enumEditingIndex.value = index;
  Object.assign(newEnumItem, {
    value: item?.value ?? "",
    text: item?.text ?? "",
    description: item?.description ?? "",
  });
  enumDialogVisible.value = true;
}

/** 新增或修改枚举项 */
function confirmEnumItem() {
  const elements = form.value?.define?.valueType?.elements;
  if (!Array.isArray(elements)) {
    proxy.$modal.msgWarning("请先选择枚举数据类型");
    return;
  }
  const nextItem = {
    value: String(newEnumItem.value).trim(),
    text: String(newEnumItem.text).trim(),
    description: String(newEnumItem.description || "").trim(),
  };
  if (!nextItem.value || !nextItem.text) {
    proxy.$modal.msgWarning("请填写枚举值和显示文本");
    return;
  }
  const duplicate = elements.some((item, index) =>
    index !== enumEditingIndex.value && String(item.value).trim() === nextItem.value
  );
  if (duplicate) {
    proxy.$modal.msgWarning("枚举值不能重复");
    return;
  }
  if (enumEditingIndex.value >= 0) {
    elements.splice(enumEditingIndex.value, 1, nextItem);
  } else {
    elements.push(nextItem);
  }
  enumDialogVisible.value = false;
}

/** 删除枚举项 */
function deleteEnumItem(defineData, index) {
  defineData.valueType.elements.splice(index, 1);
}

/** 查询产品物模型列表 */
function getList() {
  if (!props.productId) {
    productTemplatesList.value = [];
    loading.value = false;
    return;
  }
  loading.value = true;
  queryParams.value.productId = props.productId;
  listProductTemplates(queryParams.value)
    .then(response => {
      productTemplatesList.value = Array.isArray(response?.data) ? response.data : [];
    })
    .catch(error => {
      productTemplatesList.value = [];
      console.error("获取产品物模型失败:", error);
    })
    .finally(() => {
      loading.value = false;
    });
}

/** 取消按钮 */
function cancel() {
  open.value = false;
}

/** 表单重置 */
function reset() {
  form.value = {
    id: null,
    productId: null,
    classify: null,
    name: null,
    telemetryKey: null,
    description: null,
    type: null,
    operationTpye: null,
    define: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  };
  proxy.resetForm("productTemplatesRef");
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 数据类型切换时重置数据定义 */
function changeType(type) {
  const baseElements = [];
  let valueType = { type };

  switch (type) {
    case 'int':
    case 'long':
      valueType = { type, unit: null, min: null, max: null };
      break;
    case 'float':
    case 'double':
      valueType = { type, unit: null, min: null, max: null, scale: null };
      break;
    case 'string':
      valueType = { type, maxLength: null };
      break;
    case 'boolean':
    case 'bool':
    case 'password':
      valueType = { type, trueValue: "true", trueText: "是", falseValue: "false", falseText: "否" };
      break;
    case 'enum':
      valueType = { type, elements: baseElements };
      break;
    case 'date':
      valueType = { type, format: "YYYY-MM-DD HH:mm:ss", tz: "Asia/Shanghai" };
      break;
    case 'file':
      valueType = { type, bodyType: null };
      break;
    case 'object':
    case 'array':
      valueType = {
        type, unit: null, min: null, max: null, scale: null, maxLength: null,
        trueValue: null, trueText: null, falseValue: null, falseText: null, elements: baseElements
      };
      break;
    default:
      valueType = {
        type: null, unit: null, min: null, max: null, scale: null, maxLength: null,
        trueValue: null, trueText: null, falseValue: null, falseText: null, elements: baseElements
      };
      break;
  }

  form.value.define = { valueType };
}

/** 新增按钮操作 */
function handleAdd() {
  data.operator = "add";
  reset();
  form.value.classify = activeClassify.value === "all" ? "property" : activeClassify.value;
  form.value.operationTpye = "R";
  form.value.define = {valueType: {}};
  open.value = true;
  title.value = "添加产品物模型";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  data.operator = "edit";
  reset();
  const _id = row?.id || ids.value[0];
  if (!_id) return;
  getProductTemplates(_id).then(response => {
    form.value = response.data;
    form.value.define = parseDefinition(form.value.define);
    if (!form.value.define.valueType) {
      form.value.define.valueType = {type: form.value.type};
    }
    if (isEnumType(form.value.define.valueType.type || form.value.type)) {
      form.value.define.valueType.type = "enum";
      form.value.define.valueType.elements = Array.isArray(form.value.define.valueType.elements)
        ? form.value.define.valueType.elements.map(item => ({
          value: item?.value ?? "",
          text: item?.text ?? "",
          description: item?.description ?? "",
        }))
        : [];
    }
    open.value = true;
    title.value = "修改产品物模型";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["productTemplatesRef"].validate(valid => {
    if (!valid) return;
    const valueType = form.value.define?.valueType || {};
    if (
      ["int", "long", "float", "double"].includes(valueType.type)
      && valueType.min != null
      && valueType.max != null
      && Number(valueType.min) > Number(valueType.max)
    ) {
      proxy.$modal.msgWarning("最小值不能大于最大值");
      return;
    }
    if (isEnumType(valueType.type) && !valueType.elements?.length) {
      proxy.$modal.msgWarning("请至少添加一个枚举项");
      return;
    }
    if (
      isEnumType(valueType.type)
      && new Set(valueType.elements.map(item => String(item.value).trim())).size !== valueType.elements.length
    ) {
      proxy.$modal.msgWarning("枚举值不能重复");
      return;
    }

    const isEdit = data.operator === "edit";
    const payload = {
      ...form.value,
      id: isEdit ? form.value.id : `${props.productId}.${form.value.telemetryKey}`,
      productId: props.productId,
      define: JSON.stringify(form.value.define || {valueType: {type: form.value.type}}),
    };
    submitting.value = true;
    const action = isEdit ? updateProductTemplates : addProductTemplates;
    action(payload)
      .then(() => {
        proxy.$modal.msgSuccess(isEdit ? "修改成功" : "新增成功");
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
  proxy.$modal.confirm('是否确认删除产品物模型编号为"' + _ids + '"的数据项？').then(function () {
    return delProductTemplates(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => { });
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/productTemplates/export', {
    ...queryParams.value
  }, `productTemplates_${new Date().getTime()}.xlsx`)
}

/** 获取单位列表 */
function getUnitList() {
  listUnitAll().then(response => {
    unitOptions.value = Array.isArray(response?.data) ? response.data : [];
  }).catch(() => {
    proxy.$modal.msgError("获取单位列表失败");
  });
}

getUnitList();

watch(
  () => props.productId,
  (productId) => {
    queryParams.value.productId = productId;
    keyword.value = "";
    activeClassify.value = "all";
    getList();
  },
  {immediate: true}
);
</script>

<style scoped lang="scss">
.product-model-workspace {
  width: 100%;
}

.model-console-head {
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

.model-console-head h3 {
  margin: 0;
  color: var(--ui-text-primary);
  font-size: 17px;
}

.model-console-head p {
  margin: 5px 0 0;
  color: var(--ui-text-secondary);
  font-size: 12px;
}

.model-console-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
}

.model-search {
  width: 220px;
}

.model-overview {
  display: grid;
  grid-template-columns: repeat(4, minmax(105px, 0.65fr)) minmax(220px, 1.4fr);
  gap: 10px;
  margin-bottom: 14px;
}

.model-overview article,
.model-coverage {
  min-width: 0;
  padding: 11px 13px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.model-overview article {
  display: flex;
  align-items: center;
  gap: 10px;
}

.model-overview article > div {
  display: flex;
  flex-direction: column;
}

.model-overview strong {
  color: var(--ui-text-primary);
  font-size: 19px;
  line-height: 1.1;
}

.model-overview article span:not(.overview-icon),
.model-coverage span {
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
  color: var(--ui-text-secondary);
  background: var(--ui-surface);
  border-radius: 8px;
}

.overview-icon.is-blue {
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 10%, transparent);
}

.overview-icon.is-purple {
  color: #8b5cf6;
  background: color-mix(in srgb, #8b5cf6 10%, transparent);
}

.overview-icon.is-warning {
  color: var(--el-color-warning);
  background: color-mix(in srgb, var(--el-color-warning) 10%, transparent);
}

.model-coverage {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.model-coverage > div {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

.model-coverage strong {
  font-size: 15px;
}

.model-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 12px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-bottom: 0;
  border-radius: 10px 10px 0 0;
}

.model-toolbar > span {
  color: var(--ui-text-secondary);
  font-size: 12px;
}

.product-model-workspace :deep(.el-table) {
  border-radius: 0 0 10px 10px;
}

.model-identity {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}

.model-identity > div {
  min-width: 0;
}

.model-identity strong,
.model-identity small {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.model-identity strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.model-identity small {
  margin-top: 3px;
  color: var(--el-color-primary);
  font-family: "SFMono-Regular", Consolas, monospace;
  font-size: 11px;
}

.model-type-icon {
  display: grid;
  flex: 0 0 34px;
  width: 34px;
  height: 34px;
  place-items: center;
  color: var(--el-color-primary);
  background: color-mix(in srgb, var(--el-color-primary) 9%, var(--ui-surface));
  border-radius: 9px;
}

.definition-summary {
  color: var(--ui-text-secondary);
  font-size: 12px;
}

.editor-intro {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
  padding: 13px 15px;
  background: linear-gradient(120deg, color-mix(in srgb, var(--el-color-primary) 7%, var(--ui-surface-soft)), var(--ui-surface-soft));
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.editor-intro > span {
  display: grid;
  flex: 0 0 36px;
  width: 36px;
  height: 36px;
  place-items: center;
  color: var(--el-color-primary);
  background: var(--ui-surface);
  border-radius: 9px;
}

.editor-intro strong {
  color: var(--ui-text-primary);
  font-size: 13px;
}

.editor-intro p {
  margin: 3px 0 0;
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.form-section-title {
  display: flex;
  align-items: center;
  gap: 9px;
  margin: 4px 0 14px;
  color: var(--ui-text-primary);
  font-size: 13px;
  font-weight: 700;
}

.form-section-title span {
  display: inline-grid;
  width: 25px;
  height: 25px;
  place-items: center;
  color: var(--el-color-primary);
  font-size: 10px;
  background: color-mix(in srgb, var(--el-color-primary) 9%, transparent);
  border-radius: 7px;
}

.definition-panel {
  padding: 16px 16px 1px;
  background: var(--ui-surface-soft);
  border: 1px solid var(--ui-border);
  border-radius: 10px;
}

.definition-panel :deep(.el-input-number) {
  width: 100%;
}

.enum-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  width: 100%;
}

.enum-toolbar > span {
  color: var(--ui-text-secondary);
  font-size: 11px;
}

.enum-table {
  width: 100%;
  margin-top: 10px;
  border: 1px solid var(--ui-border);
  border-radius: 8px;
}

@media (max-width: 1050px) {
  .model-console-head {
    flex-direction: column;
  }

  .model-console-actions {
    width: 100%;
    justify-content: flex-start;
    flex-wrap: wrap;
  }

  .model-overview {
    grid-template-columns: repeat(4, 1fr);
  }

  .model-coverage {
    grid-column: 1 / -1;
  }
}

@media (max-width: 640px) {
  .model-search {
    width: 100%;
  }

  .model-overview {
    grid-template-columns: repeat(2, 1fr);
  }

  .model-coverage {
    grid-column: 1 / -1;
  }

  .model-toolbar {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
