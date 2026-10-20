import request from '@/utils/request'

// 查询告警记录列表
export function listAlarmLog(query) {
  return request({
    url: '/iot/alarmLog/list',
    method: 'get',
    params: query
  })
}

// 查询告警记录详细
export function getAlarmLog(id) {
  return request({
    url: '/iot/alarmLog/' + id,
    method: 'get'
  })
}

// 新增告警记录
export function addAlarmLog(data) {
  return request({
    url: '/iot/alarmLog',
    method: 'post',
    data: data
  })
}

// 修改告警记录
export function updateAlarmLog(data) {
  return request({
    url: '/iot/alarmLog',
    method: 'put',
    data: data
  })
}

// 删除告警记录
export function delAlarmLog(id) {
  return request({
    url: '/iot/alarmLog/' + id,
    method: 'delete'
  })
}
