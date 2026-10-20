package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.TransparentCodec;

/**
 * 透传消息解析器Service接口
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
public interface ITransparentCodecService 
{
    /**
     * 查询透传消息解析器
     * 
     * @param id 透传消息解析器主键
     * @return 透传消息解析器
     */
    public TransparentCodec selectTransparentCodecById(String id);

    /**
     * 查询透传消息解析器列表
     * 
     * @param transparentCodec 透传消息解析器
     * @return 透传消息解析器集合
     */
    public List<TransparentCodec> selectTransparentCodecList(TransparentCodec transparentCodec);

    /**
     * 新增透传消息解析器
     * 
     * @param transparentCodec 透传消息解析器
     * @return 结果
     */
    public int insertTransparentCodec(TransparentCodec transparentCodec);

    /**
     * 修改透传消息解析器
     * 
     * @param transparentCodec 透传消息解析器
     * @return 结果
     */
    public int updateTransparentCodec(TransparentCodec transparentCodec);

    /**
     * 批量删除透传消息解析器
     * 
     * @param ids 需要删除的透传消息解析器主键集合
     * @return 结果
     */
    public int deleteTransparentCodecByIds(String[] ids);

    /**
     * 删除透传消息解析器信息
     * 
     * @param id 透传消息解析器主键
     * @return 结果
     */
    public int deleteTransparentCodecById(String id);
}
