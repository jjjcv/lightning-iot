package com.ruoyi.iot.controller;

import java.util.List;
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
import com.ruoyi.iot.domain.Unit;
import com.ruoyi.iot.service.IUnitService;
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
 * 单位信息Controller
 *
 * @author ruoyi
 * @date 2025-08-28
 */
@Tag(name = "单位信息管理", description = "提供单位信息的增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "单位信息 API", version = "v1"))
@RestController
@RequestMapping("/iot/unit")
public class UnitController extends BaseController {
    @Autowired
    private IUnitService unitService;

    /**
     * 查询所有单位信息列表
     */
    @Operation(summary = "获取所有单位信息", description = "返回所有单位信息记录（无分页）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
        @Parameter(description = "单位查询条件（如名称、状态等）") Unit unit) {
        List<Unit> list = unitService.selectUnitList(unit);
        return success(list);
    }

    /**
     * 分页查询单位信息列表
     */
    @Operation(summary = "分页查询单位信息列表", description = "根据过滤条件分页查询单位信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "单位查询条件（如名称、状态等）") Unit unit) {
        startPage();
        List<Unit> list = unitService.selectUnitList(unit);
        return getDataTable(list);
    }

    /**
     * 导出单位信息列表
     */
    @Operation(summary = "导出单位信息列表为 Excel", description = "根据过滤条件导出单位信息到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:export')")
    @Log(title = "单位信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") Unit unit) {
        List<Unit> list = unitService.selectUnitList(unit);
        ExcelUtil<Unit> util = new ExcelUtil<>(Unit.class);
        util.exportExcel(response, list, "单位信息数据");
    }

    /**
     * 获取单位信息详细信息
     */
    @Operation(summary = "获取单位详细信息", description = "通过 ID 查询单个单位的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "单位信息不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "单位唯一标识") @PathVariable("id") Long id) {
        return success(unitService.selectUnitById(id));
    }

    /**
     * 新增单位信息
     */
    @Operation(summary = "新增单位信息", description = "创建新的单位记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "单位创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:add')")
    @Log(title = "单位信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "unit", description = "需新增的单位数据") @RequestBody Unit unit) {
        return toAjax(unitService.insertUnit(unit));
    }

    /**
     * 修改单位信息
     */
    @Operation(summary = "更新单位信息", description = "根据 ID 更新现有单位记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "单位更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:edit')")
    @Log(title = "单位信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "unit", description = "需更新的单位数据") @RequestBody Unit unit) {
        return toAjax(unitService.updateUnit(unit));
    }

    /**
     * 删除单位信息
     */
    @Operation(summary = "删除单位信息", description = "根据 ID 数组批量删除单位记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "单位删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:unit:remove')")
    @Log(title = "单位信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的单位 ID 数组") @PathVariable Long[] ids) {
        return toAjax(unitService.deleteUnitByIds(ids));
    }
}
