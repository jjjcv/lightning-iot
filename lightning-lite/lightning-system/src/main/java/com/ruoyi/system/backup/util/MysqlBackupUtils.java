package com.ruoyi.system.backup.util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Component;
import com.ruoyi.system.backup.config.BackupProperties;

/**
 * Invokes the MySQL command line tools bundled with the installation.
 */
@Component
public class MysqlBackupUtils
{
    private final BackupProperties properties;

    public MysqlBackupUtils(BackupProperties properties)
    {
        this.properties = properties;
    }

    public void backup(Path sqlFile) throws IOException, InterruptedException
    {
        BackupProperties.Mysql mysql = properties.getMysql();
        Path executable = requireExecutable(mysql.getMysqldump(), "mysqldump");
        Files.createDirectories(sqlFile.getParent());

        List<String> command = baseCommand(executable, mysql);
        command.add("--single-transaction");
        command.add("--quick");
        command.add("--routines");
        command.add("--triggers");
        command.add("--events");
        command.add("--hex-blob");
        command.add("--default-character-set=utf8mb4");
        command.add("--set-gtid-purged=OFF");
        command.add("--no-tablespaces");
        command.add(mysql.getDatabase());

        Path errorFile = Files.createTempFile(sqlFile.getParent(), "mysqldump-", ".err");
        try
        {
            ProcessBuilder builder = new ProcessBuilder(command);
            setPasswordEnvironment(builder, mysql.getPassword());
            builder.redirectOutput(sqlFile.toFile());
            builder.redirectError(errorFile.toFile());
            int exitCode = waitFor(builder.start());
            if (exitCode != 0)
            {
                Files.deleteIfExists(sqlFile);
                throw new IOException("MySQL 备份失败: " + readError(errorFile));
            }
            if (!Files.isRegularFile(sqlFile) || Files.size(sqlFile) == 0)
            {
                Files.deleteIfExists(sqlFile);
                throw new IOException("MySQL 备份失败: mysqldump 未生成 SQL 数据");
            }
        }
        finally
        {
            Files.deleteIfExists(errorFile);
        }
    }

    public void restore(Path sqlFile) throws IOException, InterruptedException
    {
        if (!Files.isRegularFile(sqlFile) || Files.size(sqlFile) == 0)
        {
            throw new IOException("MySQL 恢复文件不存在或为空: " + sqlFile);
        }

        BackupProperties.Mysql mysql = properties.getMysql();
        Path executable = requireExecutable(mysql.getMysql(), "mysql");
        List<String> command = baseCommand(executable, mysql);
        command.add("--default-character-set=utf8mb4");
        command.add(mysql.getDatabase());

        Path errorFile = Files.createTempFile(sqlFile.getParent(), "mysql-restore-", ".err");
        try
        {
            ProcessBuilder builder = new ProcessBuilder(command);
            setPasswordEnvironment(builder, mysql.getPassword());
            builder.redirectInput(sqlFile.toFile());
            builder.redirectError(errorFile.toFile());
            int exitCode = waitFor(builder.start());
            if (exitCode != 0)
            {
                throw new IOException("MySQL 恢复失败: " + readError(errorFile));
            }
        }
        finally
        {
            Files.deleteIfExists(errorFile);
        }
    }

    private List<String> baseCommand(Path executable, BackupProperties.Mysql mysql)
    {
        requireText(mysql.getHost(), "MySQL 主机");
        requireText(mysql.getUsername(), "MySQL 用户名");
        requireText(mysql.getDatabase(), "MySQL 数据库名");
        if (mysql.getPort() < 1 || mysql.getPort() > 65535)
        {
            throw new IllegalArgumentException("MySQL 端口无效: " + mysql.getPort());
        }

        List<String> command = new ArrayList<>();
        command.add(executable.toString());
        command.add("-h");
        command.add(mysql.getHost());
        command.add("-P");
        command.add(String.valueOf(mysql.getPort()));
        command.add("-u");
        command.add(mysql.getUsername());
        return command;
    }

    private Path requireExecutable(String relativePath, String name) throws IOException
    {
        Path executable = AppPathUtils.resolveExecutable(relativePath);
        if (!Files.isRegularFile(executable))
        {
            throw new IOException(name + " 可执行文件不存在: " + executable);
        }
        return executable;
    }

    private static void setPasswordEnvironment(ProcessBuilder builder, String password)
    {
        if (password != null && !password.isEmpty())
        {
            // Avoid exposing the password in the operating system process command line.
            builder.environment().put("MYSQL_PWD", password);
        }
    }

    private static int waitFor(Process process) throws InterruptedException
    {
        try
        {
            return process.waitFor();
        }
        catch (InterruptedException e)
        {
            process.destroyForcibly();
            Thread.currentThread().interrupt();
            throw e;
        }
    }

    private static String readError(Path errorFile) throws IOException
    {
        String error = Files.readString(errorFile, StandardCharsets.UTF_8).trim();
        return error.isEmpty() ? "命令执行失败，未返回错误信息" : error;
    }

    private static void requireText(String value, String label)
    {
        if (value == null || value.isBlank())
        {
            throw new IllegalArgumentException(label + "不能为空");
        }
    }
}
