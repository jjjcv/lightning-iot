<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="auto">
      <el-form-item label="产品id" prop="productId">
        <el-input
          v-model="queryParams.productId"
          placeholder="请输入产品id"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备id" prop="deviceId">
        <el-input
          v-model="queryParams.deviceId"
          placeholder="请输入设备id"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="物模型id" prop="productTemplateId">
        <el-input
          v-model="queryParams.productTemplateId"
          placeholder="请输入物模型id"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="物模型" prop="telemetryKey">
        <el-input
          v-model="queryParams.telemetryKey"
          placeholder="请输入物模型"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="网关唯一id" prop="gatewayId">
        <el-input
          v-model="queryParams.gatewayId"
          placeholder="请输入网关唯一id"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="网关数据点位id" prop="edgePointId">
        <el-input
          v-model="queryParams.edgePointId"
          placeholder="请输入网关数据点位id"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="点位值" prop="value">
        <el-input
          v-model="queryParams.value"
          placeholder="请输入点位值"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="点位值更新时间" prop="lastTime">
        <el-date-picker clearable
          v-model="queryParams.lastTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择点位值更新时间">
        </el-date-picker>
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
          v-hasPermi="['iot:binding:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:binding:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:binding:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:binding:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="bindingList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="产品id" align="center" prop="productId" />
      <el-table-column label="设备id" align="center" prop="deviceId" />
      <el-table-column label="物模型id" align="center" prop="productTemplateId" />
      <el-table-column label="物模型" align="center" prop="telemetryKey" />
      <el-table-column label="网关唯一id" align="center" prop="gatewayId" />
      <el-table-column label="网关数据点位id" align="center" prop="edgePointId" />
      <el-table-column label="点位值" align="center" prop="value" />
      <el-table-column label="点位值更新时间" align="center" prop="lastTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.lastTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['iot:binding:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['iot:binding:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改设备属性模板对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="bindingRef" :model="form" :rules="rules" label-width="auto">
        <el-form-item label="产品id" prop="productId">
          <el-input v-model="form.productId" placeholder="请输入产品id" />
        </el-form-item>
        <el-form-item label="设备id" prop="deviceId">
          <el-input v-model="form.deviceId" placeholder="请输入设备id" />
        </el-form-item>
        <el-form-item label="物模型id" prop="productTemplateId">
          <el-input v-model="form.productTemplateId" placeholder="请输入物模型id" />
        </el-form-item>
        <el-form-item label="物模型" prop="telemetryKey">
          <el-input v-model="form.telemetryKey" placeholder="请输入物模型" />
        </el-form-item>
        <el-form-item label="网关唯一id" prop="gatewayId">
          <el-input v-model="form.gatewayId" placeholder="请输入网关唯一id" />
        </el-form-item>
        <el-form-item label="网关数据点位id" prop="edgePointId">
          <el-input v-model="form.edgePointId" placeholder="请输入网关数据点位id" />
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

<script setup name="Binding">
import { listBinding, getBinding, delBinding, addBinding, updateBinding } from "@/api/iot/binding";

const { proxy } = getCurrentInstance();

const bindingList = ref([]);
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
    deviceId: null,
    productTemplateId: null,
    telemetryKey: null,
    gatewayId: null,
    edgePointId: null,
    value: null,
    lastTime: null,
  },
  rules: {
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询设备属性模板列表 */
function getList() {
  loading.value = true;
  listBinding(queryParams.value).then(response => {
    bindingList.value = response.rows;
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
    deviceId: null,
    productTemplateId: null,
    telemetryKey: null,
    gatewayId: null,
    edgePointId: null,
    value: null,
    lastTime: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  };
  proxy.resetForm("bindingRef");
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
  reset();
  open.value = true;
  title.value = "添加设备属性模板";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const _id = row.id || ids.value
  getBinding(_id).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改设备属性模板";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["bindingRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateBinding(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addBinding(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除设备属性模板编号为"' + _ids + '"的数据项？').then(function() {
    return delBinding(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/binding/export', {
    ...queryParams.value
  }, `binding_${new Date().getTime()}.xlsx`)
}

getList();
</script>
