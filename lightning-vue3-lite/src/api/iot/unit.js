import request from '@/utils/request'

// 查询全部单位信息列表
export function listUnitAll(query) {
  return request({
    url: '/iot/unit/list/all',
    method: 'get',
    params: query
  })
}


// 查询单位信息列表
export function listUnit(query) {
  return request({
    url: '/iot/unit/list',
    method: 'get',
    params: query
  })
}

// 查询单位信息详细
export function getUnit(id) {
  return request({
    url: '/iot/unit/' + id,
    method: 'get'
  })
}

// 新增单位信息
export function addUnit(data) {
  return request({
    url: '/iot/unit',
    method: 'post',
    data: data
  })
}

// 修改单位信息
export function updateUnit(data) {
  return request({
    url: '/iot/unit',
    method: 'put',
    data: data
  })
}

// 删除单位信息
export function delUnit(id) {
  return request({
    url: '/iot/unit/' + id,
    method: 'delete'
  })
}
