package com.ruoyi.iot.controller;

import java.util.List;

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
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.service.IDeviceHistoryService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * DeviceHistoryController
 * 
 * @author ruoyi
 * @date 2025-03-11
 */
@Tag(name = "设备历史数据管理", description = "提供设备历史数据的查询、导出及维护功能")
@OpenAPIDefinition(info = @Info(title = "设备历史数据 API", version = "v1"))
@RestController
@RequestMapping("/iot/deviceHistory")
public class DeviceHistoryController extends BaseController {
    @Autowired
    private IDeviceHistoryService deviceHistoryService;

    /**
     * 按设备查询时间窗口数据
     */
    @Operation(summary = "按设备查询时间窗口数据", description = "根据设备ID和时间范围查询历史记录")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:list')")
    @GetMapping("/list/Records")
    public AjaxResult getLastRecordsByDevice(
            @Parameter(description = "设备历史数据查询条件（包含设备ID、时间范围等）") DeviceHistory deviceHistory) {
        List<DeviceHistory> list = deviceHistoryService.getLastRecordsByDevice(deviceHistory);
        return success(list);
    }

    /**
     * 统计当前筛选范围内的 InfluxDB series cardinality。
     */
    @Operation(summary = "统计设备历史 series cardinality",
            description = "根据产品、设备、点位和时间范围统计 InfluxDB series 数量")
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:list')")
    @GetMapping("/cardinality")
    public AjaxResult cardinality(DeviceHistory deviceHistory) {
        return success(deviceHistoryService.getSeriesCardinality(deviceHistory));
    }

    /**
     * 查询DeviceHistory列表（全量）
     */
    @Operation(summary = "获取所有设备历史数据", description = "返回所有设备历史记录（无分页）")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
            @Parameter(description = "设备历史数据查询条件（如设备ID、时间范围等）") DeviceHistory deviceHistory) {
        List<DeviceHistory> list = deviceHistoryService.selectDeviceHistoryList(deviceHistory);
        return success(list);
    }

    /**
     * 查询DeviceHistory列表（分页）
     */
    @Operation(summary = "分页查询设备历史数据", description = "根据过滤条件分页查询设备历史记录")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:list')")
    @GetMapping("/list")
    public TableDataInfo list(
            @Parameter(description = "设备历史数据查询条件（如设备ID、时间范围等）") DeviceHistory deviceHistory) {
        startPage();
        List<DeviceHistory> list = deviceHistoryService.selectDeviceHistoryList(deviceHistory);
        return getDataTable(list);
    }

    /**
     * 导出DeviceHistory列表
     */
    @Operation(summary = "导出设备历史数据为 Excel", description = "根据过滤条件导出设备历史记录到 Excel 文件")
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:export')")
    @Log(title = "DeviceHistory", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
            @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
            @Parameter(description = "导出数据的过滤条件") DeviceHistory deviceHistory) {
        List<DeviceHistory> list = deviceHistoryService.selectDeviceHistoryList(deviceHistory);
        ExcelUtil<DeviceHistory> util = new ExcelUtil<DeviceHistory>(DeviceHistory.class);
        util.exportExcel(response, list, "DeviceHistory数据");
    }

    /**
     * 获取DeviceHistory详细信息
     */
    @Operation(summary = "获取设备历史记录详细信息", description = "通过 ID 查询单个设备历史记录的完整信息")
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
            @Parameter(name = "id", description = "设备历史记录唯一标识") @PathVariable("id") Long id) {
        return success(deviceHistoryService.selectDeviceHistoryById(id));
    }

    /**
     * 新增DeviceHistory
     */
    @Operation(summary = "新增设备历史记录", description = "创建新的设备历史记录")
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:add')")
    @Log(title = "DeviceHistory", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
            @Parameter(name = "deviceHistory", description = "需新增的设备历史记录数据") @RequestBody DeviceHistory deviceHistory) {
        return toAjax(deviceHistoryService.insertDeviceHistory(deviceHistory));
    }

    /**
     * 修改DeviceHistory
     */
    @Operation(summary = "更新设备历史记录", description = "根据 ID 更新现有设备历史记录")
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:edit')")
    @Log(title = "DeviceHistory", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
            @Parameter(name = "deviceHistory", description = "需更新的设备历史记录数据") @RequestBody DeviceHistory deviceHistory) {
        return toAjax(deviceHistoryService.updateDeviceHistory(deviceHistory));
    }

    /**
     * 删除DeviceHistory
     */
    @Operation(summary = "删除设备历史记录", description = "根据 ID 数组批量删除设备历史记录")
    @PreAuthorize("@ss.hasPermi('iot:deviceHistory:remove')")
    @Log(title = "DeviceHistory", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
            @Parameter(name = "ids", description = "需删除的设备历史记录 ID 数组") @PathVariable Long[] ids) {
        return toAjax(deviceHistoryService.deleteDeviceHistoryByIds(ids));
    }
}
