package com.ruoyi.iot.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.AreaMapper;
import com.ruoyi.iot.domain.Area;
import com.ruoyi.iot.service.IAreaService;

/**
 * 区域信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
@Service
public class AreaServiceImpl implements IAreaService 
{
    @Autowired
    private AreaMapper areaMapper;

    /**
     * 查询区域信息
     * 
     * @param id 区域信息主键
     * @return 区域信息
     */
    @Override
    public Area selectAreaById(Long id)
    {
        return areaMapper.selectAreaById(id);
    }

    /**
     * 查询区域信息列表
     * 
     * @param area 区域信息
     * @return 区域信息
     */
    @Override
    public List<Area> selectAreaList(Area area)
    {
        return areaMapper.selectAreaList(area);
    }

    /**
     * 新增区域信息
     * 
     * @param area 区域信息
     * @return 结果
     */
    @Override
    public int insertArea(Area area)
    {
        validateAndBuildAncestors(area);
        area.setCreateTime(DateUtils.getNowDate());
        return areaMapper.insertArea(area);
    }

    /**
     * 修改区域信息
     * 
     * @param area 区域信息
     * @return 结果
     */
    @Override
    public int updateArea(Area area)
    {
        validateAndBuildAncestors(area);
        area.setUpdateTime(DateUtils.getNowDate());
        return areaMapper.updateArea(area);
    }

    /**
     * 批量删除区域信息
     * 
     * @param ids 需要删除的区域信息主键
     * @return 结果
     */
    @Override
    public int deleteAreaByIds(Long[] ids)
    {
        return areaMapper.deleteAreaByIds(ids);
    }

    /**
     * 删除区域信息信息
     * 
     * @param id 区域信息主键
     * @return 结果
     */
    @Override
    public int deleteAreaById(Long id)
    {
        return areaMapper.deleteAreaById(id);
    }

    private void validateAndBuildAncestors(Area area) {
        if (area.getBuildingId() == null || area.getAreaCode() == null || area.getAreaCode().isBlank()
                || area.getAreaName() == null || area.getAreaName().isBlank()) {
            throw new IllegalArgumentException("buildingId, areaCode and areaName are required");
        }
        if (area.getAreaSize() != null && area.getAreaSize().signum() < 0) {
            throw new IllegalArgumentException("areaSize cannot be negative");
        }
        if (area.getPersonnelCount() != null && area.getPersonnelCount() < 0) {
            throw new IllegalArgumentException("personnelCount cannot be negative");
        }
        if (area.getParentAreaId() == null || area.getParentAreaId() == 0) {
            area.setParentAreaId(0L);
            area.setAncestors("0");
            return;
        }
        Area parent = areaMapper.selectAreaById(area.getParentAreaId());
        if (parent == null) throw new IllegalArgumentException("parent area does not exist: " + area.getParentAreaId());
        if (!area.getBuildingId().equals(parent.getBuildingId())) {
            throw new IllegalArgumentException("parent and child areas must belong to the same building");
        }
        Long cursor = parent.getId();
        while (cursor != null && cursor != 0) {
            if (cursor.equals(area.getId())) throw new IllegalArgumentException("area tree cannot contain a cycle");
            Area current = areaMapper.selectAreaById(cursor);
            cursor = current == null ? null : current.getParentAreaId();
        }
        area.setAncestors((parent.getAncestors() == null || parent.getAncestors().isBlank()
                ? "0" : parent.getAncestors()) + "," + parent.getId());
    }
}
