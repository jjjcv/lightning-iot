package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.TagDetail;

/**
 * 标签详情Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
public interface TagDetailMapper
{
    /** 仅查询标签直接关联且仍存在的设备，连接状态由 Redis 提供。 */
    List<String> selectDeviceIdsByTagId(Long tagId);

    Long selectTagIdByName(String tagName);
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
     * 删除标签详情
     * 
     * @param tagId 标签详情主键
     * @return 结果
     */
    public int deleteTagDetailByTagId(Long tagId);

    /**
     * 批量删除标签详情
     * 
     * @param tagIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTagDetailByTagIds(Long[] tagIds);
}
