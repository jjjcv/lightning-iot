package com.ruoyi.iot.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.iot.mapper.TagDetailMapper;
import com.ruoyi.iot.mapper.TagBindingMapper;
import com.ruoyi.iot.domain.TagDetail;
import com.ruoyi.iot.domain.TagDeviceStatistics;
import com.ruoyi.iot.util.TagUtils;
import com.ruoyi.iot.service.ITagDetailService;
import com.ruoyi.iot.service.ConnectionStatusStore;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TagDetailServiceImpl implements ITagDetailService {
    private final TagDetailMapper tagDetailMapper;
    private final TagBindingMapper tagBindingMapper;
    private final ConnectionStatusStore connectionStatusStore;
    public TagDetailServiceImpl(TagDetailMapper tagDetailMapper, TagBindingMapper tagBindingMapper,
                               ConnectionStatusStore connectionStatusStore) {
        this.tagDetailMapper = tagDetailMapper;
        this.tagBindingMapper = tagBindingMapper;
        this.connectionStatusStore = connectionStatusStore;
    }
    @Override
    public TagDeviceStatistics selectDeviceStatisticsByTagId(Long tagId) {
        if (tagId == null || tagId <= 0) { throw new ServiceException("标签 ID 必须为正整数"); }
        if (tagDetailMapper.selectTagDetailByTagId(tagId) == null) {
            throw new ServiceException("标签不存在或已删除");
        }
        List<String> deviceIds = tagDetailMapper.selectDeviceIdsByTagId(tagId);
        long total = deviceIds.size();
        long online = connectionStatusStore.countOnlineDevices(deviceIds);
        TagDeviceStatistics statistics = new TagDeviceStatistics();
        statistics.setTotal(total);
        statistics.setOnline(online);
        statistics.setOffline(Math.max(0L, total - online));
        return statistics;
    }

    @Override
    public TagDetail selectTagDetailByTagId(Long tagId) { return tagDetailMapper.selectTagDetailByTagId(tagId); }
    @Override
    public List<TagDetail> selectTagDetailList(TagDetail tagDetail) { return tagDetailMapper.selectTagDetailList(tagDetail); }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertTagDetail(TagDetail tagDetail) {
        tagDetail.setTagId(null);
        validate(tagDetail);
        tagDetail.setCreateTime(DateUtils.getNowDate());
        tagDetail.setCreateBy(SecurityUtils.getUsername());
        try { return tagDetailMapper.insertTagDetail(tagDetail); }
        catch (DuplicateKeyException ex) { throw new ServiceException("标签名称已存在"); }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateTagDetail(TagDetail tagDetail) {
        if (tagDetail.getTagId() == null || tagDetail.getTagId() <= 0
            || tagBindingMapper.lockTags(List.of(tagDetail.getTagId())).isEmpty()) {
            throw new ServiceException("标签不存在或已删除");
        }
        validate(tagDetail);
        tagDetail.setUpdateTime(DateUtils.getNowDate());
        tagDetail.setUpdateBy(SecurityUtils.getUsername());
        // 创建者和创建时间不允许通过修改接口覆盖。
        tagDetail.setCreateBy(null);
        tagDetail.setCreateTime(null);
        try { return tagDetailMapper.updateTagDetail(tagDetail); }
        catch (DuplicateKeyException ex) { throw new ServiceException("标签名称已存在"); }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTagDetailByTagIds(Long[] tagIds) {
        if (tagIds == null || tagIds.length == 0) { throw new ServiceException("请选择要删除的标签"); }
        List<Long> ids = TagUtils.normalizeIds(Arrays.asList(tagIds));
        tagBindingMapper.lockTags(ids);
        tagBindingMapper.deleteProductBindingsByTagIds(ids);
        tagBindingMapper.deleteDeviceBindingsByTagIds(ids);
        return tagDetailMapper.deleteTagDetailByTagIds(ids.toArray(Long[]::new));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTagDetailByTagId(Long tagId) { return deleteTagDetailByTagIds(new Long[]{tagId}); }

    private void validate(TagDetail tag) {
        String name = tag.getTagName() == null ? "" : tag.getTagName().strip();
        if (name.isEmpty() || name.length() > 64) { throw new ServiceException("标签名称不能为空，且不能超过 64 个字符"); }
        tag.setTagName(name);
        checkLength(tag.getDescription(), 255, "标签描述");
        checkLength(tag.getTagType(), 100, "标签类型");
        checkLength(tag.getCssClass(), 100, "样式属性");
        checkLength(tag.getRemark(), 500, "备注");
        Long existingId = tagDetailMapper.selectTagIdByName(name);
        if (existingId != null && !Objects.equals(existingId, tag.getTagId())) { throw new ServiceException("标签名称已存在"); }
    }
    private void checkLength(String value, int max, String field) {
        if (value != null && value.length() > max) { throw new ServiceException(field + "不能超过 " + max + " 个字符"); }
    }
}
