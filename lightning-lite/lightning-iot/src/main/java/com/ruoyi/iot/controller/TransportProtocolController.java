package com.ruoyi.iot.controller;

import java.util.List;
import com.ruoyi.iot.domain.TransportProtocol;
import com.ruoyi.iot.service.ITransportProtocolService;
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
 * 传输协议Controller
 *
 * @author ruoyi
 * @date 2025-02-27
 */
@Tag(name = "传输协议管理", description = "提供传输协议的增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "传输协议 API", version = "v1"))
@RestController
@RequestMapping("/iot/protocol")
public class TransportProtocolController extends BaseController {
    @Autowired
    private ITransportProtocolService transportProtocolService;

    /**
     * 查询传输协议列表（分页）
     */
    @Operation(summary = "分页查询传输协议列表", description = "根据过滤条件分页查询传输协议信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "传输协议查询条件（如名称、状态等）") TransportProtocol transportProtocol) {
        startPage();
        List<TransportProtocol> list = transportProtocolService.selectTransportProtocolList(transportProtocol);
        return getDataTable(list);
    }

    /**
     * 查询传输协议列表（全量）
     */
    @Operation(summary = "获取所有传输协议", description = "返回所有传输协议记录（无分页）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
        @Parameter(description = "传输协议查询条件（如名称、状态等）") TransportProtocol transportProtocol) {
        List<TransportProtocol> list = transportProtocolService.selectTransportProtocolList(transportProtocol);
        return success(list);
    }

    /**
     * 导出传输协议列表
     */
    @Operation(summary = "导出传输协议列表为 Excel", description = "根据过滤条件导出传输协议信息到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:export')")
    @Log(title = "传输协议", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") TransportProtocol transportProtocol) {
        List<TransportProtocol> list = transportProtocolService.selectTransportProtocolList(transportProtocol);
        ExcelUtil<TransportProtocol> util = new ExcelUtil<>(TransportProtocol.class);
        util.exportExcel(response, list, "传输协议数据");
    }

    /**
     * 获取传输协议详细信息
     */
    @Operation(summary = "获取传输协议详细信息", description = "通过 ID 查询单个传输协议的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "传输协议不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "传输协议唯一标识", required = true) @PathVariable("id") String id) {
        return success(transportProtocolService.selectTransportProtocolById(id));
    }

    /**
     * 新增传输协议
     */
    @Operation(summary = "新增传输协议", description = "创建新的传输协议记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "传输协议创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:add')")
    @Log(title = "传输协议", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "transportProtocol", description = "需新增的传输协议数据") @RequestBody TransportProtocol transportProtocol) {
        return toAjax(transportProtocolService.insertTransportProtocol(transportProtocol));
    }

    /**
     * 修改传输协议
     */
    @Operation(summary = "更新传输协议信息", description = "根据 ID 更新现有传输协议记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "传输协议更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:edit')")
    @Log(title = "传输协议", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "transportProtocol", description = "需更新的传输协议数据") @RequestBody TransportProtocol transportProtocol) {
        return toAjax(transportProtocolService.updateTransportProtocol(transportProtocol));
    }

    /**
     * 删除传输协议
     */
    @Operation(summary = "删除传输协议", description = "根据 ID 数组批量删除传输协议记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "传输协议删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:protocol:remove')")
    @Log(title = "传输协议", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的传输协议 ID 数组") @PathVariable String[] ids) {
        return toAjax(transportProtocolService.deleteTransportProtocolByIds(ids));
    }
}
