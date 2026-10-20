package com.ruoyi.iot.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.TransportProtocolMapper;
import com.ruoyi.iot.domain.TransportProtocol;
import com.ruoyi.iot.service.ITransportProtocolService;

/**
 * 传输协议Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
@Service
public class TransportProtocolServiceImpl implements ITransportProtocolService 
{
    @Autowired
    private TransportProtocolMapper transportProtocolMapper;

    /**
     * 查询传输协议
     * 
     * @param id 传输协议主键
     * @return 传输协议
     */
    @Override
    public TransportProtocol selectTransportProtocolById(String id)
    {
        return transportProtocolMapper.selectTransportProtocolById(id);
    }

    /**
     * 查询传输协议列表
     * 
     * @param transportProtocol 传输协议
     * @return 传输协议
     */
    @Override
    public List<TransportProtocol> selectTransportProtocolList(TransportProtocol transportProtocol)
    {
        return transportProtocolMapper.selectTransportProtocolList(transportProtocol);
    }

    /**
     * 新增传输协议
     * 
     * @param transportProtocol 传输协议
     * @return 结果
     */
    @Override
    public int insertTransportProtocol(TransportProtocol transportProtocol)
    {
        transportProtocol.setCreateTime(DateUtils.getNowDate());
        return transportProtocolMapper.insertTransportProtocol(transportProtocol);
    }

    /**
     * 修改传输协议
     * 
     * @param transportProtocol 传输协议
     * @return 结果
     */
    @Override
    public int updateTransportProtocol(TransportProtocol transportProtocol)
    {
        transportProtocol.setUpdateTime(DateUtils.getNowDate());
        return transportProtocolMapper.updateTransportProtocol(transportProtocol);
    }

    /**
     * 批量删除传输协议
     * 
     * @param ids 需要删除的传输协议主键
     * @return 结果
     */
    @Override
    public int deleteTransportProtocolByIds(String[] ids)
    {
        return transportProtocolMapper.deleteTransportProtocolByIds(ids);
    }

    /**
     * 删除传输协议信息
     * 
     * @param id 传输协议主键
     * @return 结果
     */
    @Override
    public int deleteTransportProtocolById(String id)
    {
        return transportProtocolMapper.deleteTransportProtocolById(id);
    }
}
