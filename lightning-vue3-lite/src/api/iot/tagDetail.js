import request from '@/utils/request'

// 产品、设备页面的标签选项。
export function listTagOptions() {
  return request({ url: '/iot/tagDetail/list/all', method: 'get' })
}

// 查询标签详情列表
export function listTagDetail(query) {
  return request({
    url: '/iot/tagDetail/list',
    method: 'get',
    params: query
  })
}

// 查询标签详情详细
export function getTagDetail(tagId) {
  return request({
    url: '/iot/tagDetail/' + tagId,
    method: 'get'
  })
}

// 新增标签详情
export function addTagDetail(data) {
  return request({
    url: '/iot/tagDetail',
    method: 'post',
    data: data
  })
}

// 修改标签详情
export function updateTagDetail(data) {
  return request({
    url: '/iot/tagDetail',
    method: 'put',
    data: data
  })
}

// 删除标签详情
export function delTagDetail(tagId) {
  return request({
    url: '/iot/tagDetail/' + tagId,
    method: 'delete'
  })
}
