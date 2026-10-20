package com.ruoyi.iot.service.impl;

import java.util.List;

import cn.hutool.core.util.IdUtil;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.iot.metadata.DefaultPropertyMetadata;
import com.ruoyi.iot.metadata.PropertyMetadata;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.iot.mapper.ProductTemplatesMapper;
import com.ruoyi.iot.domain.ProductTemplate;
import com.ruoyi.iot.service.IProductTemplatesService;

/**
 * 产品物模型Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
@CacheConfig(cacheNames = "productTemplateCaches")
@Service
public class ProductTemplatesServiceImpl implements IProductTemplatesService 
{
    @Autowired
    private ProductTemplatesMapper productTemplatesMapper;

    @Autowired
    private CacheManager cacheManager;

    /**
     * 批量删除产品物模型
     *
     * @param productId 产品物模型主键
     * @return 删除结果
     */
    @Override
    public int deleteByProductId(String productId){
        ProductTemplate productTemplate = new ProductTemplate();
        productTemplate.setProductId(productId);
        List<ProductTemplate> productTemplates = productTemplatesMapper.selectProductTemplatesList(productTemplate);
        for (ProductTemplate template : productTemplates) {
            cacheManager.getCache("productTemplateCaches").evict(template.getId());
        }

        return productTemplatesMapper.deleteByProductId(productId);
    }

    /**
     * 查询产品物模型
     * 
     * @param id 产品物模型主键
     * @return 产品物模型
     */
    @Cacheable
    @Override
    public ProductTemplate selectProductTemplatesById(String id)
    {
        return productTemplatesMapper.selectProductTemplatesById(id);
    }


    @Override
    public PropertyMetadata selectPropertyMetadataById(String id){
        ProductTemplate productTemplate = selectProductTemplatesById(id);
        String define = productTemplate.getDefine();
        JSONObject jsonObject = JSON.parseObject(define);
        return new DefaultPropertyMetadata(jsonObject);
    }


    /**
     * 查询产品物模型列表
     * 
     * @param productTemplate 产品物模型
     * @return 产品物模型
     */
    @Override
    public List<ProductTemplate> selectProductTemplatesList(ProductTemplate productTemplate)
    {
        return productTemplatesMapper.selectProductTemplatesList(productTemplate);
    }

    /**
     * 新增产品物模型
     * 
     * @param productTemplate 产品物模型
     * @return 结果
     */
    @Override
    public int insertProductTemplates(ProductTemplate productTemplate)
    {
        productTemplate.setCreateTime(DateUtils.getNowDate());
        return productTemplatesMapper.insertProductTemplates(productTemplate);
    }

    /**
     * 导入产品物模型数据
     *
     * @param productTemplateList 产品物模型数据列表
     * @param isUpdateSupport 是否更新已存在的产品物模型
     * @param operName 操作用户
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importProductTemplates(List<ProductTemplate> productTemplateList, boolean isUpdateSupport, String operName)
    {
        if (StringUtils.isNull(productTemplateList) || productTemplateList.isEmpty())
        {
            throw new ServiceException("导入产品物模型数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (ProductTemplate productTemplate : productTemplateList)
        {
            try
            {
                if (StringUtils.isEmpty(productTemplate.getId()))
                {
                    productTemplate.setId(IdUtil.getSnowflakeNextIdStr());
                    productTemplate.setCreateBy(operName);
                    insertProductTemplates(productTemplate);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、产品物模型 " + productTemplate.getName() + " 导入成功");
                    continue;
                }

                ProductTemplate oldProductTemplate = productTemplatesMapper.selectProductTemplatesById(productTemplate.getId());
                if (StringUtils.isNull(oldProductTemplate))
                {
                    productTemplate.setCreateBy(operName);
                    insertProductTemplates(productTemplate);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、产品物模型 " + productTemplate.getName() + " 导入成功");
                }
                else if (isUpdateSupport)
                {
                    productTemplate.setUpdateBy(operName);
                    // 更新走自调用，@CacheEvict 不会生效，需手动清理缓存，与 deleteByProductId 等批量方法保持一致
                    cacheManager.getCache("productTemplateCaches").evict(productTemplate.getId());
                    updateProductTemplates(productTemplate);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、产品物模型 " + productTemplate.getName() + " 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、产品物模型 " + productTemplate.getName() + " 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                failureMsg.append("<br/>" + failureNum + "、产品物模型 " + productTemplate.getName() + " 导入失败：" + e.getMessage());
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

    /**
     * 修改产品物模型
     *
     * @param productTemplate 产品物模型
     * @return 结果
     */
    @CacheEvict(key = "#productTemplate.id")
    @Override
    public int updateProductTemplates(ProductTemplate productTemplate)
    {
        productTemplate.setUpdateTime(DateUtils.getNowDate());
        return productTemplatesMapper.updateProductTemplates(productTemplate);
    }

    /**
     * 批量删除产品物模型
     * 
     * @param ids 需要删除的产品物模型主键
     * @return 结果
     */
    @Override
    public int deleteProductTemplatesByIds(String[] ids)
    {
        for (String id : ids) {
            cacheManager.getCache("productTemplateCaches").evict(id);
        }
        return productTemplatesMapper.deleteProductTemplatesByIds(ids);
    }

    /**
     * 删除产品物模型信息
     * 
     * @param id 产品物模型主键
     * @return 结果
     */
    @CacheEvict(key = "#id")
    @Override
    public int deleteProductTemplatesById(String id)
    {
        return productTemplatesMapper.deleteProductTemplatesById(id);
    }
}
