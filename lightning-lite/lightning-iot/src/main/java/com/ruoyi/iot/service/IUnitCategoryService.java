package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.UnitCategory;

/**
 * 单位类型Service接口
 * 
 * @author ruoyi
 * @date 2025-08-28
 */
public interface IUnitCategoryService 
{
    /**
     * 查询单位类型
     * 
     * @param id 单位类型主键
     * @return 单位类型
     */
    public UnitCategory selectUnitCategoryById(Long id);

    /**
     * 查询单位类型列表
     * 
     * @param unitCategory 单位类型
     * @return 单位类型集合
     */
    public List<UnitCategory> selectUnitCategoryList(UnitCategory unitCategory);

    /**
     * 新增单位类型
     * 
     * @param unitCategory 单位类型
     * @return 结果
     */
    public int insertUnitCategory(UnitCategory unitCategory);

    /**
     * 修改单位类型
     * 
     * @param unitCategory 单位类型
     * @return 结果
     */
    public int updateUnitCategory(UnitCategory unitCategory);

    /**
     * 批量删除单位类型
     * 
     * @param ids 需要删除的单位类型主键集合
     * @return 结果
     */
    public int deleteUnitCategoryByIds(Long[] ids);

    /**
     * 删除单位类型信息
     * 
     * @param id 单位类型主键
     * @return 结果
     */
    public int deleteUnitCategoryById(Long id);
}
