package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.Area;

/**
 * 区域信息Service接口
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
public interface IAreaService 
{
    /**
     * 查询区域信息
     * 
     * @param id 区域信息主键
     * @return 区域信息
     */
    public Area selectAreaById(Long id);

    /**
     * 查询区域信息列表
     * 
     * @param area 区域信息
     * @return 区域信息集合
     */
    public List<Area> selectAreaList(Area area);

    /**
     * 新增区域信息
     * 
     * @param area 区域信息
     * @return 结果
     */
    public int insertArea(Area area);

    /**
     * 修改区域信息
     * 
     * @param area 区域信息
     * @return 结果
     */
    public int updateArea(Area area);

    /**
     * 批量删除区域信息
     * 
     * @param ids 需要删除的区域信息主键集合
     * @return 结果
     */
    public int deleteAreaByIds(Long[] ids);

    /**
     * 删除区域信息信息
     * 
     * @param id 区域信息主键
     * @return 结果
     */
    public int deleteAreaById(Long id);
}
