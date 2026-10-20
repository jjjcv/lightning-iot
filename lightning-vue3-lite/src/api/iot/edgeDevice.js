import request from '@/utils/request'

// 查询设备接入网关列表
export function listEdgeDevice(query) {
  return request({
    url: '/iot/edgeDevice/list',
    method: 'get',
    params: query
  })
}

export function listAllEdgeDevice(query) {
  return request({
    url: '/iot/edgeDevice/list/all',
    method: 'get',
    params: query
  })
}

export function enableEdgeDevice(id) {
  return request({
    url: '/iot/edgeDevice/enable/' + id,
    method: 'put',
    data: {}
  })
}

export function disableEdgeDevice(id) {
  return request({
    url: '/iot/edgeDevice/disable/' + id,
    method: 'put',
    data: {}
  })
}

// 查询设备接入网关详细
export function getEdgeDevice(id) {
  return request({
    url: '/iot/edgeDevice/' + id,
    method: 'get',
  })
}

// 设备接入网关统计
export function statisticsEdgeDevice() {
  return request({
    url: '/iot/edgeDevice/statistics',
    method: 'get'
  })
}

// 新增设备接入网关
export function addEdgeDevice(data) {
  return request({
    url: '/iot/edgeDevice',
    method: 'post',
    data: data
  })
}

// 修改设备接入网关
export function updateEdgeDevice(data) {
  return request({
    url: '/iot/edgeDevice',
    method: 'put',
    data: data
  })
}

// 删除设备接入网关
export function delEdgeDevice(id) {
  return request({
    url: '/iot/edgeDevice/' + id,
    method: 'delete'
  })
}
