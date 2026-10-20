package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.TransportProtocol;

/**
 * 传输协议Service接口
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
public interface ITransportProtocolService 
{
    /**
     * 查询传输协议
     * 
     * @param id 传输协议主键
     * @return 传输协议
     */
    public TransportProtocol selectTransportProtocolById(String id);

    /**
     * 查询传输协议列表
     * 
     * @param transportProtocol 传输协议
     * @return 传输协议集合
     */
    public List<TransportProtocol> selectTransportProtocolList(TransportProtocol transportProtocol);

    /**
     * 新增传输协议
     * 
     * @param transportProtocol 传输协议
     * @return 结果
     */
    public int insertTransportProtocol(TransportProtocol transportProtocol);

    /**
     * 修改传输协议
     * 
     * @param transportProtocol 传输协议
     * @return 结果
     */
    public int updateTransportProtocol(TransportProtocol transportProtocol);

    /**
     * 批量删除传输协议
     * 
     * @param ids 需要删除的传输协议主键集合
     * @return 结果
     */
    public int deleteTransportProtocolByIds(String[] ids);

    /**
     * 删除传输协议信息
     * 
     * @param id 传输协议主键
     * @return 结果
     */
    public int deleteTransportProtocolById(String id);
}
