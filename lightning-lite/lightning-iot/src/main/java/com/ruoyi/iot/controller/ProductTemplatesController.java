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
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.iot.domain.ProductTemplate;
import com.ruoyi.iot.service.IProductTemplatesService;
import com.ruoyi.common.utils.poi.ExcelUtil;

// Swagger V3 注解引入
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

/**
 * 产品物模型Controller
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@Tag(name = "产品物模型管理", description = "提供产品物模型的增删改查及导出功能")
@OpenAPIDefinition(info = @Info(title = "产品物模型 API", version = "v1"))
@RestController
@RequestMapping("/iot/productTemplates")
public class ProductTemplatesController extends BaseController {
    @Autowired
    private IProductTemplatesService productTemplatesService;

    /**
     * 查询产品物模型列表
     */
    @Operation(summary = "获取产品物模型列表", description = "根据过滤条件返回产品物模型列表（无分页）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:list')")
    @GetMapping("/list")
    public AjaxResult list(
        @Parameter(description = "产品物模型查询条件（如产品ID、类型等）") ProductTemplate productTemplate) {
        List<ProductTemplate> list = productTemplatesService.selectProductTemplatesList(productTemplate);
        return success(list);
    }

    /**
     * 导出产品物模型列表
     */
    @Operation(summary = "导出产品物模型列表为 Excel", description = "根据过滤条件导出产品物模型信息到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:export')")
    @Log(title = "产品物模型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") ProductTemplate productTemplate) {
        List<ProductTemplate> list = productTemplatesService.selectProductTemplatesList(productTemplate);
        ExcelUtil<ProductTemplate> util = new ExcelUtil<>(ProductTemplate.class);
        util.exportExcel(response, list, "产品物模型数据");
    }

    /**
     * 获取产品物模型详细信息
     */
    @Operation(summary = "获取产品物模型详细信息", description = "通过 ID 查询单个产品物模型的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "产品物模型不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "产品物模型唯一标识") @PathVariable("id") String id) {
        return success(productTemplatesService.selectProductTemplatesById(id));
    }

    /**
     * 新增产品物模型
     */
    @Operation(summary = "新增产品物模型", description = "创建新的产品物模型记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品物模型创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:add')")
    @Log(title = "产品物模型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "productTemplate", description = "需新增的产品物模型数据") @RequestBody ProductTemplate productTemplate) {
        return toAjax(productTemplatesService.insertProductTemplates(productTemplate));
    }

    /**
     * 修改产品物模型
     */
    @Operation(summary = "更新产品物模型信息", description = "根据 ID 更新现有产品物模型记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品物模型更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:edit')")
    @Log(title = "产品物模型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "productTemplate", description = "需更新的产品物模型数据") @RequestBody ProductTemplate productTemplate) {
        return toAjax(productTemplatesService.updateProductTemplates(productTemplate));
    }

    /**
     * 删除产品物模型
     */
    @Operation(summary = "删除产品物模型", description = "根据 ID 数组批量删除产品物模型记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品物模型删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:remove')")
    @Log(title = "产品物模型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的产品物模型 ID 数组") @PathVariable String[] ids) {
        return toAjax(productTemplatesService.deleteProductTemplatesByIds(ids));
    }

    /**
     * 导入产品物模型列表
     */
    @Operation(summary = "导入产品物模型列表", description = "从 Excel 文件导入产品物模型数据，支持根据 ID 更新已有记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "导入成功"),
        @ApiResponse(responseCode = "400", description = "文件格式错误或数据冲突")
    })
    @PreAuthorize("@ss.hasPermi('iot:productTemplates:add')")
    @Log(title = "产品物模型", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(
        @Parameter(name = "file", description = "包含产品物模型信息的 Excel 文件", required = true) MultipartFile file,
        @Parameter(name = "updateSupport", description = "是否允许更新现有产品物模型") boolean updateSupport) throws Exception {
        ExcelUtil<ProductTemplate> util = new ExcelUtil<>(ProductTemplate.class);
        List<ProductTemplate> productTemplateList = util.importExcel(file.getInputStream());
        String message = productTemplatesService.importProductTemplates(productTemplateList, updateSupport, getUsername());
        return success(message);
    }

    /**
     * 下载产品物模型导入模板
     */
    @Operation(summary = "下载产品物模型导入模板", description = "下载产品物模型数据 Excel 导入模板")
    @PostMapping("/importTemplate")
    public void importTemplate(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response) {
        ExcelUtil<ProductTemplate> util = new ExcelUtil<>(ProductTemplate.class);
        util.importTemplateExcel(response, "产品物模型数据");
    }
}
