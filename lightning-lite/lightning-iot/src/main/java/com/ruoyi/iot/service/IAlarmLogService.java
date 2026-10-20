package com.ruoyi.iot.service;

import java.util.List;
import com.ruoyi.iot.domain.AlarmLog;

/**
 * 告警记录Service接口
 * 
 * @author ruoyi
 * @date 2025-09-10
 */
public interface IAlarmLogService 
{
    /**
     * 查询告警记录
     * 
     * @param id 告警记录主键
     * @return 告警记录
     */
    public AlarmLog selectAlarmLogById(Long id);

    /**
     * 查询告警记录列表
     * 
     * @param alarmLog 告警记录
     * @return 告警记录集合
     */
    public List<AlarmLog> selectAlarmLogList(AlarmLog alarmLog);

    /**
     * 新增告警记录
     * 
     * @param alarmLog 告警记录
     * @return 结果
     */
    public int insertAlarmLog(AlarmLog alarmLog);

    /**
     * 修改告警记录
     * 
     * @param alarmLog 告警记录
     * @return 结果
     */
    public int updateAlarmLog(AlarmLog alarmLog);

    /**
     * 批量删除告警记录
     * 
     * @param ids 需要删除的告警记录主键集合
     * @return 结果
     */
    public int deleteAlarmLogByIds(Long[] ids);

    /**
     * 删除告警记录信息
     * 
     * @param id 告警记录主键
     * @return 结果
     */
    public int deleteAlarmLogById(Long id);
}
