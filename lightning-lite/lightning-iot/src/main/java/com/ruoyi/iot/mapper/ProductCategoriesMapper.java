package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.ProductCategory;
import org.apache.ibatis.annotations.Param;

/**
 * 产品类型Mapper接口
 * 
 * @author ruoyi
 * @date 2025-03-05
 */
public interface ProductCategoriesMapper 
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
     * 删除产品类型
     * 
     * @param categoryId 产品类型主键
     * @return 结果
     */
    public int deleteProductCategoriesByCategoryId(Long categoryId);

    /**
     * 批量删除产品类型
     * 
     * @param categoryIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductCategoriesByCategoryIds(Long[] categoryIds);

    public void updateCategoryStatusNormal(Long[] categoryIds);

    public List<ProductCategory> selectChildrenCategoryById(Long categoryId);

    public int updateCategoryChildren(@Param("categories") List<ProductCategory> categories);

    public ProductCategory checkCategoryNameUnique(@Param("categoryName") String categoryName, @Param("parentId") Long parentId);

    public int selectNormalChildrenCategoryById(Long categoryId);

    public int hasChildByCategoryIds(Long[] categoryIds);
}
