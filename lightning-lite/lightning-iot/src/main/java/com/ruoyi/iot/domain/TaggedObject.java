package com.ruoyi.iot.domain;

import java.util.List;

/** 产品和设备的基础标签信息。 */
public interface TaggedObject {
    String getId();
    List<Long> getTagIds();
    void setTagIds(List<Long> tagIds);
    void setTags(List<TagDetail> tags);
}
