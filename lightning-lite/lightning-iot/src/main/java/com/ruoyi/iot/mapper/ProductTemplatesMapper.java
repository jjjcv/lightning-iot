package com.ruoyi.iot.mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import com.ruoyi.iot.domain.ProductTemplate;

/**
 * 产品物模型Mapper接口
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
public interface ProductTemplatesMapper 
{

    /**
     * 批量删除产品物模型
     *
     * @param productId 产品物模型主键
     * @return 影响行数
     */
    public int deleteByProductId(@Param("productId") String productId);
    /**
     * 查询产品物模型
     * 
     * @param id 产品物模型主键
     * @return 产品物模型
     */
    public ProductTemplate selectProductTemplatesById(String id);

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
     * 删除产品物模型
     * 
     * @param id 产品物模型主键
     * @return 结果
     */
    public int deleteProductTemplatesById(String id);

    /**
     * 批量删除产品物模型
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductTemplatesByIds(String[] ids);
}
