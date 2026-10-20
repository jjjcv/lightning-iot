package com.ruoyi.iot.controller;

import java.util.List;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.IEdgeDeviceService;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 设备属性模板Controller
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
@Tag(name = "设备属性模板管理", description = "提供设备属性模板的增删改查、导出及批量操作功能")
@OpenAPIDefinition(info = @Info(title = "设备属性模板 API", version = "v1"))
@RestController
@RequestMapping("/iot/binding")
public class DeviceBindingController extends BaseController {
    @Autowired
    private IDeviceBindingService deviceBindingService;

    @Autowired
    private IEdgeDeviceService edgeDeviceService;

    @Autowired
    private IEdgeDataPointService edgeDataPointService;

    /**
     * 查询设备属性模板列表（分页）
     */
    @Operation(summary = "分页查询设备属性模板列表", description = "根据过滤条件分页查询设备绑定记录")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:binding:list')")
    @GetMapping("/list")
    public TableDataInfo list(
            @Parameter(description = "设备绑定查询条件（如设备名称、网关名称等）") DeviceBinding deviceBinding) {
        startPage();
        List<DeviceBinding> list = deviceBindingService.selectDeviceBindingList(deviceBinding);
        return getDataTable(list);
    }

    /**
     * 查询设备属性模板列表（全量）
     */
    @Operation(summary = "获取所有设备属性模板", description = "返回所有设备绑定记录（无分页）")
    @PreAuthorize("@ss.hasPermi('iot:binding:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
            @Parameter(description = "设备绑定查询条件（如设备名称、网关名称等）") DeviceBinding deviceBinding) {
        List<DeviceBinding> list = deviceBindingService.selectDeviceBindingList(deviceBinding);
        return success(list);
    }

    /**
     * 导出设备属性模板列表
     */
    @Operation(summary = "导出设备属性模板为 Excel", description = "根据过滤条件导出设备绑定记录到 Excel 文件")
    @PreAuthorize("@ss.hasPermi('iot:binding:export')")
    @Log(title = "设备属性模板", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
            @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
            @Parameter(description = "导出数据的设备过滤条件") Device device) {
        List<DeviceBinding> list = deviceBindingService.selectDeviceBindingExportList(device);
        ExcelUtil<DeviceBinding> util = new ExcelUtil<DeviceBinding>(DeviceBinding.class);
        util.exportExcel(response, list, "设备属性模板数据");
    }

    /**
     * 导入设备属性模板列表
     */
    @Operation(summary = "导入设备属性模板列表", description = "从 Excel 文件导入设备绑定数据，支持更新已有绑定")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "导入成功"),
            @ApiResponse(responseCode = "400", description = "文件格式错误或数据冲突")
    })
    @PreAuthorize("@ss.hasPermi('iot:binding:add')")
    @Log(title = "设备属性模板", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(
            @Parameter(name = "file", description = "包含设备绑定信息的 Excel 文件", required = true) MultipartFile file,
            @Parameter(name = "updateSupport", description = "是否允许更新已有设备绑定") boolean updateSupport)
            throws Exception {
        ExcelUtil<DeviceBinding> util = new ExcelUtil<DeviceBinding>(DeviceBinding.class);
        List<DeviceBinding> bindingList = util.importExcel(file.getInputStream());
        String message = deviceBindingService.importDeviceBinding(bindingList, updateSupport, getUsername());
        return success(message);
    }

    /**
     * 下载设备属性模板导入模板
     */
    @Operation(summary = "下载设备属性模板导入模板", description = "下载设备绑定数据 Excel 导入模板")
    @PostMapping("/importTemplate")
    public void importTemplate(
            @Parameter(description = "HTTP 响应对象") HttpServletResponse response) {
        ExcelUtil<DeviceBinding> util = new ExcelUtil<DeviceBinding>(DeviceBinding.class);
        util.importTemplateExcel(response, "设备属性模板数据");
    }

    /**
     * 获取设备属性模板详细信息
     */
    @Operation(summary = "获取设备绑定详细信息", description = "通过 ID 查询单个设备绑定的完整信息")
    @PreAuthorize("@ss.hasPermi('iot:binding:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
            @Parameter(name = "id", description = "设备绑定唯一标识") @PathVariable("id") String id) {
        return success(deviceBindingService.selectDeviceBindingById(id));
    }

    /**
     * 新增设备属性模板
     */
    @Operation(summary = "新增设备绑定", description = "创建新的设备绑定记录（自动补全关联网关信息）")
    @PreAuthorize("@ss.hasPermi('iot:binding:add')")
    @Log(title = "设备属性模板", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
            @Parameter(name = "deviceBinding", description = "需新增的设备绑定数据") @RequestBody DeviceBinding deviceBinding) {

        if (StringUtils.isNotEmpty(deviceBinding.getEdgePointId())) {
            EdgeDataPoint edgeDataPoint = edgeDataPointService.selectEdgeDataPointById(deviceBinding.getEdgePointId());
            deviceBinding.setEdgePointName(edgeDataPoint.getName());
            EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(edgeDataPoint.getGatewayId());
            deviceBinding.setGatewayName(edgeDevice.getName());
        }

        int i = deviceBindingService.insertDeviceBinding(deviceBinding);
        return toAjax(i);
    }

    /**
     * 修改设备属性模板
     */
    @Operation(summary = "更新设备绑定", description = "根据 ID 更新现有设备绑定记录（自动补全关联网关信息）")
    @PreAuthorize("@ss.hasPermi('iot:binding:edit')")
    @Log(title = "设备属性模板", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
            @Parameter(name = "deviceBinding", description = "需更新的设备绑定数据") @RequestBody DeviceBinding deviceBinding) {
        if (StringUtils.isNotEmpty(deviceBinding.getEdgePointId())) {
            EdgeDataPoint edgeDataPoint = edgeDataPointService.selectEdgeDataPointById(deviceBinding.getEdgePointId());
            deviceBinding.setEdgePointName(edgeDataPoint.getName());
            EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(edgeDataPoint.getGatewayId());
            deviceBinding.setGatewayName(edgeDevice.getName());
        }
        return toAjax(deviceBindingService.updateDeviceBinding(deviceBinding));
    }

    /**
     * 删除设备属性模板
     */
    @Operation(summary = "删除设备绑定", description = "根据 ID 数组批量删除设备绑定记录")
    @PreAuthorize("@ss.hasPermi('iot:binding:remove')")
    @Log(title = "设备属性模板", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
            @Parameter(name = "ids", description = "需删除的设备绑定 ID 数组") @PathVariable String[] ids) {
        return toAjax(deviceBindingService.deleteDeviceBindingByIds(ids));
    }
}
