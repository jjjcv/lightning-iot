package com.ruoyi.system.backup.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class ZipUtilsTest
{
    @TempDir
    Path tempDirectory;

    @Test
    void roundTripRetainsFilesAndEmptyDirectories() throws Exception
    {
        Path source = tempDirectory.resolve("source");
        Files.createDirectories(source.resolve("mysql"));
        Files.createDirectories(source.resolve("upload/empty"));
        Files.writeString(source.resolve("mysql/database.sql"), "select 1;");
        Files.writeString(source.resolve("manifest.json"), "{}");

        Path archive = tempDirectory.resolve("backup.zip");
        Path restored = tempDirectory.resolve("restored");
        ZipUtils.zip(source, archive);
        ZipUtils.unzip(archive, restored);

        assertEquals("select 1;", Files.readString(restored.resolve("mysql/database.sql")));
        assertTrue(Files.isDirectory(restored.resolve("upload/empty")));
        assertTrue(Files.isRegularFile(restored.resolve("manifest.json")));
    }

    @Test
    void rejectsZipSlipEntry() throws Exception
    {
        Path archive = tempDirectory.resolve("malicious.zip");
        try (ZipOutputStream zip = new ZipOutputStream(Files.newOutputStream(archive)))
        {
            zip.putNextEntry(new ZipEntry("../escaped.txt"));
            zip.write("bad".getBytes());
            zip.closeEntry();
        }

        Path target = tempDirectory.resolve("target");
        assertThrows(IOException.class, () -> ZipUtils.unzip(archive, target));
    }
}
