package com.ruoyi.iot.service.impl;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.mapper.ProductsMapper;
import com.ruoyi.iot.service.IDevicesService;
import com.ruoyi.iot.service.IProductTemplatesService;
import com.ruoyi.iot.service.IProductsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Arrays;
import java.util.Objects;
/**
 * 产品信息Service业务层处理
 *
 * 支持 null 缓存，避免缓存穿透
 *
 */
@Service
public class ProductsServiceImpl implements IProductsService
{
    @Autowired
    private ProductsMapper productsMapper;

    @Autowired
    private TagBindingService tagBindingService;

    @Autowired
    private IProductTemplatesService productTemplatesService;

    @Autowired
    @Lazy
    private IDevicesService devicesService;

    @Autowired
    private CacheManager cacheManager;

    // 用于缓存 null 的占位对象
    private static final Product NULL_PRODUCT = new Product();

    /**
     * 查询产品信息（支持缓存 null，避免缓存穿透）
     *
     * @param id 产品信息主键
     * @return 产品信息，数据库不存在返回 null
     */
    @Override
    @Cacheable(value = "product", key = "#id")
    public Product selectProductsById(String id)
    {
        Product product = productsMapper.selectProductsById(id);
        // 数据库返回 null，用占位对象代替
        return product != null ? product : NULL_PRODUCT;
    }

    /**
     * 查询产品信息列表
     *
     * @param product 产品信息
     * @return 产品信息
     */
    @Override
    public List<Product> selectProductsList(Product product)
    {
        return productsMapper.selectProductsList(product);
    }

    /**
     * 新增产品信息
     *
     * @param product 产品信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertProducts(Product product)
    {
        if (StringUtils.isEmpty(product.getId())) {
            product.setId(IdUtil.getSnowflakeNextIdStr());
        }

        product.setCreateTime(DateUtils.getNowDate());
        if (product.getStatus() == null){
            product.setStatus("disable");
        }
        int rows = productsMapper.insertProducts(product);
        if (rows > 0 && product.getTagIds() != null) {
            tagBindingService.replaceTags("product", product.getId(), product.getTagIds());
        }
        return rows;
    }

    /**
     * 修改产品信息
     *
     * @param product 产品信息
     * @return 结果
     */
    @Override
    @CacheEvict(value = "product", key = "#product.id")
    @Transactional(rollbackFor = Exception.class)
    public int updateProduct(Product product)
    {
        product.setUpdateTime(DateUtils.getNowDate());
        int rows = productsMapper.updateProducts(product);
        if (rows > 0 && product.getTagIds() != null) {
            tagBindingService.replaceTags("product", product.getId(), product.getTagIds());
        }
        return rows;
    }

    /**
     * 批量删除产品信息
     *
     * @param ids 需要删除的产品信息主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteProductsByIds(String[] ids)
    {
        for (String id : ids) {
            if (devicesService.countByProductId(id) != 0) {
                throw new ServiceException("产品下有设备，请先删除设备");
            }
            productTemplatesService.deleteByProductId(id);
            // 删除缓存
            evictProductCache(id);
        }
        for (String id : Arrays.stream(ids).distinct().sorted().toList()) {
            tagBindingService.removeObjectTags("product", id);
        }
        return productsMapper.deleteProductsByIds(ids);
    }

    /**
     * 删除产品信息
     *
     * @param id 产品信息主键
     * @return 结果
     */
    @Override
    @CacheEvict(value = "product", key = "#id")
    @Transactional(rollbackFor = Exception.class)
    public int deleteProductsById(String id)
    {
        if (devicesService.countByProductId(id) != 0) {
            throw new ServiceException("产品下有设备，请先删除设备");
        }
        productTemplatesService.deleteByProductId(id);
        tagBindingService.removeObjectTags("product", id);
        return productsMapper.deleteProductsById(id);
    }

    /**
     * 清除指定产品的缓存
     *
     * @param productId 产品ID
     */
    private void evictProductCache(String productId) {
        Objects.requireNonNull(cacheManager.getCache("product")).evict(productId);
    }

    /**
     * 导入产品数据
     *
     * @param productList 产品数据列表
     * @param isUpdateSupport 是否更新已存在产品
     * @param operName 操作用户
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importProducts(List<Product> productList, boolean isUpdateSupport, String operName)
    {
        if (StringUtils.isNull(productList) || productList.isEmpty())
        {
            throw new ServiceException("导入产品数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (Product product : productList)
        {
            try
            {
                if (StringUtils.isEmpty(product.getId()))
                {
                    product.setCreateBy(operName);
                    insertProducts(product);
                    evictProductCache(product.getId());
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、产品 " + product.getName() + " 导入成功");
                    continue;
                }

                // 直接走 mapper 查询，避免 selectProductsById 的 null 占位缓存影响判空
                Product oldProduct = productsMapper.selectProductsById(product.getId());
                if (StringUtils.isNull(oldProduct))
                {
                    product.setCreateBy(operName);
                    insertProducts(product);
                    evictProductCache(product.getId());
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、产品 " + product.getName() + " 导入成功");
                }
                else if (isUpdateSupport)
                {
                    product.setUpdateBy(operName);
                    updateProduct(product);
                    evictProductCache(product.getId());
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、产品 " + product.getName() + " 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、产品 " + product.getName() + " 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                failureMsg.append("<br/>" + failureNum + "、产品 " + product.getName() + " 导入失败：" + e.getMessage());
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        return successMsg.toString();
    }
}
