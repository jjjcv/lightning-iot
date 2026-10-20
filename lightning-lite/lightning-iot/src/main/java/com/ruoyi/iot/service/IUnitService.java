package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.Unit;

/**
 * 单位信息Service接口
 * 
 * @author ruoyi
 * @date 2025-08-28
 */
public interface IUnitService 
{
    /**
     * 查询单位信息
     * 
     * @param id 单位信息主键
     * @return 单位信息
     */
    public Unit selectUnitById(Long id);

    /**
     * 查询单位信息列表
     * 
     * @param unit 单位信息
     * @return 单位信息集合
     */
    public List<Unit> selectUnitList(Unit unit);

    /**
     * 新增单位信息
     * 
     * @param unit 单位信息
     * @return 结果
     */
    public int insertUnit(Unit unit);

    /**
     * 修改单位信息
     * 
     * @param unit 单位信息
     * @return 结果
     */
    public int updateUnit(Unit unit);

    /**
     * 批量删除单位信息
     * 
     * @param ids 需要删除的单位信息主键集合
     * @return 结果
     */
    public int deleteUnitByIds(Long[] ids);

    /**
     * 删除单位信息信息
     * 
     * @param id 单位信息主键
     * @return 结果
     */
    public int deleteUnitById(Long id);
}
