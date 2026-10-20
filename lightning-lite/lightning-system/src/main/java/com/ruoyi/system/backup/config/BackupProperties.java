package com.ruoyi.system.backup.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * System backup settings. All configured paths are relative to the application home.
 */
@Component
@ConfigurationProperties(prefix = "system.backup")
public class BackupProperties
{
    private String backupDirectory = "backup";

    private String tempDirectory = "backup/temp";

    private Mysql mysql = new Mysql();

    private Upload upload = new Upload();

    public String getBackupDirectory()
    {
        return backupDirectory;
    }

    public void setBackupDirectory(String backupDirectory)
    {
        this.backupDirectory = backupDirectory;
    }

    public String getTempDirectory()
    {
        return tempDirectory;
    }

    public void setTempDirectory(String tempDirectory)
    {
        this.tempDirectory = tempDirectory;
    }

    public Mysql getMysql()
    {
        return mysql;
    }

    public void setMysql(Mysql mysql)
    {
        this.mysql = mysql;
    }

    public Upload getUpload()
    {
        return upload;
    }

    public void setUpload(Upload upload)
    {
        this.upload = upload;
    }

    public static class Mysql
    {
        private String mysqldump = "mysql/bin/mysqldump";

        private String mysql = "mysql/bin/mysql";

        private String host = "127.0.0.1";

        private int port = 3306;

        private String username = "root";

        private String password;

        private String database = "lightning";

        public String getMysqldump()
        {
            return mysqldump;
        }

        public void setMysqldump(String mysqldump)
        {
            this.mysqldump = mysqldump;
        }

        public String getMysql()
        {
            return mysql;
        }

        public void setMysql(String mysql)
        {
            this.mysql = mysql;
        }

        public String getHost()
        {
            return host;
        }

        public void setHost(String host)
        {
            this.host = host;
        }

        public int getPort()
        {
            return port;
        }

        public void setPort(int port)
        {
            this.port = port;
        }

        public String getUsername()
        {
            return username;
        }

        public void setUsername(String username)
        {
            this.username = username;
        }

        public String getPassword()
        {
            return password;
        }

        public void setPassword(String password)
        {
            this.password = password;
        }

        public String getDatabase()
        {
            return database;
        }

        public void setDatabase(String database)
        {
            this.database = database;
        }
    }

    public static class Upload
    {
        private String directory = "upload";

        public String getDirectory()
        {
            return directory;
        }

        public void setDirectory(String directory)
        {
            this.directory = directory;
        }
    }
}
