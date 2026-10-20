package com.ruoyi.system.backup.model;

import java.time.Instant;

/**
 * A backup file discovered directly from the backup directory.
 */
public record BackupFileVO(String fileName, long fileSize, Instant createTime)
{
}
