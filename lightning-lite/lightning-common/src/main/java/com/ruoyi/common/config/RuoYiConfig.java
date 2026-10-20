package com.ruoyi.common.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Path;
import java.util.Map;


/**
 * 读取项目相关配置
 * 
 * @author ruoyi
 */
@Component
@ConfigurationProperties(prefix = "ruoyi")
public class RuoYiConfig
{
    /** 项目名称 */
    private String name;

    /** 版本 */
    private String version;

    /** 版权年份 */
    private String copyrightYear;

    /** 上传路径 */
    private static String profile;

    /** 获取地址开关 */
    private static boolean addressEnabled;

    /** 验证码类型 */
    private static String captchaType;

    /**
     * 虚拟路径map
     */
    private Map<String, String> xnljmap;

    /**
     * 存储路径
     */
    private String fileUrl;

    /**
     * 默认文件格式
     */
    private String defaultFormat;

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public Map<String, String> getXnljmap() {
        return xnljmap;
    }

    public void setXnljmap(Map<String, String> xnljmap) {
        this.xnljmap = xnljmap;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getVersion()
    {
        return version;
    }

    public void setVersion(String version)
    {
        this.version = version;
    }

    public String getCopyrightYear()
    {
        return copyrightYear;
    }

    public void setCopyrightYear(String copyrightYear)
    {
        this.copyrightYear = copyrightYear;
    }

    public static String getProfile()
    {
        return profile;
    }

    public void setProfile(String profile)
    {
        RuoYiConfig.profile = Path.of(profile).toAbsolutePath().normalize().toString();
    }

    public static boolean isAddressEnabled()
    {
        return addressEnabled;
    }

    public void setAddressEnabled(boolean addressEnabled)
    {
        RuoYiConfig.addressEnabled = addressEnabled;
    }

    public static String getCaptchaType() {
        return captchaType;
    }

    public void setCaptchaType(String captchaType) {
        RuoYiConfig.captchaType = captchaType;
    }

    public String getDefaultFormat() {
        return defaultFormat;
    }

    public void setDefaultFormat(String defaultFormat) {
        this.defaultFormat = defaultFormat;
    }

    /**
     * 获取导入上传路径
     */
    public static String getImportPath()
    {
        return resolveProfilePath("import");
    }

    /**
     * 获取头像上传路径
     */
    public static String getAvatarPath()
    {
        return resolveProfilePath("avatar");
    }

    /**
     * 获取下载路径
     */
    public static String getDownloadPath()
    {
        return resolveProfilePath("download") + File.separator;
    }

    /**
     * 获取上传路径
     */
    public static String getUploadPath()
    {
        return resolveProfilePath("upload");
    }


    private static String resolveProfilePath(String child)
    {
        return Path.of(getProfile()).resolve(child).normalize().toString();
    }

}
