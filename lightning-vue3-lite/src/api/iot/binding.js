import request from '@/utils/request'

// 查询设备属性模板列表
export function listBinding(query) {
  return request({
    url: '/iot/binding/list',
    method: 'get',
    params: query
  })
}

// 查询设备属性模板列表
export function listAllBinding(query) {
  return request({
    url: '/iot/binding/list/all',
    method: 'get',
    params: query
  })
}

// 查询设备属性模板详细
export function getBinding(id) {
  return request({
    url: '/iot/binding/' + id,
    method: 'get'
  })
}

// 新增设备属性模板
export function addBinding(data) {
  return request({
    url: '/iot/binding',
    method: 'post',
    data: data
  })
}

// 修改设备属性模板
export function updateBinding(data) {
  return request({
    url: '/iot/binding',
    method: 'put',
    data: data
  })
}

// 删除设备属性模板
export function delBinding(id) {
  return request({
    url: '/iot/binding/' + id,
    method: 'delete'
  })
}
