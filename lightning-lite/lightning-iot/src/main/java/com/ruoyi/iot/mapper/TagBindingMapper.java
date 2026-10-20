package com.ruoyi.iot.mapper;

import com.ruoyi.iot.domain.TagBinding;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface TagBindingMapper {
    String lockObject(@Param("objectType") String objectType, @Param("objectId") String objectId);
    List<Long> lockTags(@Param("tagIds") List<Long> tagIds);
    List<TagBinding> selectBindings(@Param("objectType") String objectType, @Param("objectIds") List<String> objectIds);
    int deleteObjectBindings(@Param("objectType") String objectType, @Param("objectId") String objectId);
    int insertBindings(@Param("objectType") String objectType, @Param("objectId") String objectId, @Param("tagIds") List<Long> tagIds);
    int deleteProductBindingsByTagIds(@Param("tagIds") List<Long> tagIds);
    int deleteDeviceBindingsByTagIds(@Param("tagIds") List<Long> tagIds);
}
