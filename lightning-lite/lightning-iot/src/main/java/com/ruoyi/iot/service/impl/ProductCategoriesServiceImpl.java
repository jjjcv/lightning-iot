package com.ruoyi.iot.service.impl;

import java.util.List;

import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.ProductCategoriesMapper;
import com.ruoyi.iot.domain.ProductCategory;
import com.ruoyi.iot.service.IProductCategoriesService;

/**
 * 产品类型Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-03-05
 */
@Service
public class ProductCategoriesServiceImpl implements IProductCategoriesService 
{
    @Autowired
    private ProductCategoriesMapper productCategoriesMapper;

    /**
     * 查询产品类型
     * 
     * @param categoryId 产品类型主键
     * @return 产品类型
     */
    @Override
    public ProductCategory selectProductCategoriesByCategoryId(Long categoryId)
    {
        return productCategoriesMapper.selectProductCategoriesByCategoryId(categoryId);
    }

    /**
     * 查询产品类型列表
     * 
     * @param productCategory 产品类型
     * @return 产品类型
     */
    @Override
    public List<ProductCategory> selectProductCategoriesList(ProductCategory productCategory)
    {
        return productCategoriesMapper.selectProductCategoriesList(productCategory);
    }

    /**
     * 新增产品类型
     * 
     * @param productCategory 产品类型
     * @return 结果
     */
    @Override
    public int insertProductCategories(ProductCategory productCategory)
    {
        ProductCategory info = productCategoriesMapper.selectProductCategoriesByCategoryId(productCategory.getParentId());
        // 如果父节点不为正常状态,则不允许新增子节点
        if (!UserConstants.DEPT_NORMAL.equals(info.getStatus()))
        {
            throw new ServiceException("产品类型停用，不允许新增");
        }

        productCategory.setAncestors(info.getAncestors() + "," + productCategory.getParentId());
        productCategory.setCreateTime(DateUtils.getNowDate());
        return productCategoriesMapper.insertProductCategories(productCategory);
    }

    /**
     * 修改产品类型
     *
     * @param productCategory 产品类型
     * @return 结果
     */
    @Override
    public int updateProductCategories(ProductCategory productCategory)
    {

        ProductCategory newParentCategories = productCategoriesMapper.selectProductCategoriesByCategoryId(productCategory.getParentId());
        ProductCategory oldCategories = productCategoriesMapper.selectProductCategoriesByCategoryId(productCategory.getCategoryId());
        productCategory.setUpdateTime(DateUtils.getNowDate());

        if (StringUtils.isNotNull(newParentCategories) && StringUtils.isNotNull(oldCategories))
        {
            String newAncestors = newParentCategories.getAncestors() + "," + newParentCategories.getCategoryId();
            String oldAncestors = oldCategories.getAncestors();
            productCategory.setAncestors(newAncestors);
            updateCategoriesChildren(productCategory.getCategoryId(), newAncestors, oldAncestors);
        }
        int result = productCategoriesMapper.updateProductCategories(productCategory);
        if (UserConstants.DEPT_NORMAL.equals(productCategory.getStatus()) && StringUtils.isNotEmpty(productCategory.getAncestors())
                && !StringUtils.equals("0", productCategory.getAncestors()))
        {
            // 如果该部门是启用状态，则启用该部门的所有上级部门
            updateParentCategoriesStatusNormal(productCategory);
        }

        return result;
    }


    private void updateParentCategoriesStatusNormal(ProductCategory category)
    {
        String ancestors = category.getAncestors();
        Long[] categoryIds = Convert.toLongArray(ancestors);
        productCategoriesMapper.updateCategoryStatusNormal(categoryIds);
    }


    public void updateCategoriesChildren(Long categoryId, String newAncestors, String oldAncestors)
    {
        List<ProductCategory> children = productCategoriesMapper.selectChildrenCategoryById(categoryId);
        for (ProductCategory child : children)
        {
            child.setAncestors(child.getAncestors().replaceFirst(oldAncestors, newAncestors));
        }
        if (!children.isEmpty())
        {
            productCategoriesMapper.updateCategoryChildren(children);
        }
    }

    /**
     * 批量删除产品类型
     * 
     * @param categoryIds 需要删除的产品类型主键
     * @return 结果
     */
    @Override
    public int deleteProductCategoriesByCategoryIds(Long[] categoryIds)
    {
        return productCategoriesMapper.deleteProductCategoriesByCategoryIds(categoryIds);
    }

    /**
     * 删除产品类型信息
     * 
     * @param categoryId 产品类型主键
     * @return 结果
     */
    @Override
    public int deleteProductCategoriesByCategoryId(Long categoryId)
    {
        return productCategoriesMapper.deleteProductCategoriesByCategoryId(categoryId);
    }

    @Override
    public boolean checkCategoryNameUnique(ProductCategory productCategory) {
        Long categoryId = StringUtils.isNull(productCategory.getCategoryId()) ? -1L : productCategory.getCategoryId();
        ProductCategory info = productCategoriesMapper.checkCategoryNameUnique(productCategory.getCategoryName(), productCategory.getParentId());
        if (StringUtils.isNotNull(info) && info.getCategoryId().longValue() != categoryId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    @Override
    public int selectNormalChildrenCategoryById(Long categoryId){
        return productCategoriesMapper.selectNormalChildrenCategoryById(categoryId);
    }

    @Override
    public boolean hasChildByCategoryIds(Long[] categoryIds) {
        int result = productCategoriesMapper.hasChildByCategoryIds(categoryIds);
        return result > 0;
    }
}
