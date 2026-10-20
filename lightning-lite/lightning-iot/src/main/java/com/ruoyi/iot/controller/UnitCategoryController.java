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
import com.ruoyi.iot.domain.UnitCategory;
import com.ruoyi.iot.service.IUnitCategoryService;
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
 * 单位类型Controller
 *
 * @author ruoyi
 * @date 2025-08-28
 */
@Tag(name = "单位类型管理", description = "提供单位类型的增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "单位类型 API", version = "v1"))
@RestController
@RequestMapping("/iot/categoryUnit")
public class UnitCategoryController extends BaseController {
    @Autowired
    private IUnitCategoryService unitCategoryService;

    /**
     * 查询单位类型列表（分页）
     */
    @Operation(summary = "分页查询单位类型列表", description = "根据过滤条件分页查询单位类型信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:categoryUnit:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "单位类型查询条件（如名称、状态等）") UnitCategory unitCategory) {
        startPage();
        List<UnitCategory> list = unitCategoryService.selectUnitCategoryList(unitCategory);
        return getDataTable(list);
    }

    /**
     * 导出单位类型列表
     */
    @Operation(summary = "导出单位类型列表为 Excel", description = "根据过滤条件导出单位类型信息到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:categoryUnit:export')")
    @Log(title = "单位类型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") UnitCategory unitCategory) {
        List<UnitCategory> list = unitCategoryService.selectUnitCategoryList(unitCategory);
        ExcelUtil<UnitCategory> util = new ExcelUtil<>(UnitCategory.class);
        util.exportExcel(response, list, "单位类型数据");
    }

    /**
     * 获取单位类型详细信息
     */
    @Operation(summary = "获取单位类型详细信息", description = "通过 ID 查询单个单位类型的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "单位类型不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:categoryUnit:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "单位类型唯一标识") @PathVariable("id") Long id) {
        return success(unitCategoryService.selectUnitCategoryById(id));
    }

    /**
     * 新增单位类型
     */
    @Operation(summary = "新增单位类型", description = "创建新的单位类型记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "单位类型创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:categoryUnit:add')")
    @Log(title = "单位类型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "unitCategory", description = "需新增的单位类型数据") @RequestBody UnitCategory unitCategory) {
        return toAjax(unitCategoryService.insertUnitCategory(unitCategory));
    }

    /**
     * 修改单位类型
     */
    @Operation(summary = "更新单位类型信息", description = "根据 ID 更新现有单位类型记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "单位类型更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:categoryUnit:edit')")
    @Log(title = "单位类型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "unitCategory", description = "需更新的单位类型数据") @RequestBody UnitCategory unitCategory) {
        return toAjax(unitCategoryService.updateUnitCategory(unitCategory));
    }

    /**
     * 删除单位类型
     */
    @Operation(summary = "删除单位类型", description = "根据 ID 数组批量删除单位类型记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "单位类型删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:categoryUnit:remove')")
    @Log(title = "单位类型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的单位类型 ID 数组") @PathVariable Long[] ids) {
        return toAjax(unitCategoryService.deleteUnitCategoryByIds(ids));
    }
}
