import request from '@/utils/request'
import type { AjaxResult, SystemBackupListResult } from '@/types'

/** 扫描 backup/*.zip。 */
export function listSystemBackups(): Promise<SystemBackupListResult> {
  return request({
    url: '/api/system/backup/files',
    method: 'get'
  })
}

/** 创建系统备份，后端同时持久化并返回 ZIP。 */
export function createSystemBackup(): Promise<Blob> {
  return request({
    url: '/api/system/backup',
    method: 'post',
    responseType: 'blob',
    timeout: 0,
    headers: { repeatSubmit: false }
  }) as unknown as Promise<Blob>
}

/** 下载指定系统备份。 */
export function downloadSystemBackup(fileName: string): Promise<Blob> {
  return request({
    url: `/api/system/backup/files/${encodeURIComponent(fileName)}/download`,
    method: 'get',
    responseType: 'blob',
    timeout: 0
  }) as unknown as Promise<Blob>
}

/** 删除指定系统备份。 */
export function deleteSystemBackup(fileName: string): Promise<AjaxResult> {
  return request({
    url: `/api/system/backup/files/${encodeURIComponent(fileName)}`,
    method: 'delete'
  })
}

/** 上传 ZIP 并恢复 MySQL 与 upload。 */
export function restoreSystemBackup(file: File): Promise<AjaxResult> {
  const data = new FormData()
  data.append('file', file)
  return request({
    url: '/api/system/restore',
    method: 'post',
    data,
    timeout: 0,
    headers: {
      'Content-Type': 'multipart/form-data',
      repeatSubmit: false
    }
  })
}
