import request from '@/utils/request'

// 查询产品类型列表
export function listProductCategories(query) {
  return request({
    url: '/iot/productCategories/list',
    method: 'get',
    params: query
  })
}

export function listCategoryExcludeChild(categoryId) {
  return request({
    url: '/iot/productCategories/list/exclude/' + categoryId,
    method: 'get'
  })
}


// 查询产品类型详细
export function getProductCategories(categoryId) {
  return request({
    url: '/iot/productCategories/' + categoryId,
    method: 'get'
  })
}

// 新增产品类型
export function addProductCategories(data) {
  return request({
    url: '/iot/productCategories',
    method: 'post',
    data: data
  })
}

// 修改产品类型
export function updateProductCategories(data) {
  return request({
    url: '/iot/productCategories',
    method: 'put',
    data: data
  })
}

// 删除产品类型
export function delProductCategories(categoryId) {
  return request({
    url: '/iot/productCategories/' + categoryId,
    method: 'delete'
  })
}
