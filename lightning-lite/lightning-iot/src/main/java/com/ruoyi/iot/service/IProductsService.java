package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.Product;

/**
 * 产品信息Service接口
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
public interface IProductsService 
{
    /**
     * 查询产品信息
     * 
     * @param id 产品信息主键
     * @return 产品信息
     */
    public Product selectProductsById(String id);

    /**
     * 查询产品信息列表
     * 
     * @param product 产品信息
     * @return 产品信息集合
     */
    public List<Product> selectProductsList(Product product);

    /**
     * 新增产品信息
     * 
     * @param product 产品信息
     * @return 结果
     */
    public int insertProducts(Product product);

    /**
     * 修改产品信息
     * 
     * @param product 产品信息
     * @return 结果
     */
    public int updateProduct(Product product);

    /**
     * 批量删除产品信息
     * 
     * @param ids 需要删除的产品信息主键集合
     * @return 结果
     */
    public int deleteProductsByIds(String[] ids);

    /**
     * 删除产品信息信息
     *
     * @param id 产品信息主键
     * @return 结果
     */
    public int deleteProductsById(String id);

    /**
     * 导入产品数据
     *
     * @param productList 产品数据列表
     * @param isUpdateSupport 是否更新已存在产品
     * @param operName 操作用户
     * @return 结果
     */
    public String importProducts(List<Product> productList, boolean isUpdateSupport, String operName);
}
