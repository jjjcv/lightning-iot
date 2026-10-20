package com.ruoyi.iot.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.UnitMapper;
import com.ruoyi.iot.domain.Unit;
import com.ruoyi.iot.service.IUnitService;

/**
 * 单位信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-08-28
 */
@Service
public class UnitServiceImpl implements IUnitService 
{
    @Autowired
    private UnitMapper unitMapper;

    /**
     * 查询单位信息
     * 
     * @param id 单位信息主键
     * @return 单位信息
     */
    @Override
    public Unit selectUnitById(Long id)
    {
        return unitMapper.selectUnitById(id);
    }

    /**
     * 查询单位信息列表
     * 
     * @param unit 单位信息
     * @return 单位信息
     */
    @Override
    public List<Unit> selectUnitList(Unit unit)
    {
        return unitMapper.selectUnitList(unit);
    }

    /**
     * 新增单位信息
     * 
     * @param unit 单位信息
     * @return 结果
     */
    @Override
    public int insertUnit(Unit unit)
    {
        return unitMapper.insertUnit(unit);
    }

    /**
     * 修改单位信息
     * 
     * @param unit 单位信息
     * @return 结果
     */
    @Override
    public int updateUnit(Unit unit)
    {
        return unitMapper.updateUnit(unit);
    }

    /**
     * 批量删除单位信息
     * 
     * @param ids 需要删除的单位信息主键
     * @return 结果
     */
    @Override
    public int deleteUnitByIds(Long[] ids)
    {
        return unitMapper.deleteUnitByIds(ids);
    }

    /**
     * 删除单位信息信息
     * 
     * @param id 单位信息主键
     * @return 结果
     */
    @Override
    public int deleteUnitById(Long id)
    {
        return unitMapper.deleteUnitById(id);
    }
}
