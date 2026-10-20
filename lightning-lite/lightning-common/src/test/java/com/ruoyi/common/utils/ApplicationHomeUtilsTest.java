package com.ruoyi.common.utils;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class ApplicationHomeUtilsTest
{
    @TempDir
    Path tempDirectory;

    @Test
    void packagedJarUsesParentOfJarDirectory() throws Exception
    {
        Path installationDirectory = Files.createDirectories(tempDirectory.resolve("installation with spaces"));
        Path jarDirectory = Files.createDirectories(installationDirectory.resolve("app"));
        Path jar = Files.createFile(jarDirectory.resolve("lightning-admin.jar"));
        Path workingDirectory = Files.createDirectories(tempDirectory.resolve("unrelated-working-directory"));

        assertEquals(installationDirectory,
                ApplicationHomeUtils.determineApplicationHome(jar, workingDirectory));
    }

    @Test
    void debugLaunchUsesJvmWorkingDirectory() throws Exception
    {
        Path classesDirectory = Files.createDirectories(tempDirectory.resolve("target/classes"));
        Path workingDirectory = Files.createDirectories(tempDirectory.resolve("project"));

        assertEquals(workingDirectory,
                ApplicationHomeUtils.determineApplicationHome(classesDirectory, workingDirectory));
    }
}
