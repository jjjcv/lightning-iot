package com.ruoyi.system.backup.service;

import java.io.IOException;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.stream.Stream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.ruoyi.system.backup.config.BackupProperties;
import com.ruoyi.system.backup.model.BackupFileVO;
import com.ruoyi.system.backup.model.BackupManifest;
import com.ruoyi.system.backup.util.AppPathUtils;
import com.ruoyi.system.backup.util.BackupFileUtils;
import com.ruoyi.system.backup.util.MysqlBackupUtils;
import com.ruoyi.system.backup.util.ZipUtils;
import tools.jackson.databind.ObjectMapper;

/**
 * Creates and manages MySQL + upload system backup archives.
 */
@Service
public class SystemBackupService
{
    public static final String MANIFEST_VERSION = "1.0";

    private static final Logger log = LoggerFactory.getLogger(SystemBackupService.class);

    private static final DateTimeFormatter FILE_TIME = DateTimeFormatter.ofPattern("yyyyMMdd-HHmmss");

    private final BackupProperties properties;

    private final MysqlBackupUtils mysqlBackupUtils;

    private final ObjectMapper objectMapper;

    public SystemBackupService(BackupProperties properties, MysqlBackupUtils mysqlBackupUtils,
            ObjectMapper objectMapper)
    {
        this.properties = properties;
        this.mysqlBackupUtils = mysqlBackupUtils;
        this.objectMapper = objectMapper;
    }

    public Path backup() throws Exception
    {
        synchronized (SystemBackupService.class)
        {
            return createBackup();
        }
    }

    public List<BackupFileVO> listBackups() throws IOException
    {
        Path directory = backupDirectory();
        if (!Files.isDirectory(directory))
        {
            return List.of();
        }

        List<BackupFileVO> backups = new ArrayList<>();
        try (Stream<Path> stream = Files.list(directory))
        {
            for (Path path : stream.filter(Files::isRegularFile)
                    .filter(item -> item.getFileName().toString().endsWith(".zip"))
                    .toList())
            {
                backups.add(new BackupFileVO(path.getFileName().toString(), Files.size(path),
                        Files.getLastModifiedTime(path).toInstant()));
            }
        }
        backups.sort(Comparator.comparing(BackupFileVO::createTime).reversed());
        return backups;
    }

    public Path getBackupFile(String fileName) throws IOException
    {
        Path file = resolveBackupFile(fileName);
        if (!Files.isRegularFile(file))
        {
            throw new IOException("备份文件不存在: " + fileName);
        }
        return file;
    }

    public void deleteBackup(String fileName) throws IOException
    {
        Path file = resolveBackupFile(fileName);
        if (!Files.deleteIfExists(file))
        {
            throw new IOException("备份文件不存在: " + fileName);
        }
    }

    private Path createBackup() throws Exception
    {
        LocalDateTime backupTime = LocalDateTime.now();
        String baseName = "system-backup-" + backupTime.format(FILE_TIME);
        Path backupDirectory = backupDirectory();
        Path tempDirectory = AppPathUtils.resolve(properties.getTempDirectory());
        Files.createDirectories(backupDirectory);
        Files.createDirectories(tempDirectory);

        Path output = uniqueOutputFile(backupDirectory, baseName);
        Path partialOutput = backupDirectory.resolve("." + output.getFileName() + "." + UUID.randomUUID() + ".part");
        Path workspace = tempDirectory.resolve("backup-" + UUID.randomUUID());
        Files.createDirectories(workspace);

        try
        {
            Path mysqlDirectory = workspace.resolve("mysql");
            Files.createDirectories(mysqlDirectory);
            mysqlBackupUtils.backup(mysqlDirectory.resolve("database.sql"));

            Path uploadSource = AppPathUtils.resolve(properties.getUpload().getDirectory());
            BackupFileUtils.copyDirectory(uploadSource, workspace.resolve("upload"));

            BackupManifest manifest = new BackupManifest(MANIFEST_VERSION, backupTime,
                    properties.getMysql().getDatabase(), true, true);
            objectMapper.writerWithDefaultPrettyPrinter()
                    .writeValue(workspace.resolve("manifest.json").toFile(), manifest);

            ZipUtils.zip(workspace, partialOutput);
            moveCompletedArchive(partialOutput, output);
            return output;
        }
        catch (Exception e)
        {
            Files.deleteIfExists(partialOutput);
            throw e;
        }
        finally
        {
            try
            {
                BackupFileUtils.deleteDirectory(workspace);
            }
            catch (IOException cleanupFailure)
            {
                log.warn("无法删除备份临时目录: {}", workspace, cleanupFailure);
            }
        }
    }

    private Path uniqueOutputFile(Path directory, String baseName)
    {
        Path candidate = directory.resolve(baseName + ".zip");
        int suffix = 1;
        while (Files.exists(candidate))
        {
            candidate = directory.resolve(baseName + "-" + suffix++ + ".zip");
        }
        return candidate;
    }

    private void moveCompletedArchive(Path source, Path target) throws IOException
    {
        try
        {
            Files.move(source, target, StandardCopyOption.ATOMIC_MOVE);
        }
        catch (AtomicMoveNotSupportedException e)
        {
            Files.move(source, target);
        }
    }

    private Path backupDirectory()
    {
        return AppPathUtils.resolve(properties.getBackupDirectory());
    }

    private Path resolveBackupFile(String fileName)
    {
        if (fileName == null || fileName.isBlank() || !fileName.endsWith(".zip")
                || !fileName.matches("[A-Za-z0-9._-]+"))
        {
            throw new IllegalArgumentException("非法备份文件名: " + fileName);
        }

        Path directory = backupDirectory();
        Path file = directory.resolve(fileName).normalize();
        if (!file.getParent().equals(directory))
        {
            throw new IllegalArgumentException("非法备份文件名: " + fileName);
        }
        return file;
    }
}
