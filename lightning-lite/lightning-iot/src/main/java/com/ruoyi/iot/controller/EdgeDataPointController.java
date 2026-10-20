package com.ruoyi.iot.controller;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDataPointStatistics;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.iot.service.IEdgeDataPointService;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Objects;


/**
 * 网关数据点位Controller
 *
 * @author ruoyi
 * @date 2025-02-14
 */
@Tag(name = "网关数据点位管理", description = "提供网关数据点位的增删改查、导入导出及实时值操作功能")
@OpenAPIDefinition(info = @Info(title = "网关数据点位 API", version = "v1"))
@RestController
@RequestMapping("/iot/edgeDataPoint")
public class EdgeDataPointController extends BaseController {
    @Autowired
    private IEdgeDataPointService edgeDataPointService;

    @Autowired
    private EdgeAdapterManager edgeAdapterManager;

    @Autowired
    private IDeviceBindingService deviceBindingService;

    /**
     * 查询网关数据点位列表（分页）
     */
    @Operation(summary = "分页查询网关数据点位列表", description = "根据过滤条件分页查询数据点位信息，并返回实时值")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "数据点位查询条件（如网关ID、名称等）") EdgeDataPoint edgeDataPoint) {
        startPage();
        List<EdgeDataPoint> list = edgeDataPointService.selectEdgeDataPointList(edgeDataPoint);

        for (EdgeDataPoint point : list) {
            DataPoint dataPoint = edgeAdapterManager.getDataPointValue(point.getGatewayId(), point.getId());
            if (dataPoint == null || dataPoint.getValue() == null) {
                if (edgeDataPointService.getEdgeDataPoint(point.getId()) != null) {
                    EdgeDataPoint redisDataPoint = edgeDataPointService.getEdgeDataPoint(point.getId());
                    point.setValue(redisDataPoint.getValue());
                    point.setLastTime(redisDataPoint.getLastTime());
                }
                continue;
            }
            point.setValue(String.valueOf(dataPoint.getValue()));
            point.setLastTime(dataPoint.getLastTime());
        }

        return getDataTable(list);
    }

    /**
     * 网关数据点位统计
     */
    @Operation(summary = "网关数据点位统计", description = "统计数据点位总数，以及按所属网关连接状态统计的在线、离线数量")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回网关数据点位统计数据")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:list')")
    @GetMapping("/statistics")
    public AjaxResult statistics() {
        return success(edgeDataPointService.selectEdgeDataPointStatistics());
    }

    /**
     * 查询网关数据点位列表（全量）
     */
    @Operation(summary = "获取所有网关数据点位", description = "返回所有数据点位记录（无分页）")
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
        @Parameter(description = "数据点位查询条件（如网关ID、名称等）") EdgeDataPoint edgeDataPoint) {
        List<EdgeDataPoint> list = edgeDataPointService.selectEdgeDataPointList(edgeDataPoint);
        return success(list);
    }

    /**
     * 写入网关数据点位值
     */
    @Operation(summary = "写入网关数据点位值", description = "向指定网关数据点位写入新值")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "属性写入成功"),
        @ApiResponse(responseCode = "500", description = "属性写入失败")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:edit')")
    @Log(title = "网关数据点位", businessType = BusinessType.UPDATE)
    @PutMapping("/write")
    public AjaxResult writeDataPoint(
        @Parameter(name = "edgeDataPoint", description = "包含网关ID、数据点位ID及目标值的对象") @RequestBody EdgeDataPoint edgeDataPoint) {
        DataWriteResult dataWriteResult = edgeAdapterManager.writeDataPoint(edgeDataPoint.getGatewayId(), edgeDataPoint.getId(), edgeDataPoint.getValue());
        return AjaxResult.success(dataWriteResult);
    }

    /**
     * 导出网关数据点位列表
     */
    @Operation(summary = "导出网关数据点位列表为 Excel", description = "根据过滤条件导出数据点位信息到 Excel 文件")
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:export')")
    @Log(title = "网关数据点位", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") EdgeDataPoint edgeDataPoint) throws IOException {
        edgeDataPointService.export(response, edgeDataPoint);
    }

    /**
     * 导入网关数据点位列表
     */
    @Operation(summary = "导入网关数据点位列表", description = "从 Excel 文件导入数据点位数据（支持更新）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "导入成功"),
        @ApiResponse(responseCode = "400", description = "文件格式错误或数据冲突")
    })
    @Log(title = "网关数据点位", businessType = BusinessType.INSERT)
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:add')")
    @PostMapping("/importData")
    public AjaxResult importData(
        @Parameter(name = "file", description = "包含数据点位信息的 Excel 文件", required = true, content = @Content(mediaType = "multipart/form-data")) MultipartFile file,
        @Parameter(name = "gatewayId", description = "网关id") String gatewayId,
        @Parameter(name = "updateSupport", description = "是否允许更新现有数据") boolean updateSupport) throws Exception {

        List<EdgeDataPoint> edgeDataPointList = edgeDataPointService.readEdgeDataPointExcel(file, gatewayId);
        String operName = getUsername();
        String message = edgeDataPointService.importEdgeDataPoint(edgeDataPointList, gatewayId, updateSupport, operName);
        return success(message);
    }

    /**
     * 获取网关数据点位详细信息
     */
    @Operation(summary = "获取数据点位详细信息", description = "通过 ID 查询单个数据点位的完整信息")
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "数据点位唯一标识") @PathVariable("id") String id) {
        return success(edgeDataPointService.selectEdgeDataPointById(id));
    }

    /**
     * 新增网关数据点位
     */
    @Operation(summary = "新增数据点位", description = "创建新的网关数据点位记录（自动生成唯一ID）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "数据点位创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:add')")
    @Log(title = "网关数据点位", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "edgeDataPoint", description = "需新增的数据点位数据") @RequestBody EdgeDataPoint edgeDataPoint) {
        if (StringUtils.isEmpty(edgeDataPoint.getId())) {
            edgeDataPoint.setId(IdUtil.getSnowflakeNextIdStr());
        }
        return toAjax(edgeDataPointService.insertEdgeDataPoint(edgeDataPoint));
    }

    /**
     * 修改网关数据点位
     */
    @Operation(summary = "更新数据点位信息", description = "根据 ID 更新现有数据点位记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "数据点位更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:edit')")
    @Log(title = "网关数据点位", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "edgeDataPoint", description = "需更新的数据点位数据") @RequestBody EdgeDataPoint edgeDataPoint) {
        int rows = edgeDataPointService.updateEdgeDataPoint(edgeDataPoint);
        if (StringUtils.isNotEmpty(edgeDataPoint.getName())) {
            deviceBindingService.updateEdgePointNameByEdgePointId(edgeDataPoint.getName(), edgeDataPoint.getId());
        }
        return toAjax(rows);
    }

    /**
     * 删除网关数据点位
     */
    @Operation(summary = "删除数据点位", description = "根据 ID 数组批量删除数据点位记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "数据点位删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:edgeDataPoint:remove')")
    @Log(title = "网关数据点位", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的数据点位 ID 数组") @PathVariable String[] ids) {
        return toAjax(edgeDataPointService.deleteEdgeDataPointByIds(ids));
    }
}
