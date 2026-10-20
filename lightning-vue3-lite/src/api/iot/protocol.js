import request from '@/utils/request'

// 查询传输协议列表
export function listProtocol(query) {
  return request({
    url: '/iot/protocol/list',
    method: 'get',
    params: query
  })
}

export function listAllProtocol(query) {
  return request({
    url: '/iot/protocol/list/all',
    method: 'get',
    params: query
  })
}

// 查询传输协议详细
export function getProtocol(id) {
  return request({
    url: '/iot/protocol/' + id,
    method: 'get'
  })
}

// 新增传输协议
export function addProtocol(data) {
  return request({
    url: '/iot/protocol',
    method: 'post',
    data: data
  })
}

// 修改传输协议
export function updateProtocol(data) {
  return request({
    url: '/iot/protocol',
    method: 'put',
    data: data
  })
}

// 删除传输协议
export function delProtocol(id) {
  return request({
    url: '/iot/protocol/' + id,
    method: 'delete'
  })
}
