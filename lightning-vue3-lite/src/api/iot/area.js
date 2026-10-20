import request from '@/utils/request'

// 查询区域信息列表
export function listArea(query) {
  return request({
    url: '/iot/area/list',
    method: 'get',
    params: query
  })
}

// 查询区域信息详细
export function getArea(id) {
  return request({
    url: '/iot/area/' + id,
    method: 'get'
  })
}

// 新增区域信息
export function addArea(data) {
  return request({
    url: '/iot/area',
    method: 'post',
    data: data
  })
}

// 修改区域信息
export function updateArea(data) {
  return request({
    url: '/iot/area',
    method: 'put',
    data: data
  })
}

// 删除区域信息
export function delArea(id) {
  return request({
    url: '/iot/area/' + id,
    method: 'delete'
  })
}
