package com.ruoyi.iot.controller;

import java.util.List;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.iot.service.IDeviceBindingService;
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
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.domain.EdgeDeviceStatistics;
import com.ruoyi.iot.service.IEdgeDeviceService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

// Swagger V3 注解引入
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

/**
 * 设备接入网关Controller
 *
 * @author ruoyi
 * @date 2025-02-14
 */
@Tag(name = "设备接入网关管理", description = "提供设备接入网关的启停、增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "设备接入网关 API", version = "v1"))
@RestController
@RequestMapping("/iot/edgeDevice")
public class EdgeDeviceController extends BaseController {
    @Autowired
    private IEdgeDeviceService edgeDeviceService;

    @Autowired
    private IDeviceBindingService deviceBindingService;

    /**
     * 启用设备接入网关
     */
    @Operation(summary = "启用设备接入网关", description = "启用指定ID的设备接入网关")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备启用成功"),
        @ApiResponse(responseCode = "400", description = "设备ID无效或已启用")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:edit')")
    @PutMapping(value = "/enable/{id}")
    public AjaxResult enableEdgeDevice(
        @Parameter(name = "id", description = "需启用的设备接入网关唯一标识") @PathVariable("id") String id) {
        edgeDeviceService.enableEdgeDevice(id);
        return success();
    }

    /**
     * 禁用设备接入网关
     */
    @Operation(summary = "禁用设备接入网关", description = "禁用指定ID的设备接入网关")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备禁用成功"),
        @ApiResponse(responseCode = "400", description = "设备ID无效或已禁用")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:edit')")
    @PutMapping(value = "/disable/{id}")
    public AjaxResult disableEdgeDevice(
        @Parameter(name = "id", description = "需禁用的设备接入网关唯一标识") @PathVariable("id") String id) {
        edgeDeviceService.disableEdgeDevice(id);
        return success();
    }

    /**
     * 查询设备接入网关列表（分页）
     */
    @Operation(summary = "分页查询设备接入网关列表", description = "根据过滤条件分页查询设备接入网关信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "设备接入网关查询条件（如名称、状态等）") EdgeDevice edgeDevice) {
        startPage();
        List<EdgeDevice> list = edgeDeviceService.selectEdgeDeviceList(edgeDevice);
        return getDataTable(list);
    }

    /**
     * 设备接入网关统计
     */
    @Operation(summary = "设备接入网关统计", description = "统计设备接入网关总数、在线、离线、启用、停用数量")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回设备接入网关统计数据")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:list')")
    @GetMapping("/statistics")
    public AjaxResult statistics() {
        return success(edgeDeviceService.selectEdgeDeviceStatistics());
    }

    /**
     * 查询设备接入网关列表（全量）
     */
    @Operation(summary = "获取所有设备接入网关", description = "返回所有设备接入网关记录（无分页）")
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
        @Parameter(description = "设备接入网关查询条件（如名称、状态等）") EdgeDevice edgeDevice) {
        List<EdgeDevice> list = edgeDeviceService.selectEdgeDeviceList(edgeDevice);
        return success(list);
    }

    /**
     * 导出设备接入网关列表
     */
    @Operation(summary = "导出设备接入网关列表为 Excel", description = "根据过滤条件导出设备接入网关信息到 Excel 文件")
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:export')")
    @Log(title = "设备接入网关", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") EdgeDevice edgeDevice) {
        List<EdgeDevice> list = edgeDeviceService.selectEdgeDeviceList(edgeDevice);
        ExcelUtil<EdgeDevice> util = new ExcelUtil<EdgeDevice>(EdgeDevice.class);
        util.exportExcel(response, list, "设备接入网关数据");
    }

    /**
     * 获取设备接入网关详细信息
     */
    @Operation(summary = "获取设备接入网关详细信息", description = "通过 ID 查询单个设备接入网关的完整信息")
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "设备接入网关唯一标识") @PathVariable("id") String id) {
        return success(edgeDeviceService.selectEdgeDeviceById(id));
    }

    /**
     * 新增设备接入网关
     */
    @Operation(summary = "新增设备接入网关", description = "创建新的设备接入网关记录（自动生成唯一ID和默认状态）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备接入网关创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:add')")
    @Log(title = "设备接入网关", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "edgeDevice", description = "需新增的设备接入网关数据") @RequestBody EdgeDevice edgeDevice) {
        if (StringUtils.isEmpty(edgeDevice.getId())) {
            edgeDevice.setId(IdUtils.fastSimpleUUID());
        }
        edgeDevice.setStatus("disable");
        if (StringUtils.isEmpty(edgeDevice.getLinkStatus())) {
            edgeDevice.setLinkStatus("offline");
        }
        return toAjax(edgeDeviceService.insertEdgeDevice(edgeDevice));
    }

    /**
     * 修改设备接入网关
     */
    @Operation(summary = "更新设备接入网关信息", description = "根据 ID 更新现有设备接入网关记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备接入网关更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:edit')")
    @Log(title = "设备接入网关", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "edgeDevice", description = "需更新的设备接入网关数据") @RequestBody EdgeDevice edgeDevice) {
        if (StringUtils.isNotEmpty(edgeDevice.getName())){
            deviceBindingService.updateEdgePointNameByEdgePointId(edgeDevice.getName(), edgeDevice.getId());
        }
        return toAjax(edgeDeviceService.updateEdgeDevice(edgeDevice));
    }

    /**
     * 删除设备接入网关
     */
    @Operation(summary = "删除设备接入网关", description = "根据 ID 数组批量删除设备接入网关记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "设备接入网关删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDevice:remove')")
    @Log(title = "设备接入网关", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的设备接入网关 ID 数组") @PathVariable String[] ids) {
        return toAjax(edgeDeviceService.deleteEdgeDeviceByIds(ids));
    }
}
