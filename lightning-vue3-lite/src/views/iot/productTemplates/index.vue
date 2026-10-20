<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="产品Id" prop="productId">
        <el-input
          v-model="queryParams.productId"
          placeholder="请输入产品Id"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="模型归类" prop="classify">
        <el-input
          v-model="queryParams.classify"
          placeholder="property，function，event"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="标识" prop="telemetryKey">
        <el-input
          v-model="queryParams.telemetryKey"
          placeholder="请输入标识"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="属性说明" prop="description">
        <el-input
          v-model="queryParams.description"
          placeholder="请输入属性说明"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="读写类型" prop="operationTpye">
        <el-input
          v-model="queryParams.operationTpye"
          placeholder="r读，w写，p上报"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['iot:productTemplates:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:productTemplates:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:productTemplates:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:productTemplates:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="productTemplatesList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="" align="center" prop="id" />
      <el-table-column label="产品Id" align="center" prop="productId" />
      <el-table-column label="模型归类" align="center" prop="classify" />
      <el-table-column label="名称" align="center" prop="name" />
      <el-table-column label="标识" align="center" prop="telemetryKey" />
      <el-table-column label="属性说明" align="center" prop="description" />
      <el-table-column label="数据类型" align="center" prop="type" />
      <el-table-column label="读写类型" align="center" prop="operationTpye" />
      <el-table-column label="数据定义" align="center" prop="define" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['iot:productTemplates:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['iot:productTemplates:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    

    <!-- 添加或修改产品物模型对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="productTemplatesRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="物模型Id" prop="id">
          <el-input v-model="form.id" placeholder="请输入物模型Id" />
        </el-form-item>
        <el-form-item label="产品Id" prop="productId">
          <el-input v-model="form.productId" placeholder="请输入产品Id" />
        </el-form-item>
        <el-form-item label="模型归类" prop="classify">
          <el-input v-model="form.classify" placeholder="property，function，event" />
        </el-form-item>
        <el-form-item label="数据类型" prop="type">
          <el-input v-model="form.type" placeholder="请输入数据类型" />
        </el-form-item>
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入名称" />
        </el-form-item>
        <el-form-item label="标识" prop="telemetryKey">
          <el-input v-model="form.telemetryKey" placeholder="请输入标识" />
        </el-form-item>
        <el-form-item label="属性说明" prop="description">
          <el-input v-model="form.description" placeholder="请输入属性说明" />
        </el-form-item>
        <el-form-item label="读写类型" prop="operationTpye">
          <el-input v-model="form.operationTpye" placeholder="r读，w写，p上报" />
        </el-form-item>
        <el-form-item label="数据定义" prop="define">
          <el-input v-model="form.define" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ProductTemplates">
import { listProductTemplates, getProductTemplates, delProductTemplates, addProductTemplates, updateProductTemplates } from "@/api/iot/productTemplates";

const { proxy } = getCurrentInstance();

const productTemplatesList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    productId: null,
    classify: null,
    name: null,
    telemetryKey: null,
    description: null,
    type: null,
    operationTpye: null,
    define: null,
  },
  rules: {
  },
  operator: ""
});

const { queryParams, form, rules } = toRefs(data);

/** 查询产品物模型列表 */
function getList() {
  loading.value = true;
  listProductTemplates(queryParams.value).then(response => {
    productTemplatesList.value = response.data;
    total.value = response.total;
    loading.value = false;
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

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 新增按钮操作 */
function handleAdd() {
  data.operator = "add";
  reset();
  open.value = true;
  title.value = "添加产品物模型";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  data.operator = "edit";
  reset();
  const _id = row.id || ids.value
  getProductTemplates(_id).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改产品物模型";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["productTemplatesRef"].validate(valid => {
    if (valid) {
      if (data.operator == "edit") {
        updateProductTemplates(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addProductTemplates(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功");
          open.value = false;
          getList();
        });
      }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row.id || ids.value;
  proxy.$modal.confirm('是否确认删除产品物模型编号为"' + _ids + '"的数据项？').then(function() {
    return delProductTemplates(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/productTemplates/export', {
    ...queryParams.value
  }, `productTemplates_${new Date().getTime()}.xlsx`)
}

getList();
</script>
