package com.ruoyi.iot.controller;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.utils.StringUtils;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.ArrayUtils;
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
import com.ruoyi.iot.domain.ProductCategory;
import com.ruoyi.iot.service.IProductCategoriesService;
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
 * 产品类型Controller
 *
 * @author ruoyi
 * @date 2025-03-05
 */
@Tag(name = "产品类型管理", description = "提供产品类型的增删改查、导出及层级校验功能")
@OpenAPIDefinition(info = @Info(title = "产品类型 API", version = "v1"))
@RestController
@RequestMapping("/iot/productCategories")
public class ProductCategoriesController extends BaseController {
    @Autowired
    private IProductCategoriesService productCategoriesService;

    /**
     * 查询产品类型列表
     */
    @Operation(summary = "查询产品类型列表", description = "根据过滤条件返回产品类型列表（无分页）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:list')")
    @GetMapping("/list")
    public AjaxResult list(
        @Parameter(description = "产品类型查询条件（如名称、状态等）") ProductCategory productCategory) {
        List<ProductCategory> list = productCategoriesService.selectProductCategoriesList(productCategory);
        return success(list);
    }

    /**
     * 排除指定ID的列表
     */
    @Operation(summary = "获取排除指定ID的产品类型列表", description = "返回所有产品类型并过滤掉指定ID及其子节点")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回过滤后的列表"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:list')")
    @GetMapping("/list/exclude/{categoryId}")
    public AjaxResult excludeChild(
        @Parameter(name = "categoryId", description = "需排除的节点ID（可选）", required = false)
        @PathVariable(value = "categoryId", required = false) Long categoryId) {
        List<ProductCategory> productCategories = productCategoriesService.selectProductCategoriesList(new ProductCategory());
        productCategories.removeIf(c -> c.getCategoryId().intValue() == categoryId || ArrayUtils.contains(StringUtils.split(c.getAncestors(), ","), categoryId + ""));
        return success(productCategories);
    }

    /**
     * 导出产品类型列表
     */
    @Operation(summary = "导出产品类型列表为 Excel", description = "根据过滤条件导出产品类型信息到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:export')")
    @Log(title = "产品类型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") ProductCategory productCategory) {
        List<ProductCategory> list = productCategoriesService.selectProductCategoriesList(productCategory);
        ExcelUtil<ProductCategory> util = new ExcelUtil<ProductCategory>(ProductCategory.class);
        util.exportExcel(response, list, "产品类型数据");
    }

    /**
     * 获取产品类型详细信息
     */
    @Operation(summary = "获取产品类型详细信息", description = "通过 ID 查询单个产品类型的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "产品类型不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:query')")
    @GetMapping(value = "/{categoryId}")
    public AjaxResult getInfo(
        @Parameter(name = "categoryId", description = "产品类型唯一标识") @PathVariable("categoryId") Long categoryId) {
        return success(productCategoriesService.selectProductCategoriesByCategoryId(categoryId));
    }

    /**
     * 新增产品类型
     */
    @Operation(summary = "新增产品类型", description = "创建新的产品类型记录并校验唯一性")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品类型创建成功"),
        @ApiResponse(responseCode = "400", description = "参数冲突或校验失败")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:add')")
    @Log(title = "产品类型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "productCategory", description = "需新增的产品类型数据") @RequestBody ProductCategory productCategory) {
        if (!productCategoriesService.checkCategoryNameUnique(productCategory)) {
            return error("新增产品类型'" + productCategory.getCategoryName() + "'失败，类型名称已存在");
        }
        productCategory.setCreateBy(getUsername());
        return toAjax(productCategoriesService.insertProductCategories(productCategory));
    }

    /**
     * 修改产品类型
     */
    @Operation(summary = "更新产品类型信息", description = "根据 ID 更新现有产品类型记录并校验层级关系")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品类型更新成功"),
        @ApiResponse(responseCode = "400", description = "参数冲突或校验失败")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:edit')")
    @Log(title = "产品类型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "productCategory", description = "需更新的产品类型数据") @RequestBody ProductCategory productCategory) {
        Long categoryId = productCategory.getCategoryId();
        if (!productCategoriesService.checkCategoryNameUnique(productCategory)) {
            return error("修改产品类型'" + productCategory.getCategoryName() + "'失败，产品类型名称已存在");
        } else if (productCategory.getParentId().equals(categoryId)) {
            return error("修改产品类型'" + productCategory.getCategoryName() + "'失败，上级产品类型不能是自己");
        } else if (StringUtils.equals(UserConstants.DEPT_DISABLE, productCategory.getStatus()) && productCategoriesService.selectNormalChildrenCategoryById(categoryId) > 0) {
            return error("该产品类型包含未停用的子产品类型！");
        }
        productCategory.setUpdateBy(getUsername());
        productCategory.setUpdateTime(new Date());
        return toAjax(productCategoriesService.updateProductCategories(productCategory));
    }

    /**
     * 删除产品类型
     */
    @Operation(summary = "删除产品类型", description = "根据 ID 数组批量删除产品类型（需无子节点）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品类型删除成功"),
        @ApiResponse(responseCode = "400", description = "存在下级节点或参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:productCategories:remove')")
    @Log(title = "产品类型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{categoryIds}")
    public AjaxResult remove(
        @Parameter(name = "categoryIds", description = "需删除的产品类型 ID 数组") @PathVariable Long[] categoryIds) {
        if (productCategoriesService.hasChildByCategoryIds(categoryIds)) {
            return warn("存在下级产品类型,不允许删除");
        }
        return toAjax(productCategoriesService.deleteProductCategoriesByCategoryIds(categoryIds));
    }
}
