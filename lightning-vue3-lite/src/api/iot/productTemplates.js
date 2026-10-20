import request from '@/utils/request'

// 查询产品物模型列表
export function listProductTemplates(query) {
  return request({
    url: '/iot/productTemplates/list',
    method: 'get',
    params: query
  })
}

// 查询产品物模型详细
export function getProductTemplates(id) {
  return request({
    url: '/iot/productTemplates/' + id,
    method: 'get'
  })
}

// 新增产品物模型
export function addProductTemplates(data) {
  return request({
    url: '/iot/productTemplates',
    method: 'post',
    data: data
  })
}

// 修改产品物模型
export function updateProductTemplates(data) {
  return request({
    url: '/iot/productTemplates',
    method: 'put',
    data: data
  })
}

// 删除产品物模型
export function delProductTemplates(id) {
  return request({
    url: '/iot/productTemplates/' + id,
    method: 'delete'
  })
}

// 下载产品物模型导入模板
export function importTemplate() {
  return request({
    url: '/iot/productTemplates/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入产品物模型列表
export function importData(file, updateSupport) {
  const data = new FormData()
  data.append('file', file)
  return request({
    url: '/iot/productTemplates/importData',
    method: 'post',
    params: { updateSupport },
    headers: {
      'Content-Type': 'multipart/form-data',
      repeatSubmit: false
    },
    data: data
  })
}
