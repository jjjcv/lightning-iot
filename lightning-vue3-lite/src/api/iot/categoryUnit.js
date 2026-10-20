import request from '@/utils/request'

// 查询单位类型列表
export function listCategoryUnit(query) {
  return request({
    url: '/iot/categoryUnit/list',
    method: 'get',
    params: query
  })
}

// 查询单位类型详细
export function getCategoryUnit(id) {
  return request({
    url: '/iot/categoryUnit/' + id,
    method: 'get'
  })
}

// 新增单位类型
export function addCategoryUnit(data) {
  return request({
    url: '/iot/categoryUnit',
    method: 'post',
    data: data
  })
}

// 修改单位类型
export function updateCategoryUnit(data) {
  return request({
    url: '/iot/categoryUnit',
    method: 'put',
    data: data
  })
}

// 删除单位类型
export function delCategoryUnit(id) {
  return request({
    url: '/iot/categoryUnit/' + id,
    method: 'delete'
  })
}
