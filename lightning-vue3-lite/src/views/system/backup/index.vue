<template>
  <div class="app-container system-backup-page">
    <el-alert
      title="系统备份仅包含 MySQL 数据和 upload 文件夹。恢复会覆盖当前业务数据，请在业务低峰期操作。"
      type="warning"
      :closable="false"
      show-icon
      class="page-alert"
    />

    <div class="summary-grid">
      <el-card v-for="item in summaryItems" :key="item.label" shadow="never" class="summary-card">
        <div class="summary-icon" :class="item.type">
          <el-icon><component :is="item.icon" /></el-icon>
        </div>
        <div class="summary-content">
          <div class="summary-label">{{ item.label }}</div>
          <div class="summary-value">{{ item.value }}</div>
        </div>
      </el-card>
    </div>

    <el-card shadow="never" class="backup-card">
      <template #header>
        <div class="card-header">
          <div>
            <div class="card-title">备份文件</div>
            <div class="card-subtitle">备份文件直接保存在工作目录的 backup 文件夹中</div>
          </div>
          <div class="header-actions">
            <el-button :icon="Refresh" :loading="loading" @click="fetchBackups">刷新</el-button>
            <el-button type="primary" :icon="FolderAdd" :loading="creating" @click="handleCreateBackup">
              立即备份
            </el-button>
          </div>
        </div>
      </template>

      <el-table v-loading="loading" :data="backupFiles" row-key="fileName">
        <el-table-column label="文件名" min-width="310">
          <template #default="{ row }">
            <div class="file-cell">
              <span class="zip-icon"><el-icon><Files /></el-icon></span>
              <span class="file-name">{{ row.fileName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="文件大小" width="150" align="center">
          <template #default="{ row }">{{ formatFileSize(row.fileSize) }}</template>
        </el-table-column>
        <el-table-column label="创建时间" width="190" align="center">
          <template #default="{ row }">{{ formatDateTime(row.createTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right" align="center">
          <template #default="{ row }">
            <el-button link type="primary" :icon="Download" @click="handleDownload(row)">下载</el-button>
            <el-button link type="danger" :icon="Delete" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
        <template #empty>
          <el-empty description="暂无系统备份，点击“立即备份”创建第一份备份" />
        </template>
      </el-table>
    </el-card>

    <el-card shadow="never" class="backup-card restore-card">
      <template #header>
        <div class="card-header">
          <div>
            <div class="card-title">上传备份恢复</div>
            <div class="card-subtitle">仅支持本平台生成且 manifest 版本兼容的 ZIP 文件</div>
          </div>
          <el-tag type="danger" effect="plain">高风险操作</el-tag>
        </div>
      </template>

      <el-alert type="error" :closable="false" show-icon class="restore-alert">
        <template #title>
          恢复将覆盖当前 MySQL 数据和 upload 文件。MySQL 恢复成功后无法自动回滚，请先下载并妥善保存当前备份。
        </template>
      </el-alert>

      <el-upload
        ref="uploadRef"
        class="restore-upload"
        accept=".zip,application/zip"
        :limit="1"
        :show-file-list="true"
        :auto-upload="true"
        :disabled="restoring"
        :before-upload="beforeRestoreUpload"
        :http-request="handleRestoreUpload"
        drag
      >
        <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
        <div class="el-upload__text">将系统备份 ZIP 拖到此处，或<em>点击选择文件</em></div>
        <template #tip>
          <div class="el-upload__tip">最大支持 2GB；上传后仍需二次确认才会执行恢复</div>
        </template>
      </el-upload>

      <div v-if="restoring" class="restore-progress">
        <el-icon class="is-loading"><Loading /></el-icon>
        正在上传并恢复系统数据，请勿关闭页面或停止服务……
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts" name="SystemBackup">
import { computed, onMounted, ref } from 'vue'
import dayjs from 'dayjs'
import { saveAs } from 'file-saver'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  DataLine,
  Delete,
  Download,
  Files,
  FolderAdd,
  Loading,
  Refresh,
  UploadFilled
} from '@element-plus/icons-vue'
import {
  createSystemBackup,
  deleteSystemBackup,
  downloadSystemBackup,
  listSystemBackups,
  restoreSystemBackup
} from '@/api/system/backup'
import type { SystemBackupFile } from '@/types'

const uploadRef = ref<any>()
const backupFiles = ref<SystemBackupFile[]>([])
const loading = ref(false)
const creating = ref(false)
const restoring = ref(false)

const totalSize = computed(() => backupFiles.value.reduce((sum, item) => sum + Number(item.fileSize || 0), 0))
const latestBackup = computed(() => backupFiles.value[0]?.createTime)
const summaryItems = computed(() => [
  { label: '备份数量', value: `${backupFiles.value.length} 份`, icon: Files, type: 'primary' },
  { label: '占用空间', value: formatFileSize(totalSize.value), icon: DataLine, type: 'success' },
  { label: '最近备份', value: latestBackup.value ? formatDateTime(latestBackup.value) : '暂无', icon: Refresh, type: 'warning' }
])

async function fetchBackups() {
  loading.value = true
  try {
    const response = await listSystemBackups()
    backupFiles.value = response.data || []
  } finally {
    loading.value = false
  }
}

async function handleCreateBackup() {
  creating.value = true
  try {
    const blob = await createSystemBackup()
    if (!(await validateArchiveBlob(blob))) return
    saveAs(blob, `system-backup-${dayjs().format('YYYYMMDD-HHmmss')}.zip`)
    ElMessage.success('系统备份创建成功，文件已保存并开始下载')
    await fetchBackups()
  } finally {
    creating.value = false
  }
}

async function handleDownload(row: SystemBackupFile) {
  const blob = await downloadSystemBackup(row.fileName)
  if (await validateArchiveBlob(blob)) {
    saveAs(blob, row.fileName)
  }
}

async function handleDelete(row: SystemBackupFile) {
  try {
    await ElMessageBox.confirm(`确认删除备份文件“${row.fileName}”吗？删除后无法恢复。`, '删除备份', {
      confirmButtonText: '确认删除',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteSystemBackup(row.fileName)
    ElMessage.success('备份文件已删除')
    await fetchBackups()
  } catch {
    // 用户取消时无需提示。
  }
}

function beforeRestoreUpload(file: File) {
  if (!file.name.toLowerCase().endsWith('.zip')) {
    ElMessage.error('请选择 ZIP 格式的系统备份文件')
    return false
  }
  if (file.size > 2 * 1024 * 1024 * 1024) {
    ElMessage.error('备份文件不能超过 2GB')
    return false
  }
  return true
}

async function handleRestoreUpload(options: any) {
  try {
    await ElMessageBox.confirm(
      `即将使用“${options.file.name}”覆盖当前 MySQL 数据和 upload 文件，确认继续恢复吗？`,
      '确认系统恢复',
      {
        confirmButtonText: '确认恢复',
        cancelButtonText: '取消',
        type: 'error',
        distinguishCancelAndClose: true,
        closeOnClickModal: false
      }
    )
  } catch {
    uploadRef.value?.clearFiles()
    options.onError(new Error('用户取消恢复') as any)
    return
  }

  restoring.value = true
  try {
    const response = await restoreSystemBackup(options.file as File)
    options.onSuccess(response)
    uploadRef.value?.clearFiles()
    await ElMessageBox.alert(
      '系统数据恢复成功。页面将重新加载，请重新确认当前用户、设备和上传文件数据。',
      '恢复完成',
      { confirmButtonText: '重新加载', type: 'success', closeOnClickModal: false }
    )
    window.location.reload()
  } catch (error) {
    options.onError(error as any)
  } finally {
    restoring.value = false
  }
}

async function validateArchiveBlob(blob: Blob) {
  if (!blob || blob.size === 0) {
    ElMessage.error('服务器未返回备份文件')
    return false
  }
  if (blob.type.toLowerCase().includes('json')) {
    try {
      const result = JSON.parse(await blob.text())
      ElMessage.error(result.msg || '备份操作失败')
    } catch {
      ElMessage.error('备份操作失败')
    }
    return false
  }
  return true
}

function formatFileSize(bytes: number) {
  if (!Number.isFinite(bytes) || bytes <= 0) return '0 B'
  const units = ['B', 'KB', 'MB', 'GB', 'TB']
  const index = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), units.length - 1)
  const value = bytes / Math.pow(1024, index)
  return `${value.toFixed(index === 0 ? 0 : value >= 100 ? 0 : value >= 10 ? 1 : 2)} ${units[index]}`
}

function formatDateTime(value?: string) {
  if (!value) return '—'
  const date = dayjs(value)
  return date.isValid() ? date.format('YYYY-MM-DD HH:mm:ss') : '—'
}

onMounted(fetchBackups)
</script>

<style scoped lang="scss">
.system-backup-page {
  .page-alert {
    margin-bottom: 16px;
  }
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.summary-card :deep(.el-card__body) {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 20px;
}

.summary-icon {
  display: grid;
  width: 48px;
  height: 48px;
  flex: 0 0 48px;
  place-items: center;
  border-radius: 12px;
  font-size: 24px;

  &.primary { color: var(--el-color-primary); background: var(--el-color-primary-light-9); }
  &.success { color: var(--el-color-success); background: var(--el-color-success-light-9); }
  &.warning { color: var(--el-color-warning); background: var(--el-color-warning-light-9); }
}

.summary-content { min-width: 0; }
.summary-label { margin-bottom: 6px; color: var(--el-text-color-secondary); font-size: 13px; }
.summary-value { overflow: hidden; color: var(--el-text-color-primary); font-size: 20px; font-weight: 600; text-overflow: ellipsis; white-space: nowrap; }

.backup-card {
  margin-bottom: 16px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.card-title { color: var(--el-text-color-primary); font-size: 16px; font-weight: 600; }
.card-subtitle { margin-top: 5px; color: var(--el-text-color-secondary); font-size: 13px; }
.header-actions { display: flex; gap: 8px; }

.file-cell {
  display: flex;
  align-items: center;
  min-width: 0;
  gap: 10px;
}

.zip-icon {
  display: inline-grid;
  width: 32px;
  height: 32px;
  flex: 0 0 32px;
  place-items: center;
  color: var(--el-color-primary);
  background: var(--el-color-primary-light-9);
  border-radius: 8px;
}

.file-name { overflow: hidden; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; text-overflow: ellipsis; white-space: nowrap; }
.restore-alert { margin-bottom: 18px; }

.restore-upload {
  :deep(.el-upload),
  :deep(.el-upload-dragger) {
    width: 100%;
  }
}

.restore-progress {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-top: 14px;
  color: var(--el-color-warning);
  font-size: 13px;
}

@media (max-width: 900px) {
  .summary-grid { grid-template-columns: 1fr; }
  .card-header { align-items: flex-start; flex-direction: column; }
  .header-actions { width: 100%; }
  .header-actions .el-button { flex: 1; }
}
</style>
