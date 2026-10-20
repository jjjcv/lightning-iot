<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="auto">
      <el-form-item label="传输协议名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入传输协议名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="协议描述" prop="description">
        <el-input
          v-model="queryParams.description"
          placeholder="请输入协议描述"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="启停状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择启停状态" style="width: 160px" clearable>
          <el-option
            v-for="dict in enable_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="传输协议类型" prop="protocolType">
        <el-select v-model="queryParams.protocolType" placeholder="请选择协议类型" style="width: 160px" clearable>
          <el-option
            v-for="dict in protocol_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
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
          v-hasPermi="['iot:protocol:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:protocol:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:protocol:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:protocol:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="protocolList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="传输协议名称" align="center" prop="name" />
      <el-table-column label="协议描述" align="center" prop="description" />
      <el-table-column label="启停状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="enable_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="传输协议类型" align="center" prop="protocolType">
        <template #default="scope">
          <dict-tag :options="protocol_type" :value="scope.row.protocolType"/>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['iot:protocol:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['iot:protocol:remove']">删除</el-button>
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

    <!-- 添加或修改传输协议对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="protocolRef" :model="form" :rules="rules" label-width="auto">
        <el-form-item label="传输协议名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入传输协议名称" />
        </el-form-item>
        <el-form-item label="协议描述" prop="description">
          <el-input v-model="form.description" placeholder="请输入协议描述" />
        </el-form-item>
        <el-form-item label="启停状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择启停状态：enable，disable">
            <el-option
              v-for="dict in enable_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="传输协议配置" prop="configuration">
          <el-input v-model="form.configuration" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="传输协议类型" prop="protocolType">
          <el-select v-model="form.protocolType" placeholder="请选择传输协议类型">
            <el-option
              v-for="dict in protocol_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
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

<script setup name="Protocol">
import { listProtocol, getProtocol, delProtocol, addProtocol, updateProtocol } from "@/api/iot/protocol";

const { proxy } = getCurrentInstance();
const { enable_status, protocol_type } = proxy.useDict('enable_status', 'protocol_type');

const protocolList = ref([]);
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
    description: null,
    status: null,
    configuration: null,
    protocolType: null,
  },
  rules: {
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询传输协议列表 */
function getList() {
  loading.value = true;
  listProtocol(queryParams.value).then(response => {
    protocolList.value = response.rows;
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
    description: null,
    status: null,
    configuration: null,
    protocolType: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  };
  proxy.resetForm("protocolRef");
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
  title.value = "添加传输协议";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const _id = row.id || ids.value
  getProtocol(_id).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改传输协议";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["protocolRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateProtocol(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addProtocol(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除传输协议编号为"' + _ids + '"的数据项？').then(function() {
    return delProtocol(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/protocol/export', {
    ...queryParams.value
  }, `protocol_${new Date().getTime()}.xlsx`)
}

getList();
</script>
