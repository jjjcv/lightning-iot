import request from '@/utils/request'

// 查询DeviceHistory列表
export function listDeviceHistoryAll(query) {
  return request({
    url: '/iot/deviceHistory/list/all',
    method: 'get',
    params: query
  })
}

// 查询DeviceHistory列表
export function listDeviceHistory(query) {
  return request({
    url: '/iot/deviceHistory/list',
    method: 'get',
    params: query
  })
}

// 查询DeviceHistory详细
export function getDeviceHistory(id) {
  return request({
    url: '/iot/deviceHistory/' + id,
    method: 'get'
  })
}

// 新增DeviceHistory
export function addDeviceHistory(data) {
  return request({
    url: '/iot/deviceHistory',
    method: 'post',
    data: data
  })
}

// 修改DeviceHistory
export function updateDeviceHistory(data) {
  return request({
    url: '/iot/deviceHistory',
    method: 'put',
    data: data
  })
}

// 删除DeviceHistory
export function delDeviceHistory(id) {
  return request({
    url: '/iot/deviceHistory/' + id,
    method: 'delete'
  })
}
