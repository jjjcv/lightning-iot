package com.ruoyi.iot.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.service.impl.TagBindingService;
import org.springframework.beans.BeanUtils;
import com.ruoyi.iot.service.IProductsService;
import com.ruoyi.iot.service.impl.DeviceHistoryThrottle;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Objects;

/**
 * 产品信息Controller
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@Tag(name = "产品信息管理", description = "提供产品的增删改查、状态切换及定时任务管理功能")
@OpenAPIDefinition(info = @Info(title = "产品信息 API", version = "v1"))
@RestController
@RequestMapping("/iot/products")
public class ProductsController extends BaseController {
    @Autowired
    private IProductsService productsService;

    @Autowired
    private TagBindingService tagBindingService;

    @Autowired
    private DeviceHistoryThrottle deviceHistoryThrottle;

    /**
     * 查询产品信息列表（分页）
     */
    @Operation(summary = "分页查询产品信息列表", description = "根据过滤条件分页查询产品信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回分页数据"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:list')")
    @GetMapping("/list")
    public TableDataInfo list(
        @Parameter(description = "产品查询条件（如名称、状态等）") Product product) {
        startPage();
        List<Product> list = productsService.selectProductsList(product);
        tagBindingService.fillTags("product", list);
        return getDataTable(list);
    }

    /**
     * 查询产品信息列表（全量）
     */
    @Operation(summary = "获取所有产品信息", description = "返回所有产品信息记录（无分页）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "成功返回数据列表"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:list')")
    @GetMapping("/list/all")
    public AjaxResult listAll(
        @Parameter(description = "产品查询条件（如名称、状态等）") Product product) {
        List<Product> list = productsService.selectProductsList(product);
        tagBindingService.fillTags("product", list);
        return success(list);
    }

    /**
     * 更新产品状态
     */
    @Operation(summary = "更新产品状态", description = "启用或停用产品")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "状态更新成功"),
        @ApiResponse(responseCode = "500", description = "业务逻辑异常（如产品不存在）")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:edit')")
    @Log(title = "产品信息", businessType = BusinessType.UPDATE)
    @PutMapping("/change/status")
    public AjaxResult updateProductStatus(
        @Parameter(name = "id", description = "产品唯一标识") @RequestParam String id,
        @Parameter(name = "status", description = "目标状态（enable/disable）") @RequestParam String status) {
        Product product = productsService.selectProductsById(id);
        // selectProductsById 对不存在的 id 返回 NULL_PRODUCT 占位对象（id 为 null）
        if (product.getId() == null) {
            throw new ServiceException("产品不存在");
        }

        // storageInterval 为 0/null 表示“上报即落库”，不再强制要求设置存储周期；
        // 历史采集已改为事件驱动，启用/停用无需再注册轮询任务
        if (!status.equals(product.getStatus())) {
            Product newPro = new Product();
            newPro.setStatus(status);
            newPro.setId(id);
            productsService.updateProduct(newPro);
            deviceHistoryThrottle.onProductStatusChanged(id, status);
        }

        return success("disable".equals(status) ? "停用成功" : "启用成功");
    }

    /**
     * 导出产品信息列表
     */
    @Operation(summary = "导出产品信息列表为 Excel", description = "根据过滤条件导出产品信息到 Excel 文件")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "文件导出成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:export')")
    @Log(title = "产品信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response,
        @Parameter(description = "导出数据的过滤条件") Product product) {
        List<Product> list = productsService.selectProductsList(product);
        tagBindingService.fillTags("product", list);
        ExcelUtil<Product> util = new ExcelUtil<>(Product.class);
        util.exportExcel(response, list, "产品信息数据");
    }

    /**
     * 导入产品信息列表
     */
    @Operation(summary = "导入产品信息列表", description = "从 Excel 文件导入产品数据，支持根据 ID 更新已有产品")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "导入成功"),
        @ApiResponse(responseCode = "400", description = "文件格式错误或数据冲突")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:add')")
    @Log(title = "产品信息", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(
        @Parameter(name = "file", description = "包含产品信息的 Excel 文件", required = true) MultipartFile file,
        @Parameter(name = "updateSupport", description = "是否允许更新现有产品") boolean updateSupport) throws Exception {
        ExcelUtil<Product> util = new ExcelUtil<>(Product.class);
        List<Product> productList = util.importExcel(file.getInputStream());
        String message = productsService.importProducts(productList, updateSupport, getUsername());
        return success(message);
    }

    /**
     * 下载产品导入模板
     */
    @Operation(summary = "下载产品导入模板", description = "下载产品数据 Excel 导入模板")
    @PostMapping("/importTemplate")
    public void importTemplate(
        @Parameter(description = "HTTP 响应对象") HttpServletResponse response) {
        ExcelUtil<Product> util = new ExcelUtil<>(Product.class);
        util.importTemplateExcel(response, "产品信息数据");
    }

    /**
     * 获取产品信息详细信息
     */
    @Operation(summary = "获取产品详细信息", description = "通过 ID 查询单个产品的完整信息")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "信息查询成功"),
        @ApiResponse(responseCode = "404", description = "产品不存在")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(
        @Parameter(name = "id", description = "产品唯一标识") @PathVariable("id") String id) {
        Product source = productsService.selectProductsById(id);
        if (source == null || source.getId() == null) { return success(source); }
        Product result = new Product();
        BeanUtils.copyProperties(source, result);
        tagBindingService.fillTags("product", List.of(result));
        return success(result);
    }

    /**
     * 新增产品信息
     */
    @Operation(summary = "新增产品信息", description = "创建新产品记录（自动生成唯一ID）")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品创建成功"),
        @ApiResponse(responseCode = "400", description = "请求参数冲突或缺失")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:add')")
    @Log(title = "产品信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(
        @Parameter(name = "product", description = "需新增的产品数据") @RequestBody Product product) {
        return toAjax(productsService.insertProducts(product));
    }

    /**
     * 修改产品信息
     */
    @Operation(summary = "更新产品信息", description = "根据 ID 更新现有产品记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品更新成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:edit')")
    @Log(title = "产品信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(
        @Parameter(name = "product", description = "需更新的产品数据") @RequestBody Product product) {
        Product previous = null;
        if (product.getId() != null && product.getStatus() != null) {
            previous = productsService.selectProductsById(product.getId());
        }

        int rows = productsService.updateProduct(product);
        if (rows > 0 && previous != null && previous.getId() != null
            && !Objects.equals(previous.getStatus(), product.getStatus())) {
            deviceHistoryThrottle.onProductStatusChanged(product.getId(), product.getStatus());
        }
        return toAjax(rows);
    }

    /**
     * 删除产品信息
     */
    @Operation(summary = "删除产品信息", description = "根据 ID 数组批量删除产品记录")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "产品删除成功"),
        @ApiResponse(responseCode = "400", description = "请求参数错误")
    })
    @PreAuthorize("@ss.hasPermi('iot:products:remove')")
    @Log(title = "产品信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(
        @Parameter(name = "ids", description = "需删除的产品 ID 数组") @PathVariable String[] ids) {
        return toAjax(productsService.deleteProductsByIds(ids));
    }
}
