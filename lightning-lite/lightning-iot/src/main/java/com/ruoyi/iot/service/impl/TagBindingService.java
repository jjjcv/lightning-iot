package com.ruoyi.iot.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.iot.domain.TagBinding;
import com.ruoyi.iot.domain.TagDetail;
import com.ruoyi.iot.domain.TaggedObject;
import com.ruoyi.iot.mapper.TagBindingMapper;
import com.ruoyi.iot.util.TagUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

/** 只负责对象与标签的关联，不参与设备运行和规则联动。 */
@Service
public class TagBindingService {
    private final TagBindingMapper mapper;
    public TagBindingService(TagBindingMapper mapper) { this.mapper = mapper; }

    @Transactional(rollbackFor = Exception.class)
    public void replaceTags(String objectType, String objectId, List<Long> tagIds) {
        checkType(objectType);
        if (tagIds == null) { return; }
        List<Long> ids = TagUtils.normalizeIds(tagIds);
        if (mapper.lockObject(objectType, objectId) == null) {
            throw new ServiceException("product".equals(objectType) ? "产品不存在" : "设备不存在");
        }
        // 与标签删除共用标签行锁，避免校验后标签被删除，产生悬空关联。
        if (!ids.isEmpty() && mapper.lockTags(ids).size() != ids.size()) {
            throw new ServiceException("所选标签不存在或已删除，请刷新后重试");
        }
        mapper.deleteObjectBindings(objectType, objectId);
        if (!ids.isEmpty()) { mapper.insertBindings(objectType, objectId, ids); }
    }

    @Transactional(rollbackFor = Exception.class)
    public void removeObjectTags(String objectType, String objectId) {
        checkType(objectType);
        mapper.lockObject(objectType, objectId);
        mapper.deleteObjectBindings(objectType, objectId);
    }

    public void fillTags(String objectType, List<? extends TaggedObject> objects) {
        checkType(objectType);
        List<String> ids = objects.stream().map(TaggedObject::getId).filter(Objects::nonNull).distinct().toList();
        if (ids.isEmpty()) { return; }
        Map<String, List<TagDetail>> grouped = new HashMap<>();
        // 分批加载，避免逐行查询，也避免全量接口生成过大的 IN 子句。
        for (int offset = 0; offset < ids.size(); offset += 500) {
            for (TagBinding binding : mapper.selectBindings(objectType, ids.subList(offset, Math.min(offset + 500, ids.size())))) {
                TagDetail tag = new TagDetail();
                tag.setTagId(binding.getTagId());
                tag.setTagName(binding.getTagName());
                grouped.computeIfAbsent(binding.getObjectId(), key -> new ArrayList<>()).add(tag);
            }
        }
        for (TaggedObject object : objects) {
            List<TagDetail> tags = grouped.getOrDefault(object.getId(), List.of());
            object.setTags(tags);
            object.setTagIds(tags.stream().map(TagDetail::getTagId).toList());
        }
    }

    private void checkType(String type) {
        if (!"product".equals(type) && !"device".equals(type)) { throw new ServiceException("不支持的标签关联对象"); }
    }
}
