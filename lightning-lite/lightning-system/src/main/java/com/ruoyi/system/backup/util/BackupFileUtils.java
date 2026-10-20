package com.ruoyi.system.backup.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Stream;

/**
 * File operations used by backup and restore.
 */
public final class BackupFileUtils
{
    private BackupFileUtils()
    {
    }

    public static void copyDirectory(Path source, Path target) throws IOException
    {
        if (!Files.isDirectory(source))
        {
            throw new IOException("源目录不存在: " + source);
        }

        try (Stream<Path> stream = Files.walk(source))
        {
            for (Path path : stream.toList())
            {
                if (Files.isSymbolicLink(path))
                {
                    throw new IOException("备份目录不允许包含符号链接: " + path);
                }

                Path destination = target.resolve(source.relativize(path));
                if (Files.isDirectory(path))
                {
                    Files.createDirectories(destination);
                }
                else
                {
                    Files.createDirectories(destination.getParent());
                    Files.copy(path, destination, StandardCopyOption.REPLACE_EXISTING,
                            StandardCopyOption.COPY_ATTRIBUTES);
                }
            }
        }
    }

    public static void deleteDirectory(Path directory) throws IOException
    {
        if (!Files.exists(directory))
        {
            return;
        }

        try (Stream<Path> stream = Files.walk(directory))
        {
            List<Path> paths = stream.sorted(Comparator.reverseOrder()).toList();
            for (Path path : paths)
            {
                Files.deleteIfExists(path);
            }
        }
    }

    /**
     * Replaces a directory while retaining the old directory until the copy completes.
     */
    public static void safeReplaceDirectory(Path source, Path target) throws IOException
    {
        if (!Files.isDirectory(source))
        {
            throw new IOException("恢复目录不存在: " + source);
        }

        Path old = target.resolveSibling(target.getFileName() + ".old");
        deleteDirectory(old);

        boolean movedOld = false;
        if (Files.exists(target))
        {
            Files.move(target, old, StandardCopyOption.REPLACE_EXISTING);
            movedOld = true;
        }

        try
        {
            copyDirectory(source, target);
            deleteDirectory(old);
        }
        catch (IOException | RuntimeException e)
        {
            try
            {
                deleteDirectory(target);
                if (movedOld && Files.exists(old))
                {
                    Files.move(old, target, StandardCopyOption.REPLACE_EXISTING);
                }
            }
            catch (Exception rollbackFailure)
            {
                e.addSuppressed(rollbackFailure);
            }
            throw e;
        }
    }
}
