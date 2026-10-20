<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="产品类型名称" prop="categoryName">
        <el-input v-model="queryParams.categoryName" placeholder="请输入产品类型名称" clearable style="width: 200px"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="产品类型状态" clearable style="width: 200px">
          <el-option v-for="dict in sys_normal_disable" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd"
          v-hasPermi="['iot:productCategories:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['iot:productCategories:export']">导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="Sort" @click="toggleExpandAll">展开/折叠</el-button>
      </el-col>

      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>




    <el-table v-if="refreshTable" v-loading="loading" :data="categoryList" row-key="categoryId"
      :default-expand-all="isExpandAll" :tree-props="{ children: 'children', hasChildren: 'hasChildren' }">
      <el-table-column label="产品类型名称" align="center" prop="categoryName" />
      <el-table-column label="显示顺序" align="center" prop="orderNum" />
      <el-table-column label="产品类型说明" align="center" prop="description" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="sys_normal_disable" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="200">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['iot:productCategories:edit']">修改</el-button>
          <el-button link type="primary" icon="Plus" @click="handleAdd(scope.row)"
            v-hasPermi="['iot:productCategories:add']">新增</el-button>
          <el-button v-if="scope.row.parentId != 0" link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['iot:productCategories:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>


    <!-- 添加或修改产品类型对话框 -->
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="productCategoriesRef" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="24" v-if="form.parentId !== 0">
            <el-form-item label="上级产品类型" prop="parentId">
              <el-tree-select v-model="form.parentId" :data="categoryOptions"
                :props="{ value: 'categoryId', label: 'categoryName', children: 'children' }" value-key="categoryId"
                placeholder="选择上级产品类型" check-strictly />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="产品类型名称" prop="categoryName">
              <el-input v-model="form.categoryName" placeholder="请输入产品类型名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="显示排序" prop="orderNum">
              <el-input-number v-model="form.orderNum" controls-position="right" :min="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="产品类型状态">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in sys_normal_disable" :key="dict.value" :value="dict.value">{{ dict.label
                  }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="产品类型说明" prop="description">
              <el-input style="width: 360px" maxlength="200" type="textarea"
                v-model="form.description" placeholder="请输入产品类型说明" />
            </el-form-item>
          </el-col>
        </el-row>
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

<script setup name="ProductCategories">
import { listProductCategories, listCategoryExcludeChild, getProductCategories, delProductCategories, addProductCategories, updateProductCategories } from "@/api/iot/productCategories";

const { proxy } = getCurrentInstance();
const { sys_normal_disable } = proxy.useDict("sys_normal_disable");



const categoryList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const title = ref("");
const categoryOptions = ref([]);
const isExpandAll = ref(true);
const refreshTable = ref(true);


const data = reactive({
  form: {},
  queryParams: {
    categoryName: undefined,
    status: undefined,
  },
  rules: {
    parentId: [{ required: true, message: "上级类型不能为空", trigger: "blur" }],
    categoryName: [{ required: true, message: "类型名称不能为空", trigger: "blur" }],
    orderNum: [{ required: true, message: "显示排序不能为空", trigger: "blur" }],
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询产品类型列表 */
function getList() {
  loading.value = true;
  listProductCategories(queryParams.value).then(response => {
    categoryList.value = proxy.handleTree(response.data, "categoryId");
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
    categoryId: null,
    parentId: null,
    ancestors: null,
    categoryName: null,
    orderNum: 0,
    description: null,
    status: "0",
    delFlag: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  };
  proxy.resetForm("productCategoriesRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef");
  handleQuery();
}


/** 新增按钮操作 */
function handleAdd(row) {
  reset();

  listProductCategories().then(response => {
    categoryOptions.value = proxy.handleTree(response.data, "categoryId");
  });
  if (row != undefined) {
    form.value.parentId = row.categoryId;
  }

  open.value = true;
  title.value = "添加产品类型";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();

  listCategoryExcludeChild(row.categoryId).then(response => {
    deptOptions.value = proxy.handleTree(response.data, "categoryId");
  });

  const _categoryId = row.categoryId || ids.value
  getProductCategories(_categoryId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改产品类型";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["productCategoriesRef"].validate(valid => {
    if (valid) {
      if (form.value.categoryId != null) {
        updateProductCategories(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addProductCategories(form.value).then(response => {
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
  const _categoryIds = row.categoryId || ids.value;
  proxy.$modal.confirm('是否确认删除产品类型编号为"' + _categoryIds + '"的数据项？').then(function() {
    return delProductCategories(_categoryIds);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('iot/productCategories/export', {
    ...queryParams.value
  }, `productCategories_${new Date().getTime()}.xlsx`)
}

/** 展开/折叠操作 */
function toggleExpandAll() {
  refreshTable.value = false;
  isExpandAll.value = !isExpandAll.value;
  nextTick(() => {
    refreshTable.value = true;
  });
}







getList();
</script>
