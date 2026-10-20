package com.ruoyi.iot.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.service.impl.TagBindingService;
import org.springframework.beans.BeanUtils;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.domain.DeviceStatistics;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.iot.service.IDevicesService;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 设备Controller
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@Tag(name = "设备管理", description = "提供设备的增删改查、导出及属性下置功能")
@OpenAPIDefinition(info = @Info(title = "设备 API", version = "v1"))
@RestController
@RequestMapping("/iot/devices")
public class DevicesController extends BaseController {
    @Autowired
    private IDevicesService devicesService;

    @Autowired
    private TagBindingService tagBindingService;

    @Autowired
    private IDeviceBindingService deviceBindingService;

    @Autowired
    private EdgeAdapterManager edgeAdapterManager;


    @PreAuthorize("@ss.hasPermi('iot:devices:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
            @Parameter(description = "设备查询条件（如设备名称、状态等）") Device device) {
        List<Device> list = devicesService.selectDevicesList(device);
        tagBindingService.fillTags("device", list);
        return success(list);
    }

    /**
     * 查询设备列表（分页）
     */
    @Operation(summary = "分页查询设备列表", description = "根据过滤条件分页查询设备信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "设备查询条件（如设备名称、状态等）") Device device) {
        startPage();
        List<Device> list = devicesService.selectDevicesList(device);
        tagBindingService.fillTags("device", list);
        return getDataTable(list);
    }

    /**
     * 设备统计
     */
    @Operation(summary = "设备统计", description = "统计设备总数、在线、离线、启用、停用数量")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回设备统计数据")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:list')")
    @GetMapping("/statistics")
    public AjaxResult statistics() {
        return success(devicesService.selectDeviceStatistics());
    }

    /**
     * 导出设备列表
     */
    @Operation(summary = "导出设备列表为 Excel", description = "根据过滤条件导出设备信息到 Excel 文件")
    @PreAuthorize("@ss.hasPermi('iot:devices:export')")
    @Log(title = "设备", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") Device device) {
        List<Device> list = devicesService.selectDevicesList(device);
        tagBindingService.fillTags("device", list);
        ExcelUtil<Device> util = new ExcelUtil<Device>(Device.class);
        util.exportExcel(response, list, "设备数据");
    }

    /**
     * 设备属性下置
     */
    @Operation(summary = "设备属性下置", description = "将指定设备属性值写入边缘网关")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "属性写入成功"),
        @ApiResponse(responseCode = "500", description = "属性写入失败")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:edit')")
    @Log(title = "设备", businessType = BusinessType.UPDATE)
    @PostMapping("/write")
    public AjaxResult write(
        @Parameter(name = "deviceBinding", description = "需下置的设备属性绑定信息") @RequestBody DeviceBinding deviceBinding) {
        DataWriteResult dataWriteResult = devicesService.write(deviceBinding.getProductId(), deviceBinding.getDeviceId(), deviceBinding.getTelemetryKey(), deviceBinding.getValue());
        Boolean result = dataWriteResult.getResult();
        if (result){
            return success(dataWriteResult);
        } else {
            return error(dataWriteResult.getMessage());
        }

    }

    /**
     * 获取设备详细信息
     */
    @Operation(summary = "获取设备详细信息", description = "通过 ID 查询单个设备的完整信息")
    @PreAuthorize("@ss.hasPermi('iot:devices:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "设备唯一标识") @PathVariable("id") String id) {
        Device source = devicesService.selectDevicesById(id);
        if (source == null || source.getId() == null) { return success(source); }
        Device result = new Device();
        BeanUtils.copyProperties(source, result);
        tagBindingService.fillTags("device", List.of(result));
        return success(result);
    }

    /**
     * 新增设备
     */
    @Operation(summary = "新增设备", description = "创建新的设备记录（自动生成唯一ID）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:add')")
    @Log(title = "设备", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "device", description = "需新增的设备数据") @RequestBody Device device) {
        if (StringUtils.isEmpty(device.getId())) {
            device.setId(IdUtils.fastSimpleUUID());
        }
        return toAjax(devicesService.insertDevices(device));
    }

    /**
     * 修改设备
     */
    @Operation(summary = "更新设备信息", description = "根据 ID 更新现有设备记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:edit')")
    @Log(title = "设备", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "device", description = "需更新的设备数据") @RequestBody Device device) {
        return toAjax(devicesService.updateDevices(device));
    }

    /**
     * 删除设备
     */
    @Operation(summary = "删除设备", description = "根据 ID 数组批量删除设备记录并清理关联绑定")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:remove')")
    @Log(title = "设备", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的设备 ID 数组") @PathVariable String[] ids) {
        return toAjax(devicesService.deleteDevicesByIds(ids));
    }

    /**
     * 导入设备列表
     */
    @Operation(summary = "导入设备列表", description = "从 Excel 文件导入设备数据，支持根据 ID 更新已有设备")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "导入成功"),
        @ApiResponse(responseCode = "400", description = "文件格式错误或数据冲突")
    })
    @PreAuthorize("@ss.hasPermi('iot:devices:add')")
    @Log(title = "设备", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(
        @Parameter(name = "file", description = "包含设备信息的 Excel 文件", required = true) MultipartFile file,
        @Parameter(name = "updateSupport", description = "是否允许更新现有设备") boolean updateSupport) throws Exception {
        ExcelUtil<Device> util = new ExcelUtil<Device>(Device.class);
        List<Device> deviceList = util.importExcel(file.getInputStream());
        String message = devicesService.importDevices(deviceList, updateSupport, getUsername());
        return success(message);
    }

    /**
     * 下载设备导入模板
     */
    @Operation(summary = "下载设备导入模板", description = "下载设备数据 Excel 导入模板")
    @PostMapping("/importTemplate")
    public void importTemplate(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response) {
        ExcelUtil<Device> util = new ExcelUtil<Device>(Device.class);
        util.importTemplateExcel(response, "设备数据");
    }
}
