import request from '@/utils/request'

// 查询网关数据点位列表
export function listEdgeDataPoint(query) {
  return request({
    url: '/iot/edgeDataPoint/list',
    method: 'get',
    params: query
  })
}

export function listAllEdgeDataPoint(query) {
  return request({
    url: '/iot/edgeDataPoint/list/all',
    method: 'get',
    params: query
  })
}

// 查询网关数据点位详细
export function getEdgeDataPoint(id) {
  return request({
    url: '/iot/edgeDataPoint/' + id,
    method: 'get'
  })
}

// 网关数据点位统计
export function statisticsEdgeDataPoint() {
  return request({
    url: '/iot/edgeDataPoint/statistics',
    method: 'get'
  })
}

// 新增网关数据点位
export function addEdgeDataPoint(data) {
  return request({
    url: '/iot/edgeDataPoint',
    method: 'post',
    data: data
  })
}


// 下至写入网关数据点位
export function writeEdgeDataPoint(data) {
  return request({
    url: '/iot/edgeDataPoint/write',
    method: 'put',
    data: data
  })
}

// 修改网关数据点位
export function updateEdgeDataPoint(data) {
  return request({
    url: '/iot/edgeDataPoint',
    method: 'put',
    data: data
  })
}

// 删除网关数据点位
export function delEdgeDataPoint(id) {
  return request({
    url: '/iot/edgeDataPoint/' + id,
    method: 'delete'
  })
}
