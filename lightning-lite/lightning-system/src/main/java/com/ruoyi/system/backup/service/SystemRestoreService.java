package com.ruoyi.system.backup.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.ruoyi.system.backup.config.BackupProperties;
import com.ruoyi.system.backup.model.BackupManifest;
import com.ruoyi.system.backup.util.AppPathUtils;
import com.ruoyi.system.backup.util.BackupFileUtils;
import com.ruoyi.system.backup.util.MysqlBackupUtils;
import com.ruoyi.system.backup.util.ZipUtils;
import tools.jackson.databind.ObjectMapper;

/**
 * Restores MySQL and upload data from a system backup archive.
 */
@Service
public class SystemRestoreService
{
    private static final Logger log = LoggerFactory.getLogger(SystemRestoreService.class);

    private final BackupProperties properties;

    private final MysqlBackupUtils mysqlBackupUtils;

    private final ObjectMapper objectMapper;

    public SystemRestoreService(BackupProperties properties, MysqlBackupUtils mysqlBackupUtils,
            ObjectMapper objectMapper)
    {
        this.properties = properties;
        this.mysqlBackupUtils = mysqlBackupUtils;
        this.objectMapper = objectMapper;
    }

    public void restore(Path backupFile) throws Exception
    {
        synchronized (SystemBackupService.class)
        {
            restoreArchive(backupFile);
        }
    }

    private void restoreArchive(Path backupFile) throws Exception
    {
        if (!Files.isRegularFile(backupFile) || Files.size(backupFile) == 0)
        {
            throw new IllegalArgumentException("备份文件不存在或为空");
        }

        Path workspace = AppPathUtils.resolve(properties.getTempDirectory())
                .resolve("restore-" + UUID.randomUUID());
        Files.createDirectories(workspace);

        try
        {
            ZipUtils.unzip(backupFile, workspace);
            BackupManifest manifest = readAndValidateManifest(workspace.resolve("manifest.json"));

            Path sqlFile = workspace.resolve("mysql").resolve("database.sql");
            if (!Files.isRegularFile(sqlFile) || Files.size(sqlFile) == 0)
            {
                throw new IllegalArgumentException("备份文件缺少 MySQL 数据");
            }

            Path uploadBackup = workspace.resolve("upload");
            if (!Files.isDirectory(uploadBackup))
            {
                throw new IllegalArgumentException("备份文件缺少 upload 数据");
            }

            mysqlBackupUtils.restore(sqlFile);
            Path uploadTarget = AppPathUtils.resolve(properties.getUpload().getDirectory());
            BackupFileUtils.safeReplaceDirectory(uploadBackup, uploadTarget);
            log.info("系统恢复完成，备份时间: {}，数据库: {}", manifest.getBackupTime(), manifest.getDatabase());
        }
        finally
        {
            try
            {
                BackupFileUtils.deleteDirectory(workspace);
            }
            catch (IOException cleanupFailure)
            {
                log.warn("无法删除恢复临时目录: {}", workspace, cleanupFailure);
            }
        }
    }

    private BackupManifest readAndValidateManifest(Path manifestFile) throws IOException
    {
        if (!Files.isRegularFile(manifestFile))
        {
            throw new IllegalArgumentException("无效的系统备份文件，缺少 manifest.json");
        }

        BackupManifest manifest = objectMapper.readValue(manifestFile.toFile(), BackupManifest.class);
        if (!SystemBackupService.MANIFEST_VERSION.equals(manifest.getVersion()))
        {
            throw new IllegalArgumentException("不支持的备份版本: " + manifest.getVersion());
        }
        if (!manifest.isMysql() || !manifest.isUpload())
        {
            throw new IllegalArgumentException("备份文件未包含完整的 MySQL 和 upload 数据");
        }
        if (!Objects.equals(properties.getMysql().getDatabase(), manifest.getDatabase()))
        {
            throw new IllegalArgumentException("备份数据库与当前配置不匹配: " + manifest.getDatabase());
        }
        if (manifest.getBackupTime() == null)
        {
            throw new IllegalArgumentException("备份清单缺少备份时间");
        }
        return manifest;
    }
}
