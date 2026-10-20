import request from '@/utils/request'

// 查询建筑基础信息列表
export function listBuildings(query) {
  return request({
    url: '/iot/buildings/list',
    method: 'get',
    params: query
  })
}

// 查询建筑基础信息详细
export function getBuildings(id) {
  return request({
    url: '/iot/buildings/' + id,
    method: 'get'
  })
}

// 新增建筑基础信息
export function addBuildings(data) {
  return request({
    url: '/iot/buildings',
    method: 'post',
    data: data
  })
}

// 修改建筑基础信息
export function updateBuildings(data) {
  return request({
    url: '/iot/buildings',
    method: 'put',
    data: data
  })
}

// 删除建筑基础信息
export function delBuildings(id) {
  return request({
    url: '/iot/buildings/' + id,
    method: 'delete'
  })
}
