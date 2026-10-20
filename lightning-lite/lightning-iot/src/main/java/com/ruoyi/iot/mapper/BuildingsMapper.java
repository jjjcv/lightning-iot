package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.Buildings;

/**
 * 建筑基础信息Mapper接口
 * 
 * @author ruoyi
 * @date 2025-08-26
 */
public interface BuildingsMapper 
{
    /**
     * 查询建筑基础信息
     * 
     * @param id 建筑基础信息主键
     * @return 建筑基础信息
     */
    public Buildings selectBuildingsById(Long id);

    /**
     * 查询建筑基础信息列表
     * 
     * @param buildings 建筑基础信息
     * @return 建筑基础信息集合
     */
    public List<Buildings> selectBuildingsList(Buildings buildings);

    /**
     * 新增建筑基础信息
     * 
     * @param buildings 建筑基础信息
     * @return 结果
     */
    public int insertBuildings(Buildings buildings);

    /**
     * 修改建筑基础信息
     * 
     * @param buildings 建筑基础信息
     * @return 结果
     */
    public int updateBuildings(Buildings buildings);

    /**
     * 删除建筑基础信息
     * 
     * @param id 建筑基础信息主键
     * @return 结果
     */
    public int deleteBuildingsById(Long id);

    /**
     * 批量删除建筑基础信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBuildingsByIds(Long[] ids);
}
