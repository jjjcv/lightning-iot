package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.TagDetail;
import com.ruoyi.iot.domain.TagDeviceStatistics;

/**
 * 标签详情Service接口
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
public interface ITagDetailService
{
    /** 按标签统计设备总数、在线数、离线数。 */
    TagDeviceStatistics selectDeviceStatisticsByTagId(Long tagId);

    /**
     * 查询标签详情
     * 
     * @param tagId 标签详情主键
     * @return 标签详情
     */
    public TagDetail selectTagDetailByTagId(Long tagId);

    /**
     * 查询标签详情列表
     * 
     * @param tagDetail 标签详情
     * @return 标签详情集合
     */
    public List<TagDetail> selectTagDetailList(TagDetail tagDetail);

    /**
     * 新增标签详情
     * 
     * @param tagDetail 标签详情
     * @return 结果
     */
    public int insertTagDetail(TagDetail tagDetail);

    /**
     * 修改标签详情
     * 
     * @param tagDetail 标签详情
     * @return 结果
     */
    public int updateTagDetail(TagDetail tagDetail);

    /**
     * 批量删除标签详情
     * 
     * @param tagIds 需要删除的标签详情主键集合
     * @return 结果
     */
    public int deleteTagDetailByTagIds(Long[] tagIds);

    /**
     * 删除标签详情信息
     * 
     * @param tagId 标签详情主键
     * @return 结果
     */
    public int deleteTagDetailByTagId(Long tagId);
}
