package com.ruoyi.iot.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.BuildingsMapper;
import com.ruoyi.iot.domain.Buildings;
import com.ruoyi.iot.service.IBuildingsService;

/**
 * 建筑基础信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-08-26
 */
@Service
public class BuildingsServiceImpl implements IBuildingsService 
{
    @Autowired
    private BuildingsMapper buildingsMapper;

    /**
     * 查询建筑基础信息
     * 
     * @param id 建筑基础信息主键
     * @return 建筑基础信息
     */
    @Override
    public Buildings selectBuildingsById(Long id)
    {
        return buildingsMapper.selectBuildingsById(id);
    }

    /**
     * 查询建筑基础信息列表
     * 
     * @param buildings 建筑基础信息
     * @return 建筑基础信息
     */
    @Override
    public List<Buildings> selectBuildingsList(Buildings buildings)
    {
        return buildingsMapper.selectBuildingsList(buildings);
    }

    /**
     * 新增建筑基础信息
     * 
     * @param buildings 建筑基础信息
     * @return 结果
     */
    @Override
    public int insertBuildings(Buildings buildings)
    {
        validate(buildings);
        buildings.setCreateTime(DateUtils.getNowDate());
        return buildingsMapper.insertBuildings(buildings);
    }

    /**
     * 修改建筑基础信息
     * 
     * @param buildings 建筑基础信息
     * @return 结果
     */
    @Override
    public int updateBuildings(Buildings buildings)
    {
        validate(buildings);
        buildings.setUpdateTime(DateUtils.getNowDate());
        return buildingsMapper.updateBuildings(buildings);
    }

    /**
     * 批量删除建筑基础信息
     * 
     * @param ids 需要删除的建筑基础信息主键
     * @return 结果
     */
    @Override
    public int deleteBuildingsByIds(Long[] ids)
    {
        return buildingsMapper.deleteBuildingsByIds(ids);
    }

    /**
     * 删除建筑基础信息信息
     * 
     * @param id 建筑基础信息主键
     * @return 结果
     */
    @Override
    public int deleteBuildingsById(Long id)
    {
        return buildingsMapper.deleteBuildingsById(id);
    }

    private void validate(Buildings building) {
        if (building.getBuildingCode() == null || building.getBuildingCode().isBlank()
                || building.getBuildingName() == null || building.getBuildingName().isBlank()) {
            throw new IllegalArgumentException("buildingCode and buildingName are required");
        }
        if (building.getTotalArea() != null && building.getTotalArea().signum() < 0) {
            throw new IllegalArgumentException("totalArea cannot be negative");
        }
        if (building.getAirConditioningArea() != null && building.getAirConditioningArea().signum() < 0) {
            throw new IllegalArgumentException("airConditioningArea cannot be negative");
        }
        if (building.getPersonnelCount() != null && building.getPersonnelCount() < 0) {
            throw new IllegalArgumentException("personnelCount cannot be negative");
        }
    }
}
