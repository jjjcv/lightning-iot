package com.ruoyi.system.backup.model;

import java.time.LocalDateTime;

/**
 * Minimal metadata used to validate a system backup archive.
 */
public class BackupManifest
{
    private String version;

    private LocalDateTime backupTime;

    private String database;

    private boolean mysql;

    private boolean upload;

    public BackupManifest()
    {
    }

    public BackupManifest(String version, LocalDateTime backupTime, String database, boolean mysql, boolean upload)
    {
        this.version = version;
        this.backupTime = backupTime;
        this.database = database;
        this.mysql = mysql;
        this.upload = upload;
    }

    public String getVersion()
    {
        return version;
    }

    public void setVersion(String version)
    {
        this.version = version;
    }

    public LocalDateTime getBackupTime()
    {
        return backupTime;
    }

    public void setBackupTime(LocalDateTime backupTime)
    {
        this.backupTime = backupTime;
    }

    public String getDatabase()
    {
        return database;
    }

    public void setDatabase(String database)
    {
        this.database = database;
    }

    public boolean isMysql()
    {
        return mysql;
    }

    public void setMysql(boolean mysql)
    {
        this.mysql = mysql;
    }

    public boolean isUpload()
    {
        return upload;
    }

    public void setUpload(boolean upload)
    {
        this.upload = upload;
    }
}
