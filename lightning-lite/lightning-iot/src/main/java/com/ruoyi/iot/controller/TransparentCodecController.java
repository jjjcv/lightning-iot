package com.ruoyi.iot.controller;

import java.util.List;
import com.ruoyi.iot.domain.TransparentCodec;
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
import com.ruoyi.iot.service.ITransparentCodecService;
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
 * 透传消息解析器Controller
 *
 * @author ruoyi
 * @date 2025-02-27
 */
@Tag(name = "透传消息解析器管理", description = "提供透传消息解析器的增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "透传消息解析器 API", version = "v1"))
@RestController
@RequestMapping("/iot/transparentCodec")
public class TransparentCodecController extends BaseController {
    @Autowired
    private ITransparentCodecService transparentCodecService;

    /**
     * 查询透传消息解析器列表（分页）
     */
    @Operation(summary = "分页查询透传消息解析器", description = "根据过滤条件分页查询解析器记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "解析器查询条件（如名称、类型等）") TransparentCodec transparentCodec) {
        startPage();
        List<TransparentCodec> list = transparentCodecService.selectTransparentCodecList(transparentCodec);
        return getDataTable(list);
    }


    /**
     * 查询透传消息解析器列表
     */
    @Operation(summary = "查询全部消息解析器", description = "根据过滤条件查询解析器记录")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回数据"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
            @Parameter(description = "解析器查询条件（如名称、类型等）") TransparentCodec transparentCodec) {
        List<TransparentCodec> list = transparentCodecService.selectTransparentCodecList(transparentCodec);
        return success(list);
    }
    /**
     * 导出透传消息解析器列表
     */
    @Operation(summary = "导出解析器列表为 Excel", description = "根据过滤条件导出解析器记录到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:export')")
    @Log(title = "透传消息解析器", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") TransparentCodec transparentCodec) {
        List<TransparentCodec> list = transparentCodecService.selectTransparentCodecList(transparentCodec);
        ExcelUtil<TransparentCodec> util = new ExcelUtil<TransparentCodec>(TransparentCodec.class);
        util.exportExcel(response, list, "透传消息解析器数据");
    }

    /**
     * 获取透传消息解析器详细信息
     */
    @Operation(summary = "获取解析器详细信息", description = "通过 ID 查询单个解析器的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "解析器不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "解析器唯一标识", required = true) @PathVariable("id") String id) {
        return success(transparentCodecService.selectTransparentCodecById(id));
    }

    /**
     * 新增透传消息解析器
     */
    @Operation(summary = "新增解析器", description = "创建新的透传消息解析器记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "解析器创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:add')")
    @Log(title = "透传消息解析器", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "transparentCodec", description = "需新增的解析器数据") @RequestBody TransparentCodec transparentCodec) {
        return toAjax(transparentCodecService.insertTransparentCodec(transparentCodec));
    }

    /**
     * 修改透传消息解析器
     */
    @Operation(summary = "更新解析器信息", description = "根据 ID 更新现有解析器记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "解析器更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:edit')")
    @Log(title = "透传消息解析器", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "transparentCodec", description = "需更新的解析器数据") @RequestBody TransparentCodec transparentCodec) {
        return toAjax(transparentCodecService.updateTransparentCodec(transparentCodec));
    }

    /**
     * 删除透传消息解析器
     */
    @Operation(summary = "删除解析器", description = "根据 ID 数组批量删除解析器记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "解析器删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:transparentCodec:remove')")
    @Log(title = "透传消息解析器", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的解析器 ID 数组") @PathVariable String[] ids) {
        return toAjax(transparentCodecService.deleteTransparentCodecByIds(ids));
    }
}
