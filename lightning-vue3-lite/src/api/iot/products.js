import request from '@/utils/request'

// 查询产品信息列表
export function listProducts(query) {
  return request({
    url: '/iot/products/list',
    method: 'get',
    params: query
  })
}

export function listAllProducts(query) {
  return request({
    url: '/iot/products/list/all',
    method: 'get',
    params: query
  })
}

// 查询产品信息详细
export function getProducts(id) {
  return request({
    url: '/iot/products/' + id,
    method: 'get'
  })
}

// 新增产品信息
export function addProducts(data) {
  return request({
    url: '/iot/products',
    method: 'post',
    data: data
  })
}

// 修改产品信息
export function updateProducts(data) {
  return request({
    url: '/iot/products',
    method: 'put',
    data: data
  })
}

export function updateProductStatus(id, status) {
  return request({
    url: '/iot/products/change/status',
    method: 'put',
    params: {
      id: id,
      status: status
    },
    data: {}
  })
}

// 删除产品信息
export function delProducts(id) {
  return request({
    url: '/iot/products/' + id,
    method: 'delete'
  })
}

// 下载产品导入模板
export function importTemplate() {
  return request({
    url: '/iot/products/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入产品信息列表
export function importData(file, updateSupport) {
  const data = new FormData()
  data.append('file', file)
  return request({
    url: '/iot/products/importData',
    method: 'post',
    params: { updateSupport },
    headers: {
      'Content-Type': 'multipart/form-data',
      repeatSubmit: false
    },
    data: data
  })
}
