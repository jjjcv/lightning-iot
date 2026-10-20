package com.ruoyi.web.controller.system;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.backup.config.BackupProperties;
import com.ruoyi.system.backup.service.SystemBackupService;
import com.ruoyi.system.backup.service.SystemRestoreService;
import com.ruoyi.system.backup.util.AppPathUtils;

/**
 * Administrator-only system backup and restore endpoints.
 */
@RestController
@RequestMapping("/api/system")
@PreAuthorize("@ss.hasRole('admin')")
public class SystemBackupController
{
    private final SystemBackupService backupService;

    private final SystemRestoreService restoreService;

    private final BackupProperties properties;

    public SystemBackupController(SystemBackupService backupService, SystemRestoreService restoreService,
            BackupProperties properties)
    {
        this.backupService = backupService;
        this.restoreService = restoreService;
        this.properties = properties;
    }

    @Log(title = "系统备份", businessType = BusinessType.EXPORT)
    @PostMapping("/backup")
    public ResponseEntity<Resource> backup() throws Exception
    {
        return downloadResponse(backupService.backup());
    }

    @GetMapping("/backup/files")
    public AjaxResult listBackups() throws IOException
    {
        return AjaxResult.success(backupService.listBackups());
    }

    @Log(title = "下载系统备份", businessType = BusinessType.EXPORT)
    @GetMapping("/backup/files/{fileName}/download")
    public ResponseEntity<Resource> download(@PathVariable String fileName) throws IOException
    {
        return downloadResponse(backupService.getBackupFile(fileName));
    }

    @Log(title = "删除系统备份", businessType = BusinessType.DELETE)
    @DeleteMapping("/backup/files/{fileName}")
    public AjaxResult delete(@PathVariable String fileName) throws IOException
    {
        backupService.deleteBackup(fileName);
        return AjaxResult.success("备份文件已删除");
    }

    @Log(title = "系统恢复", businessType = BusinessType.IMPORT)
    @PostMapping(value = "/restore", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public AjaxResult restore(@RequestPart("file") MultipartFile file) throws Exception
    {
        if (file == null || file.isEmpty())
        {
            throw new IllegalArgumentException("备份文件不能为空");
        }

        Path uploadDirectory = AppPathUtils.resolve(properties.getTempDirectory()).resolve("upload");
        Files.createDirectories(uploadDirectory);
        Path tempFile = uploadDirectory.resolve(UUID.randomUUID() + ".zip");
        try
        {
            try (InputStream input = file.getInputStream())
            {
                Files.copy(input, tempFile, StandardCopyOption.REPLACE_EXISTING);
            }
            restoreService.restore(tempFile);
            return AjaxResult.success("系统恢复成功");
        }
        finally
        {
            Files.deleteIfExists(tempFile);
        }
    }

    private ResponseEntity<Resource> downloadResponse(Path file) throws IOException
    {
        Resource resource = new FileSystemResource(file);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("application/zip"));
        headers.setContentDisposition(ContentDisposition.attachment()
                .filename(file.getFileName().toString(), StandardCharsets.UTF_8)
                .build());
        headers.setContentLength(Files.size(file));
        return ResponseEntity.ok().headers(headers).body(resource);
    }
}
