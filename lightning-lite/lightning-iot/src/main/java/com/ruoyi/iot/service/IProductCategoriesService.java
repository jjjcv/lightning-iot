package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.ProductCategory;

/**
 * 产品类型Service接口
 * 
 * @author ruoyi
 * @date 2025-03-05
 */
public interface IProductCategoriesService 
{
    /**
     * 查询产品类型
     * 
     * @param categoryId 产品类型主键
     * @return 产品类型
     */
    public ProductCategory selectProductCategoriesByCategoryId(Long categoryId);

    /**
     * 查询产品类型列表
     * 
     * @param productCategory 产品类型
     * @return 产品类型集合
     */
    public List<ProductCategory> selectProductCategoriesList(ProductCategory productCategory);

    /**
     * 新增产品类型
     * 
     * @param productCategory 产品类型
     * @return 结果
     */
    public int insertProductCategories(ProductCategory productCategory);

    /**
     * 修改产品类型
     * 
     * @param productCategory 产品类型
     * @return 结果
     */
    public int updateProductCategories(ProductCategory productCategory);

    /**
     * 批量删除产品类型
     * 
     * @param categoryIds 需要删除的产品类型主键集合
     * @return 结果
     */
    public int deleteProductCategoriesByCategoryIds(Long[] categoryIds);

    /**
     * 删除产品类型信息
     * 
     * @param categoryId 产品类型主键
     * @return 结果
     */
    public int deleteProductCategoriesByCategoryId(Long categoryId);


    public boolean checkCategoryNameUnique(ProductCategory productCategory);

    public int selectNormalChildrenCategoryById(Long categoryId);

    public boolean hasChildByCategoryIds(Long[] categoryIds);
}
