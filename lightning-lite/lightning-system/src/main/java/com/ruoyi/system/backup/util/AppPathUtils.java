package com.ruoyi.system.backup.util;

import java.nio.file.Path;
import java.io.File;
import com.ruoyi.common.utils.ApplicationHomeUtils;

/**
 * Resolves paths relative to the platform installation directory.
 */
public final class AppPathUtils
{
    private AppPathUtils()
    {
    }

    public static Path getApplicationHome()
    {
        return ApplicationHomeUtils.getApplicationHome();
    }

    public static Path resolve(String relativePath)
    {
        if (relativePath == null || relativePath.isBlank())
        {
            throw new IllegalArgumentException("相对路径不能为空");
        }

        Path relative = Path.of(relativePath);
        if (relative.isAbsolute())
        {
            throw new IllegalArgumentException("仅支持相对于软件安装目录的路径: " + relativePath);
        }

        Path applicationHome = getApplicationHome();
        Path resolved = applicationHome.resolve(relative).normalize();
        if (!resolved.startsWith(applicationHome))
        {
            throw new IllegalArgumentException("非法路径: " + relativePath);
        }
        return resolved;
    }

    public static Path resolveExecutable(String relativePath)
    {
        return resolveExecutable(relativePath, File.separatorChar == '\\');
    }

    static Path resolveExecutable(String relativePath, boolean windows)
    {
        Path executable = resolve(relativePath);
        if (!windows)
        {
            return executable;
        }

        String fileName = executable.getFileName().toString().toLowerCase();
        if (fileName.endsWith(".exe") || fileName.endsWith(".cmd")
                || fileName.endsWith(".bat") || fileName.endsWith(".com"))
        {
            return executable;
        }
        return executable.resolveSibling(executable.getFileName() + ".exe");
    }
}
