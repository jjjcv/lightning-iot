package com.ruoyi.system.backup.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 * ZIP archive operations with Zip Slip protection.
 */
public final class ZipUtils
{
    private ZipUtils()
    {
    }

    public static void zip(Path source, Path output) throws IOException
    {
        if (!Files.isDirectory(source))
        {
            throw new IOException("待压缩目录不存在: " + source);
        }
        Files.createDirectories(output.getParent());

        try (ZipOutputStream zip = new ZipOutputStream(new BufferedOutputStream(Files.newOutputStream(output)));
                Stream<Path> paths = Files.walk(source))
        {
            for (Path path : paths.filter(item -> !item.equals(source)).toList())
            {
                if (Files.isSymbolicLink(path))
                {
                    throw new IOException("备份内容不允许包含符号链接: " + path);
                }

                String entryName = source.relativize(path).toString().replace('\\', '/');
                if (Files.isDirectory(path))
                {
                    zip.putNextEntry(new ZipEntry(entryName + "/"));
                }
                else if (Files.isRegularFile(path))
                {
                    zip.putNextEntry(new ZipEntry(entryName));
                    Files.copy(path, zip);
                }
                else
                {
                    throw new IOException("不支持的备份文件类型: " + path);
                }
                zip.closeEntry();
            }
        }
    }

    public static void unzip(Path zipFile, Path target) throws IOException
    {
        Path normalizedTarget = target.toAbsolutePath().normalize();
        Files.createDirectories(normalizedTarget);

        try (ZipInputStream zip = new ZipInputStream(
                new BufferedInputStream(Files.newInputStream(zipFile))))
        {
            ZipEntry entry;
            while ((entry = zip.getNextEntry()) != null)
            {
                Path output = normalizedTarget.resolve(entry.getName()).normalize();
                if (!output.startsWith(normalizedTarget))
                {
                    throw new IOException("非法 ZIP 路径: " + entry.getName());
                }

                if (entry.isDirectory())
                {
                    Files.createDirectories(output);
                }
                else
                {
                    Path parent = output.getParent();
                    if (parent == null)
                    {
                        throw new IOException("非法 ZIP 文件项: " + entry.getName());
                    }
                    Files.createDirectories(parent);
                    Files.copy(zip, output, StandardCopyOption.REPLACE_EXISTING);
                }
                zip.closeEntry();
            }
        }
    }
}
