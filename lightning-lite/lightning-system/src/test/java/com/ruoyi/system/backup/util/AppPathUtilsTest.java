package com.ruoyi.system.backup.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.nio.file.Path;
import org.junit.jupiter.api.Test;

class AppPathUtilsTest
{
    @Test
    void rejectsPathOutsideApplicationHome()
    {
        assertThrows(IllegalArgumentException.class, () -> AppPathUtils.resolve("../outside"));
    }

    @Test
    void rejectsAbsolutePath()
    {
        String absolutePath = Path.of(System.getProperty("user.dir")).toAbsolutePath().toString();
        assertThrows(IllegalArgumentException.class, () -> AppPathUtils.resolve(absolutePath));
    }

    @Test
    void usesPlatformSpecificExecutableName()
    {
        assertEquals("mysqldump.exe",
                AppPathUtils.resolveExecutable("mysql/bin/mysqldump", true).getFileName().toString());
        assertEquals("mysqldump",
                AppPathUtils.resolveExecutable("mysql/bin/mysqldump", false).getFileName().toString());
    }
}
