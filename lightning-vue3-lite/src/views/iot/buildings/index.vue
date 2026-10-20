<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="建筑编码" prop="buildingCode">
        <el-input
          v-model="queryParams.buildingCode"
          placeholder="请输入建筑编码"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="建筑名称" prop="buildingName">
        <el-input
          v-model="queryParams.buildingName"
          placeholder="请输入建筑名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="总面积(m²)" prop="totalArea">
        <el-input
          v-model="queryParams.totalArea"
          placeholder="请输入总面积(m²)"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="楼层数" prop="floors">
        <el-input
          v-model="queryParams.floors"
          placeholder="请输入楼层数"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="建成年份" prop="constructionYear">
        <el-input
          v-model="queryParams.constructionYear"
          placeholder="请输入建成年份"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="地理位置" prop="location">
        <el-input
          v-model="queryParams.location"
          placeholder="请输入地理位置"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="结构形式" prop="buildingStructure">
        <el-input
          v-model="queryParams.buildingStructure"
          placeholder="请输入结构形式"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="空调覆盖面积 m2" prop="airConditioningArea">
        <el-input
          v-model="queryParams.airConditioningArea"
          placeholder="请输入空调覆盖面积 m2"
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
          v-hasPermi="['iot:buildings:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['iot:buildings:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['iot:buildings:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['iot:buildings:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="buildingsList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="主键ID" align="center" prop="id" />
      <el-table-column label="建筑编码" align="center" prop="buildingCode" />
      <el-table-column label="建筑名称" align="center" prop="buildingName" />
      <el-table-column label="建筑类型" align="center" prop="buildingType" />
      <el-table-column label="总面积(m²)" align="center" prop="totalArea" />
      <el-table-column label="楼层数" align="center" prop="floors" />
      <el-table-column label="建成年份" align="center" prop="constructionYear" />
      <el-table-column label="地理位置" align="center" prop="location" />
      <el-table-column label="结构形式" align="center" prop="buildingStructure" />
      <el-table-column label="外墙保温形式" align="center" prop="exteriorWallInsulationType" />
      <el-table-column label="屋面保温形式" align="center" prop="roofInsulationType" />
      <el-table-column label="外窗类型" align="center" prop="windowType" />
      <el-table-column label="玻璃类型" align="center" prop="glassType" />
      <el-table-column label="空调覆盖面积 m2" align="center" prop="airConditioningArea" />
      <el-table-column label="空调形式" align="center" prop="airConditioningType" />
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['iot:buildings:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['iot:buildings:remove']">删除</el-button>
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

    <!-- 添加或修改建筑基础信息对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="buildingsRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="建筑编码" prop="buildingCode">
          <el-input v-model="form.buildingCode" placeholder="请输入建筑编码" />
        </el-form-item>
        <el-form-item label="建筑名称" prop="buildingName">
          <el-input v-model="form.buildingName" placeholder="请输入建筑名称" />
        </el-form-item>
        <el-form-item label="总面积(m²)" prop="totalArea">
          <el-input v-model="form.totalArea" placeholder="请输入总面积(m²)" />
        </el-form-item>
        <el-form-item label="楼层数" prop="floors">
          <el-input v-model="form.floors" placeholder="请输入楼层数" />
        </el-form-item>
        <el-form-item label="建成年份" prop="constructionYear">
          <el-input v-model="form.constructionYear" placeholder="请输入建成年份" />
        </el-form-item>
        <el-form-item label="地理位置" prop="location">
          <el-input v-model="form.location" placeholder="请输入地理位置" />
        </el-form-item>
        <el-form-item label="结构形式" prop="buildingStructure">
          <el-input v-model="form.buildingStructure" placeholder="请输入结构形式" />
        </el-form-item>
        <el-form-item label="空调覆盖面积 m2" prop="airConditioningArea">
          <el-input v-model="form.airConditioningArea" placeholder="请输入空调覆盖面积 m2" />
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

<script setup name="Buildings">
import { listBuildings, getBuildings, delBuildings, addBuildings, updateBuildings } from "@/api/iot/buildings";

const { proxy } = getCurrentInstance();

const buildingsList = ref([]);
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
    buildingCode: null,
    buildingName: null,
    buildingType: null,
    totalArea: null,
    floors: null,
    constructionYear: null,
    location: null,
    buildingStructure: null,
    exteriorWallInsulationType: null,
    roofInsulationType: null,
    windowType: null,
    glassType: null,
    airConditioningArea: null,
    airConditioningType: null,
  },
  rules: {
    buildingCode: [
      { required: true, message: "建筑编码不能为空", trigger: "blur" }
    ],
    buildingName: [
      { required: true, message: "建筑名称不能为空", trigger: "blur" }
    ],
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询建筑基础信息列表 */
function getList() {
  loading.value = true;
  listBuildings(queryParams.value).then(response => {
    buildingsList.value = response.rows;
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
    buildingCode: null,
    buildingName: null,
    buildingType: null,
    totalArea: null,
    floors: null,
    constructionYear: null,
    location: null,
    buildingStructure: null,
    exteriorWallInsulationType: null,
    roofInsulationType: null,
    windowType: null,
    glassType: null,
    airConditioningArea: null,
    airConditioningType: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  };
  proxy.resetForm("buildingsRef");
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
  title.value = "添加建筑基础信息";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const _id = row.id || ids.value
  getBuildings(_id).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改建筑基础信息";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["buildingsRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateBuildings(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addBuildings(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除建筑基础信息编号为"' + _ids + '"的数据项？').then(function() {
    return delBuildings(_ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/buildings/export', {
    ...queryParams.value
  }, `buildings_${new Date().getTime()}.xlsx`)
}

getList();
</script>
