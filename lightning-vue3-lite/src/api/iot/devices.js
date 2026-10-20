import request from '@/utils/request'

// 查询设备列表
export function listDevices(query) {
  return request({
    url: '/iot/devices/list',
    method: 'get',
    params: query
  })
}

export function listAllDevices(query) {
  return request({
    url: '/iot/devices/list/all',
    method: 'get',
    params: query
  })
}

// 查询设备详细
export function getDevices(id) {
  return request({
    url: '/iot/devices/' + id,
    method: 'get'
  })
}

// 设备统计
export function statisticsDevices() {
  return request({
    url: '/iot/devices/statistics',
    method: 'get'
  })
}

// 新增设备
export function addDevices(data) {
  return request({
    url: '/iot/devices',
    method: 'post',
    data: data
  })
}

// 设备属性下置
export function writeDevices(data) {
  return request({
    url: '/iot/devices/write',
    method: 'post',
    data: data
  })
}

// 设备分组批量属性下置
export function writeDevicesBatch(data) {
  return request({
    url: '/iot/devices/write/batch',
    method: 'post',
    data: data
  })
}

// 修改设备
export function updateDevices(data) {
  return request({
    url: '/iot/devices',
    method: 'put',
    data: data
  })
}

// 删除设备
export function delDevices(id) {
  return request({
    url: '/iot/devices/' + id,
    method: 'delete'
  })
}

// 下载设备导入模板
export function importTemplate() {
  return request({
    url: '/iot/devices/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入设备列表
export function importData(file, updateSupport) {
  const data = new FormData()
  data.append('file', file)
  return request({
    url: '/iot/devices/importData',
    method: 'post',
    params: { updateSupport },
    headers: {
      'Content-Type': 'multipart/form-data',
      repeatSubmit: false
    },
    data: data
  })
}
