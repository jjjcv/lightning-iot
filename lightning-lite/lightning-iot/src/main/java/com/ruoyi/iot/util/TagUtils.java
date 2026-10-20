package com.ruoyi.iot.util;

import com.ruoyi.common.exception.ServiceException;
import java.util.List;

public final class TagUtils {
    private TagUtils() { }
    public static List<Long> normalizeIds(List<Long> tagIds) {
        if (tagIds.size() > 100 || tagIds.stream().anyMatch(id -> id == null || id <= 0)) {
            throw new ServiceException("标签 ID 必须为正整数，最多选择 100 个标签");
        }
        return tagIds.stream().distinct().sorted().toList();
    }
}
