package com.ruoyi.common.utils;

import java.io.File;
import java.nio.file.Path;
import org.springframework.boot.system.ApplicationHome;

/**
 * Resolves the platform installation directory consistently for packaged and
 * development launches.
 */
public final class ApplicationHomeUtils
{
    public static final String APP_HOME_PROPERTY = "app.home";

    private ApplicationHomeUtils()
    {
    }

    /**
     * Initializes {@code app.home} before Spring reads application.yml.
     * <ul>
     * <li>Packaged Jar: the parent of the directory containing the current Jar.</li>
     * <li>IDE/debug: the JVM working directory ({@code user.dir}).</li>
     * <li>Explicit deployment override: {@code -Dapp.home=/path/to/app}.</li>
     * </ul>
     */
    public static Path initialize(Class<?> sourceClass)
    {
        String configuredHome = System.getProperty(APP_HOME_PROPERTY);
        Path applicationHome;
        if (configuredHome != null && !configuredHome.isBlank())
        {
            applicationHome = normalize(configuredHome);
        }
        else
        {
            Path workingDirectory = normalize(System.getProperty("user.dir"));
            File source = new ApplicationHome(sourceClass).getSource();
            Path sourceLocation = source == null ? null : source.toPath();
            applicationHome = determineApplicationHome(sourceLocation, workingDirectory);
        }
        System.setProperty(APP_HOME_PROPERTY, applicationHome.toString());
        return applicationHome;
    }

    /**
     * Returns the initialized installation directory, falling back to
     * {@code user.dir} for tests or tools that do not start through main().
     */
    public static Path getApplicationHome()
    {
        String applicationHome = System.getProperty(APP_HOME_PROPERTY);
        if (applicationHome == null || applicationHome.isBlank())
        {
            applicationHome = System.getProperty("user.dir");
        }
        return normalize(applicationHome);
    }

    static Path determineApplicationHome(Path sourceLocation, Path workingDirectory)
    {
        Path normalizedWorkingDirectory = workingDirectory.toAbsolutePath().normalize();
        if (sourceLocation == null)
        {
            return normalizedWorkingDirectory;
        }

        Path normalizedSource = sourceLocation.toAbsolutePath().normalize();
        String fileName = normalizedSource.getFileName() == null
                ? ""
                : normalizedSource.getFileName().toString().toLowerCase();
        if (fileName.endsWith(".jar") && normalizedSource.getParent() != null)
        {
            Path jarDirectory = normalizedSource.getParent();
            return jarDirectory.getParent() == null ? jarDirectory : jarDirectory.getParent();
        }
        return normalizedWorkingDirectory;
    }

    private static Path normalize(String path)
    {
        if (path == null || path.isBlank())
        {
            throw new IllegalStateException("应用安装目录不能为空");
        }
        return Path.of(path).toAbsolutePath().normalize();
    }
}
