<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="解析包名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入解析包名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="解析包描述" prop="description">
        <el-input
          v-model="queryParams.description"
          placeholder="请输入解析包描述"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="通信协议名称" prop="protocolId">
        <el-input
          v-model="queryParams.protocolId"
          placeholder="请输入通信协议名称"
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
          v-hasPermi="['iot:transparentCodec:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:transparentCodec:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:transparentCodec:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:transparentCodec:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="transparentCodecList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="解析包名称" align="center" prop="name" />
      <el-table-column label="解析包提供商" align="center" prop="provider" />
      <el-table-column label="解析包描述" align="center" prop="description" />
      <el-table-column label="通信协议名称" align="center" prop="protocolId" />
      <el-table-column label="通信包文件地址" align="center" prop="fileUrl" />
      <el-table-column label="协议包编解码配置" align="center" prop="configuration" />
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['iot:transparentCodec:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['iot:transparentCodec:remove']">删除</el-button>
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

    <!-- 添加或修改透传消息解析器对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="transparentCodecRef" :model="form" :rules="rules" label-width="130px">
        <el-form-item label="ID" prop="id">
          <el-input v-model="form.id" placeholder="请输入id" :disabled = "data.operator === 'edit'"/>
        </el-form-item>
        <el-form-item label="解析包名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入解析包名称" />
        </el-form-item>
        <el-form-item label="解析包提供商" prop="provider">
          <el-input v-model="form.provider" placeholder="请输入解析包提供商" />
        </el-form-item>
        <el-form-item label="解析包描述" prop="description">
          <el-input v-model="form.description" placeholder="请输入解析包描述" />
        </el-form-item>
        <el-form-item label="通信协议名称" prop="protocolId">
          <el-input v-model="form.protocolId" placeholder="请输入通信协议名称" />
        </el-form-item>
        <el-form-item label="通信包文件地址" prop="fileUrl">
          <el-input v-model="form.fileUrl" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="协议包编解码配置" prop="configuration">
          <el-input v-model="form.configuration" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
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

<script setup name="TransparentCodec">
import { listTransparentCodec, getTransparentCodec, delTransparentCodec, addTransparentCodec, updateTransparentCodec } from "@/api/iot/transparentCodec";

const { proxy } = getCurrentInstance();

const transparentCodecList = ref([]);
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
    id: null,
    name: null,
    provider: null,
    description: null,
    protocolId: null,
    fileUrl: null,
    configuration: null,
  },
  rules: {
    name: [
      { required: true, message: "解析包名称不能为空", trigger: "blur" }
    ],
  },
  operator: ""
});

const { queryParams, form, rules } = toRefs(data);

/** 查询透传消息解析器列表 */
function getList() {
  loading.value = true;
  listTransparentCodec(queryParams.value).then(response => {
    transparentCodecList.value = response.rows;
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
    name: null,
    provider: null,
    description: null,
    protocolId: null,
    fileUrl: null,
    configuration: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  };
  proxy.resetForm("transparentCodecRef");
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
  title.value = "添加透传消息解析器";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  data.operator = "edit";
  reset();
  const _id = row.id || ids.value
  getTransparentCodec(_id).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改透传消息解析器";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["transparentCodecRef"].validate(valid => {
    if (valid) {
      if (data.operator == "edit") {
        updateTransparentCodec(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addTransparentCodec(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除透传消息解析器编号为"' + _ids + '"的数据项？').then(function() {
    return delTransparentCodec(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/transparentCodec/export', {
    ...queryParams.value
  }, `transparentCodec_${new Date().getTime()}.xlsx`)
}

getList();
</script>
