package com.ruoyi.iot.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.UnitCategoryMapper;
import com.ruoyi.iot.domain.UnitCategory;
import com.ruoyi.iot.service.IUnitCategoryService;

/**
 * 单位类型Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-08-28
 */
@Service
public class UnitCategoryServiceImpl implements IUnitCategoryService 
{
    @Autowired
    private UnitCategoryMapper unitCategoryMapper;

    /**
     * 查询单位类型
     * 
     * @param id 单位类型主键
     * @return 单位类型
     */
    @Override
    public UnitCategory selectUnitCategoryById(Long id)
    {
        return unitCategoryMapper.selectUnitCategoryById(id);
    }

    /**
     * 查询单位类型列表
     * 
     * @param unitCategory 单位类型
     * @return 单位类型
     */
    @Override
    public List<UnitCategory> selectUnitCategoryList(UnitCategory unitCategory)
    {
        return unitCategoryMapper.selectUnitCategoryList(unitCategory);
    }

    /**
     * 新增单位类型
     * 
     * @param unitCategory 单位类型
     * @return 结果
     */
    @Override
    public int insertUnitCategory(UnitCategory unitCategory)
    {
        return unitCategoryMapper.insertUnitCategory(unitCategory);
    }

    /**
     * 修改单位类型
     * 
     * @param unitCategory 单位类型
     * @return 结果
     */
    @Override
    public int updateUnitCategory(UnitCategory unitCategory)
    {
        return unitCategoryMapper.updateUnitCategory(unitCategory);
    }

    /**
     * 批量删除单位类型
     * 
     * @param ids 需要删除的单位类型主键
     * @return 结果
     */
    @Override
    public int deleteUnitCategoryByIds(Long[] ids)
    {
        return unitCategoryMapper.deleteUnitCategoryByIds(ids);
    }

    /**
     * 删除单位类型信息
     * 
     * @param id 单位类型主键
     * @return 结果
     */
    @Override
    public int deleteUnitCategoryById(Long id)
    {
        return unitCategoryMapper.deleteUnitCategoryById(id);
    }
}
