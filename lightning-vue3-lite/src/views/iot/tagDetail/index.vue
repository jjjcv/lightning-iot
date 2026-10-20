<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="标签名称" prop="tagName">
        <el-input
          v-model="queryParams.tagName"
          placeholder="请输入标签名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="标签描述" prop="description">
        <el-input
          v-model="queryParams.description"
          placeholder="请输入标签描述"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="样式属性" prop="cssClass">
        <el-input
          v-model="queryParams.cssClass"
          placeholder="请输入样式属性"
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
          v-hasPermi="['iot:tagDetail:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:tagDetail:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:tagDetail:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:tagDetail:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="tagDetailList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="标签id" align="center" prop="tagId" />
      <el-table-column label="标签名称" align="center" prop="tagName" />
      <el-table-column label="关联产品数" align="center" prop="productCount" />
      <el-table-column label="关联设备数" align="center" prop="deviceCount" />
      <el-table-column label="标签描述" align="center" prop="description" />
      <el-table-column label="字典类型" align="center" prop="tagType" />
      <el-table-column label="样式属性" align="center" prop="cssClass" />
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['iot:tagDetail:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['iot:tagDetail:remove']">删除</el-button>
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

    <!-- 添加或修改标签详情对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="tagDetailRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="标签名称" prop="tagName">
          <el-input v-model.trim="form.tagName" placeholder="请输入标签名称（全局唯一）" maxlength="64" show-word-limit />
        </el-form-item>
        <el-form-item label="标签描述" prop="description">
          <el-input v-model="form.description" placeholder="请输入标签描述" maxlength="255" />
        </el-form-item>
        <el-form-item label="样式属性" prop="cssClass">
          <el-input v-model="form.cssClass" placeholder="请输入样式属性" maxlength="100" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" maxlength="500" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm" :loading="submitting">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="TagDetail">
import { listTagDetail, getTagDetail, delTagDetail, addTagDetail, updateTagDetail } from "@/api/iot/tagDetail";

const { proxy } = getCurrentInstance();

const tagDetailList = ref([]);
const open = ref(false);
const loading = ref(true);
const submitting = ref(false);
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
    tagName: null,
    description: null,
    tagType: null,
    cssClass: null,
  },
  rules: {
    tagName: [
      { required: true, whitespace: true, message: "标签名称不能为空", trigger: "blur" },
      { max: 64, message: "标签名称不能超过 64 个字符", trigger: "blur" },
    ],
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询标签详情列表 */
function getList() {
  loading.value = true;
  listTagDetail(queryParams.value).then(response => {
    tagDetailList.value = response.rows;
    total.value = response.total;
  }).catch(() => { tagDetailList.value = []; total.value = 0; }).finally(() => { loading.value = false; });
}

// 取消按钮
function cancel() {
  open.value = false;
  reset();
}

// 表单重置
function reset() {
  form.value = {
    tagId: null,
    tagName: null,
    description: null,
    tagType: null,
    cssClass: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  };
  proxy.resetForm("tagDetailRef");
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
  ids.value = selection.map(item => item.tagId);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加标签详情";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const _tagId = row.tagId || ids.value
  getTagDetail(_tagId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改标签详情";
  });
}

/** 提交按钮 */
function submitForm() {
  if (submitting.value) return;
  form.value.tagName = form.value.tagName?.trim();
  proxy.$refs["tagDetailRef"].validate(valid => {
    if (!valid) return;
    const isEdit = form.value.tagId != null;
    submitting.value = true;
    const action = isEdit ? updateTagDetail(form.value) : addTagDetail(form.value);
    action.then(() => {
      proxy.$modal.msgSuccess(isEdit ? "修改成功" : "新增成功");
      open.value = false;
      getList();
    }).catch(() => {}).finally(() => { submitting.value = false; });
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _tagIds = row.tagId || ids.value;
  proxy.$modal.confirm('是否确认删除标签编号为"' + _tagIds + '"的数据项？删除后将同步解除产品和设备的标签关联。').then(function() {
    return delTagDetail(_tagIds);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/tagDetail/export', {
    ...queryParams.value
  }, `tagDetail_${new Date().getTime()}.xlsx`)
}

getList();
</script>
