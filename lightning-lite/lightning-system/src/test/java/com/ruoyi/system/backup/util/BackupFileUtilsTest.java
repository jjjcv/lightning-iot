package com.ruoyi.system.backup.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class BackupFileUtilsTest
{
    @TempDir
    Path tempDirectory;

    @Test
    void safelyReplacesDirectoryAndRemovesOldCopy() throws Exception
    {
        Path source = tempDirectory.resolve("source");
        Path target = tempDirectory.resolve("upload");
        Files.createDirectories(source.resolve("images"));
        Files.writeString(source.resolve("images/new.txt"), "new");
        Files.createDirectories(target);
        Files.writeString(target.resolve("old.txt"), "old");

        BackupFileUtils.safeReplaceDirectory(source, target);

        assertEquals("new", Files.readString(target.resolve("images/new.txt")));
        assertFalse(Files.exists(target.resolve("old.txt")));
        assertFalse(Files.exists(tempDirectory.resolve("upload.old")));
    }
}
