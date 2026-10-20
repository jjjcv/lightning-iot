package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.TransportProtocol;

/**
 * 传输协议Mapper接口
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
public interface TransportProtocolMapper 
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
     * 删除传输协议
     * 
     * @param id 传输协议主键
     * @return 结果
     */
    public int deleteTransportProtocolById(String id);

    /**
     * 批量删除传输协议
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTransportProtocolByIds(String[] ids);
}
