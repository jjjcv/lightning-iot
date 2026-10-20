package com.ruoyi.iot.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.TransparentCodecMapper;
import com.ruoyi.iot.domain.TransparentCodec;
import com.ruoyi.iot.service.ITransparentCodecService;

/**
 * 透传消息解析器Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
@Service
public class TransparentCodecServiceImpl implements ITransparentCodecService 
{
    @Autowired
    private TransparentCodecMapper transparentCodecMapper;

    /**
     * 查询透传消息解析器
     * 
     * @param id 透传消息解析器主键
     * @return 透传消息解析器
     */
    @Override
    public TransparentCodec selectTransparentCodecById(String id)
    {
        return transparentCodecMapper.selectTransparentCodecById(id);
    }

    /**
     * 查询透传消息解析器列表
     * 
     * @param transparentCodec 透传消息解析器
     * @return 透传消息解析器
     */
    @Override
    public List<TransparentCodec> selectTransparentCodecList(TransparentCodec transparentCodec)
    {
        return transparentCodecMapper.selectTransparentCodecList(transparentCodec);
    }

    /**
     * 新增透传消息解析器
     * 
     * @param transparentCodec 透传消息解析器
     * @return 结果
     */
    @Override
    public int insertTransparentCodec(TransparentCodec transparentCodec)
    {
        transparentCodec.setCreateTime(DateUtils.getNowDate());
        return transparentCodecMapper.insertTransparentCodec(transparentCodec);
    }

    /**
     * 修改透传消息解析器
     * 
     * @param transparentCodec 透传消息解析器
     * @return 结果
     */
    @Override
    public int updateTransparentCodec(TransparentCodec transparentCodec)
    {
        transparentCodec.setUpdateTime(DateUtils.getNowDate());
        return transparentCodecMapper.updateTransparentCodec(transparentCodec);
    }

    /**
     * 批量删除透传消息解析器
     * 
     * @param ids 需要删除的透传消息解析器主键
     * @return 结果
     */
    @Override
    public int deleteTransparentCodecByIds(String[] ids)
    {
        return transparentCodecMapper.deleteTransparentCodecByIds(ids);
    }

    /**
     * 删除透传消息解析器信息
     * 
     * @param id 透传消息解析器主键
     * @return 结果
     */
    @Override
    public int deleteTransparentCodecById(String id)
    {
        return transparentCodecMapper.deleteTransparentCodecById(id);
    }
}
