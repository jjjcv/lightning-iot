package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.ProductTemplate;
import com.ruoyi.iot.metadata.PropertyMetadata;

/**
 * 产品物模型Service接口
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
public interface IProductTemplatesService
{
    int deleteByProductId(String productId);

    /**
     * 查询产品物模型
     * 
     * @param id 产品物模型主键
     * @return 产品物模型
     */
    public ProductTemplate selectProductTemplatesById(String id);

    PropertyMetadata selectPropertyMetadataById(String id);

    /**
     * 查询产品物模型列表
     * 
     * @param productTemplate 产品物模型
     * @return 产品物模型集合
     */
    public List<ProductTemplate> selectProductTemplatesList(ProductTemplate productTemplate);

    /**
     * 新增产品物模型
     * 
     * @param productTemplate 产品物模型
     * @return 结果
     */
    public int insertProductTemplates(ProductTemplate productTemplate);

    /**
     * 修改产品物模型
     * 
     * @param productTemplate 产品物模型
     * @return 结果
     */
    public int updateProductTemplates(ProductTemplate productTemplate);

    /**
     * 批量删除产品物模型
     * 
     * @param ids 需要删除的产品物模型主键集合
     * @return 结果
     */
    public int deleteProductTemplatesByIds(String[] ids);

    /**
     * 删除产品物模型信息
     * 
     * @param id 产品物模型主键
     * @return 结果
     */

    public int deleteProductTemplatesById(String id);

    /**
     * 导入产品物模型数据
     *
     * @param productTemplateList 产品物模型数据列表
     * @param isUpdateSupport 是否更新已存在的产品物模型
     * @param operName 操作用户
     * @return 结果
     */
    public String importProductTemplates(List<ProductTemplate> productTemplateList, boolean isUpdateSupport, String operName);
}
