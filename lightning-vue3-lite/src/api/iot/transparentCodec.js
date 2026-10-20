import request from '@/utils/request'

// 查询透传消息解析器列表
export function listTransparentCodec(query) {
  return request({
    url: '/iot/transparentCodec/list',
    method: 'get',
    params: query
  })
}

// 查询全部消息解析器
export function listAllTransparentCodec(query) {
  return request({
    url: '/iot/transparentCodec/list/all',
    method: 'get',
    params: query
  })
}

// 查询透传消息解析器详细
export function getTransparentCodec(id) {
  return request({
    url: '/iot/transparentCodec/' + id,
    method: 'get'
  })
}

// 新增透传消息解析器
export function addTransparentCodec(data) {
  return request({
    url: '/iot/transparentCodec',
    method: 'post',
    data: data
  })
}

// 修改透传消息解析器
export function updateTransparentCodec(data) {
  return request({
    url: '/iot/transparentCodec',
    method: 'put',
    data: data
  })
}

// 删除透传消息解析器
export function delTransparentCodec(id) {
  return request({
    url: '/iot/transparentCodec/' + id,
    method: 'delete'
  })
}
