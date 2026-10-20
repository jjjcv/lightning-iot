import type { AjaxResult } from '../common'

/** 安装目录 backup 文件夹中的系统备份文件。 */
export interface SystemBackupFile {
  fileName: string
  fileSize: number
  createTime: string
}

export type SystemBackupListResult = AjaxResult<SystemBackupFile[]>
