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
import com.ruoyi.iot.domain.Buildings;
import com.ruoyi.iot.service.IBuildingsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 建筑基础信息Controller
 * 
 * @author ruoyi
 * @date 2025-08-26
 */
@Tag(name = "建筑基础信息管理", description = "提供建筑基础信息的增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "建筑基础信息 API", version = "v1"))
@RestController
@RequestMapping("/iot/buildings")
public class BuildingsController extends BaseController {
    @Autowired
    private IBuildingsService buildingsService;



    /**
     * 查询建筑基础信息列表
     */
    @Operation(summary = "分页查询建筑基础信息列表", description = "根据过滤条件分页查询建筑数据")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:buildings:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
            @Parameter(description = "建筑查询条件（如名称、地址等）") Buildings buildings) {
        List<Buildings> list = buildingsService.selectBuildingsList(buildings);
        return success(list);
    }



    /**
     * 查询建筑基础信息列表
     */
    @Operation(summary = "分页查询建筑基础信息列表", description = "根据过滤条件分页查询建筑数据")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
            @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:buildings:list')")
    @GetMapping("/list")
    public TableDataInfo list(
            @Parameter(description = "建筑查询条件（如名称、地址等）") Buildings buildings) {
        startPage();
        List<Buildings> list = buildingsService.selectBuildingsList(buildings);
        return getDataTable(list);
    }

    /**
     * 导出建筑基础信息列表
     */
    @Operation(summary = "导出建筑基础信息为 Excel", description = "根据过滤条件导出建筑数据到 Excel 文件")
    @PreAuthorize("@ss.hasPermi('iot:buildings:export')")
    @Log(title = "建筑基础信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
            @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
            @Parameter(description = "导出数据的过滤条件") Buildings buildings) {
        List<Buildings> list = buildingsService.selectBuildingsList(buildings);
        ExcelUtil<Buildings> util = new ExcelUtil<Buildings>(Buildings.class);
        util.exportExcel(response, list, "建筑基础信息数据");
    }

    /**
     * 获取建筑基础信息详细信息
     */
    @Operation(summary = "获取建筑详细信息", description = "通过 ID 查询单个建筑的完整信息")
    @PreAuthorize("@ss.hasPermi('iot:buildings:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
            @Parameter(name = "id", description = "建筑唯一标识") @PathVariable("id") Long id) {
        return success(buildingsService.selectBuildingsById(id));
    }

    /**
     * 新增建筑基础信息
     */
    @Operation(summary = "新增建筑信息", description = "创建新的建筑记录")
    @PreAuthorize("@ss.hasPermi('iot:buildings:add')")
    @Log(title = "建筑基础信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
            @Parameter(name = "buildings", description = "需新增的建筑数据") @RequestBody Buildings buildings) {
        return toAjax(buildingsService.insertBuildings(buildings));
    }

    /**
     * 修改建筑基础信息
     */
    @Operation(summary = "更新建筑信息", description = "根据 ID 更新现有建筑数据")
    @PreAuthorize("@ss.hasPermi('iot:buildings:edit')")
    @Log(title = "建筑基础信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
            @Parameter(name = "buildings", description = "需更新的建筑数据") @RequestBody Buildings buildings) {
        return toAjax(buildingsService.updateBuildings(buildings));
    }

    /**
     * 删除建筑基础信息
     */
    @Operation(summary = "删除建筑信息", description = "根据 ID 数组批量删除建筑数据")
    @PreAuthorize("@ss.hasPermi('iot:buildings:remove')")
    @Log(title = "建筑基础信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
            @Parameter(name = "ids", description = "需删除的建筑 ID 数组") @PathVariable Long[] ids) {
        return toAjax(buildingsService.deleteBuildingsByIds(ids));
    }
}
