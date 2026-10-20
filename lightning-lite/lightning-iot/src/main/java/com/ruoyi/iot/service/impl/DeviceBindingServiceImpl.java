package com.ruoyi.iot.service.impl;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.domain.ProductTemplate;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.IEdgeDeviceService;
import com.ruoyi.iot.service.IDevicesService;
import com.ruoyi.iot.service.IProductTemplatesService;
import com.ruoyi.iot.service.IProductsService;
import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.DeviceBindingMapper;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.service.IDeviceBindingService;
import org.springframework.transaction.annotation.Transactional;

/**
 * 设备属性模板Service业务层处理
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@CacheConfig(cacheNames = "deviceBindingCaches")
@Service
public class DeviceBindingServiceImpl implements IDeviceBindingService {

    private static final Logger log = LoggerFactory.getLogger(DeviceBindingServiceImpl.class);

    @Autowired
    private DeviceBindingMapper deviceBindingMapper;

    @Autowired
    private CacheManager cacheManager;

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private IEdgeDeviceService edgeDeviceService;

    @Autowired
    private IEdgeDataPointService edgeDataPointService;

    @Lazy
    @Autowired
    private IDevicesService devicesService;

    @Autowired
    private IProductTemplatesService productTemplatesService;

    @Autowired
    private IProductsService productsService;


    //数据已经持久在redis中
    @Override
    public void updateValueBatchById(List<DeviceBinding> deviceBindingList) {

        List<DeviceBinding> bindings = deviceBindingList.stream().map(deviceBinding -> {
            cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
            DeviceBinding binding = new DeviceBinding();
            binding.setId(deviceBinding.getId());
            binding.setValue(String.valueOf(deviceBinding.getValue()));
            binding.setLastTime(deviceBinding.getLastTime());
            return binding;
        }).collect(Collectors.toList());

        int batchSize = 500;
        for (int i = 0; i < bindings.size(); i += batchSize) {
            List<DeviceBinding> batchList = bindings.subList(i, Math.min(i + batchSize, bindings.size()));
            deviceBindingMapper.updateValueBatchById(batchList);
        }

    }

    @Override
    public void putValue(DeviceBinding deviceBinding) {
        String key = "deviceBinding:" + deviceBinding.getId();
        DEVICE_BINDING_ID_TO_VALUE.put(key, deviceBinding);
        redisTemplate.opsForValue().set(key, deviceBinding);

        String key2= "deviceBinding:" + deviceBinding.getProductId() + ":" + deviceBinding.getDeviceId() + ":" + deviceBinding.getTelemetryKey();
        DEVICE_BINDING_TO_VALUE.put(key2, deviceBinding);
        redisTemplate.opsForValue().set(key2, deviceBinding);
    }


    @Override
    public DeviceBinding getValue(String id) {
        String key = "deviceBinding:" + id;
        if (!DEVICE_BINDING_ID_TO_VALUE.containsKey(key)){
            return (DeviceBinding) redisTemplate.opsForValue().get(key);
        }
        return DEVICE_BINDING_ID_TO_VALUE.get(key);
    }


    @Override
    public DeviceBinding getValue(String productId, String deviceId, String telemetryId) {
        String key = "deviceBinding:" + productId + ":" + deviceId + ":" + telemetryId;
        if (!DEVICE_BINDING_TO_VALUE.containsKey(key)){
            return (DeviceBinding) redisTemplate.opsForValue().get(key);
        }
        return DEVICE_BINDING_TO_VALUE.get(key);
    }

    @Override
    public DeviceBinding getKeyValue(String key) {

        String key2 = "deviceBinding:" + key;

        if (!DEVICE_BINDING_TO_VALUE.containsKey(key2)){
            return (DeviceBinding) redisTemplate.opsForValue().get(key2);
        }

        return DEVICE_BINDING_TO_VALUE.get(key2);
    }


    /**
     * 查询设备属性模板
     *
     * @param id 设备属性模板主键
     * @return 设备属性模板
     */
    @Cacheable(unless = "#result == null")
    @Override
    public DeviceBinding selectDeviceBindingById(String id) {
        log.info("查询设备属性模板:{}", id);
        DeviceBinding deviceBinding = deviceBindingMapper.selectDeviceBindingById(id);
        DeviceBinding bindingData = getValue(id);
        if (bindingData != null && bindingData.getValue() != null) {
            deviceBinding.setValue(bindingData.getValue());
            deviceBinding.setLastTime(bindingData.getLastTime());
        }
        return deviceBinding;
    }

    /**
     * 查询设备属性模板列表
     *
     * @param deviceBinding 设备属性模板
     * @return 设备属性模板
     */
    @Override
    public List<DeviceBinding> selectDeviceBindingList(DeviceBinding deviceBinding) {
        log.info("查询设备属性模板列表:{}", deviceBinding);
        List<DeviceBinding> deviceBindings = deviceBindingMapper.selectDeviceBindingList(deviceBinding);
        return fillBindingData(deviceBindings);
    }

    @Override
    public List<DeviceBinding> selectDeviceBindingExportList(Device device) {
        Device query = device == null ? new Device() : device;
        List<Device> devices = devicesService.selectDevicesList(query);
        devices.sort(Comparator
                .comparing(Device::getProductId, Comparator.nullsLast(String::compareTo)));
        if (devices.isEmpty()) {
            return List.of();
        }

        Map<String, String> productNameMap = productsService.selectProductsList(new Product()).stream()
                .filter(product -> StringUtils.isNotEmpty(product.getId()))
                .collect(Collectors.toMap(Product::getId, product -> Objects.toString(product.getName(), ""), (left, right) -> left));
        Map<String, Device> deviceMap = devices.stream()
                .filter(item -> StringUtils.isNotEmpty(item.getId()))
                .collect(Collectors.toMap(Device::getId, item -> item, (left, right) -> left, LinkedHashMap::new));
        Map<String, List<ProductTemplate>> productTemplateMap = new HashMap<>();
        LinkedHashMap<String, DeviceBinding> exportMap = new LinkedHashMap<>();

        for (Device exportDevice : devices) {
            if (StringUtils.isEmpty(exportDevice.getProductId())) {
                continue;
            }
            List<ProductTemplate> productTemplates = productTemplateMap.computeIfAbsent(
                    exportDevice.getProductId(),
                    this::selectPropertyTemplatesByProductId);
            for (ProductTemplate productTemplate : productTemplates) {
                DeviceBinding exportBinding = buildTemplateBinding(exportDevice, productTemplate, productNameMap);
                exportMap.put(bindingKey(exportBinding), exportBinding);
            }
        }

        List<DeviceBinding> existingBindings = selectExportBindings(new ArrayList<>(deviceMap.keySet()));
        for (DeviceBinding existingBinding : existingBindings) {
            Device exportDevice = deviceMap.get(existingBinding.getDeviceId());
            if (exportDevice == null) {
                continue;
            }
            enrichExportBinding(existingBinding, exportDevice, productNameMap);
            exportMap.put(bindingKey(existingBinding), existingBinding);
        }

        return new ArrayList<>(exportMap.values());
    }

    @Cacheable(key = "'edgePointId:' + #edgePointId")
    @Override
    public List<DeviceBinding> selectAllByEdgePointId(String edgePointId){
        return deviceBindingMapper.selectAllByEdgePointId(edgePointId);
    }

    @Cacheable(key = "'gatewayId:' + #gatewayId")
    @Override
    public List<DeviceBinding> selectAllByGatewayId(String gatewayId){
        return deviceBindingMapper.selectAllByGatewayId(gatewayId);
    }

    @Cacheable(key = "'productId:' + #productId")
    @Override
    public List<DeviceBinding> selectAllByProductId(String productId){
        return deviceBindingMapper.selectAllByProductId(productId);
    }

    private List<ProductTemplate> selectPropertyTemplatesByProductId(String productId) {
        ProductTemplate query = new ProductTemplate();
        query.setProductId(productId);
        query.setClassify("property");
        List<ProductTemplate> productTemplates = new ArrayList<>(productTemplatesService.selectProductTemplatesList(query));
        productTemplates.sort(Comparator
                .comparing(ProductTemplate::getTelemetryKey, Comparator.nullsLast(String::compareTo))
                .thenComparing(ProductTemplate::getId, Comparator.nullsLast(String::compareTo)));
        return productTemplates;
    }

    private DeviceBinding buildTemplateBinding(Device device, ProductTemplate productTemplate, Map<String, String> productNameMap) {
        DeviceBinding deviceBinding = new DeviceBinding();
        deviceBinding.setProductId(device.getProductId());
        deviceBinding.setProductName(productNameMap.get(device.getProductId()));
        deviceBinding.setDeviceId(device.getId());
        deviceBinding.setDeviceName(device.getName());
        deviceBinding.setProductTemplateId(productTemplate.getId());
        deviceBinding.setTelemetryKey(productTemplate.getTelemetryKey());
        deviceBinding.setDataType(productTemplate.getType());
        return deviceBinding;
    }

    private List<DeviceBinding> selectExportBindings(List<String> deviceIds) {
        if (deviceIds.isEmpty()) {
            return List.of();
        }

        List<DeviceBinding> deviceBindings = new ArrayList<>();
        int batchSize = 500;
        for (int i = 0; i < deviceIds.size(); i += batchSize) {
            List<String> batchDeviceIds = deviceIds.subList(i, Math.min(i + batchSize, deviceIds.size()));
            deviceBindings.addAll(deviceBindingMapper.selectDeviceBindingListByDeviceIds(batchDeviceIds));
        }
        return fillBindingData(deviceBindings);
    }

    private void enrichExportBinding(DeviceBinding deviceBinding, Device device, Map<String, String> productNameMap) {
        if (StringUtils.isEmpty(deviceBinding.getProductId())) {
            deviceBinding.setProductId(device.getProductId());
        }
        if (StringUtils.isEmpty(deviceBinding.getDeviceId())) {
            deviceBinding.setDeviceId(device.getId());
        }
        if (StringUtils.isEmpty(deviceBinding.getProductName())) {
            deviceBinding.setProductName(productNameMap.get(deviceBinding.getProductId()));
        }
        if (StringUtils.isEmpty(deviceBinding.getDeviceName())) {
            deviceBinding.setDeviceName(device.getName());
        }
    }

    private String bindingKey(DeviceBinding deviceBinding) {
        return Objects.toString(deviceBinding.getProductId(), "")
                + "|"
                + Objects.toString(deviceBinding.getDeviceId(), "")
                + "|"
                + Objects.toString(deviceBinding.getTelemetryKey(), "");
    }

    @NonNull
    private List<DeviceBinding> fillBindingData(List<DeviceBinding> deviceBindings) {
        for (DeviceBinding binding : deviceBindings) {
            DeviceBinding bindingData = getValue(binding.getId());
            if (bindingData != null && bindingData.getValue() != null) {
                binding.setValue(bindingData.getValue());
                binding.setLastTime(bindingData.getLastTime());
            }
        }
        return deviceBindings;
    }

    @Cacheable(key = "'deviceId:' + #deviceId")
    @Override
    public List<DeviceBinding> selectAllByDeviceId(String deviceId){
        return deviceBindingMapper.selectAllByDeviceId(deviceId);
    }

    /**
     * 新增设备属性模板
     *
     * @param deviceBinding 设备属性模板
     * @return 结果
     */
    @Override
    public int insertDeviceBinding(DeviceBinding deviceBinding) {

        if (StringUtils.isEmpty(deviceBinding.getId())) {
            deviceBinding.setId(IdUtils.fastSimpleUUID());
        }

        cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
        cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
        cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
        cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
        cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());

        deviceBinding.setCreateTime(DateUtils.getNowDate());
        return deviceBindingMapper.insertDeviceBinding(deviceBinding);
    }

    /**
     * 导入设备属性模板数据
     *
     * @param deviceBindingList 设备属性模板数据列表
     * @param isUpdateSupport 是否更新已存在的数据
     * @param operName 操作用户
     * @return 导入结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importDeviceBinding(List<DeviceBinding> deviceBindingList, boolean isUpdateSupport, String operName) {
        if (StringUtils.isNull(deviceBindingList) || deviceBindingList.isEmpty()) {
            throw new ServiceException("导入设备属性模板数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (DeviceBinding deviceBinding : deviceBindingList) {
            try {
                completeBindingInfo(deviceBinding);
                DeviceBinding oldBinding = selectImportBinding(deviceBinding);
                String bindingName = getImportBindingName(deviceBinding);

                if (StringUtils.isNull(oldBinding)) {
                    deviceBinding.setCreateBy(operName);
                    insertDeviceBinding(deviceBinding);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、设备属性模板 " + bindingName + " 导入成功");
                } else if (isUpdateSupport) {
                    deviceBinding.setId(oldBinding.getId());
                    deviceBinding.setUpdateBy(operName);
                    updateDeviceBinding(deviceBinding);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、设备属性模板 " + bindingName + " 更新成功");
                } else {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、设备属性模板 " + bindingName + " 已存在");
                }
            } catch (Exception e) {
                failureNum++;
                failureMsg.append("<br/>" + failureNum + "、设备属性模板 " + getImportBindingName(deviceBinding) + " 导入失败：" + e.getMessage());
            }
        }
        if (failureNum > 0) {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        return successMsg.toString();
    }

    private DeviceBinding selectImportBinding(DeviceBinding deviceBinding) {
        if (StringUtils.isNotEmpty(deviceBinding.getId())) {
            return deviceBindingMapper.selectDeviceBindingById(deviceBinding.getId());
        }
        if (StringUtils.isNotEmpty(deviceBinding.getProductId())
                && StringUtils.isNotEmpty(deviceBinding.getDeviceId())
                && StringUtils.isNotEmpty(deviceBinding.getTelemetryKey())) {
            return deviceBindingMapper.selectOneByProductIdAndDeviceIdAndTelemetryKey(
                    deviceBinding.getProductId(),
                    deviceBinding.getDeviceId(),
                    deviceBinding.getTelemetryKey());
        }
        return null;
    }

    private void completeBindingInfo(DeviceBinding deviceBinding) {
        if (StringUtils.isNotEmpty(deviceBinding.getEdgePointId())) {
            EdgeDataPoint edgeDataPoint = edgeDataPointService.selectEdgeDataPointById(deviceBinding.getEdgePointId());
            if (StringUtils.isNull(edgeDataPoint)) {
                throw new ServiceException("网关数据点位不存在：" + deviceBinding.getEdgePointId());
            }
            deviceBinding.setEdgePointName(edgeDataPoint.getName());
            deviceBinding.setGatewayId(edgeDataPoint.getGatewayId());

            EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(edgeDataPoint.getGatewayId());
            if (StringUtils.isNull(edgeDevice)) {
                throw new ServiceException("网关设备不存在：" + edgeDataPoint.getGatewayId());
            }
            deviceBinding.setGatewayName(edgeDevice.getName());
        } else if (StringUtils.isNotEmpty(deviceBinding.getGatewayId())) {
            EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(deviceBinding.getGatewayId());
            if (StringUtils.isNull(edgeDevice)) {
                throw new ServiceException("网关设备不存在：" + deviceBinding.getGatewayId());
            }
            deviceBinding.setGatewayName(edgeDevice.getName());
        }
    }

    private String getImportBindingName(DeviceBinding deviceBinding) {
        if (StringUtils.isNotEmpty(deviceBinding.getTelemetryKey())) {
            return deviceBinding.getTelemetryKey();
        }
        if (StringUtils.isNotEmpty(deviceBinding.getId())) {
            return deviceBinding.getId();
        }
        return "";
    }

    /**
     * 修改设备属性模板
     *
     * @param deviceBinding 设备属性模板
     * @return 结果
     */
    @Override
    public int updateDeviceBinding(DeviceBinding deviceBinding) {

        cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
        cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
        cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
        cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
        cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());

        deviceBinding.setUpdateTime(DateUtils.getNowDate());
        return deviceBindingMapper.updateDeviceBinding(deviceBinding);
    }

    /**
     * 批量删除设备属性模板
     *
     * @param ids 需要删除的设备属性模板主键
     * @return 结果
     */
    @Override
    public int deleteDeviceBindingByIds(String[] ids) {

        for (String id : ids) {
            DeviceBinding deviceBinding = selectDeviceBindingById(id);
            cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
            cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
            cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
            cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
            cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());
        }

        return deviceBindingMapper.deleteDeviceBindingByIds(ids);
    }

    /**
     * 删除设备属性模板信息
     *
     * @param id 设备属性模板主键
     * @return 结果
     */
    @CacheEvict(key = "#id")
    @Override
    public int deleteDeviceBindingById(String id) {
        DeviceBinding deviceBinding = selectDeviceBindingById(id);
        cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
        cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
        cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
        cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
        cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());
        return deviceBindingMapper.deleteDeviceBindingById(id);
    }

    /**
     * 根据设备id删除设备属性模板
     *
     * @param deviceId 设备id
     * @return 删除结果
     */
    @Override
    public int deleteByDeviceId(String deviceId) {

        DeviceBinding query = new DeviceBinding();
        query.setDeviceId(deviceId);
        List<DeviceBinding> deviceBindings = deviceBindingMapper.selectDeviceBindingList(query);

        for (DeviceBinding deviceBinding : deviceBindings) {
            cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
            cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
            cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
            cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
            cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());
        }

        return deviceBindingMapper.deleteByDeviceId(deviceId);
    }

    @Override
    public int updateEdgePointNameByEdgePointId(String edgePointName, String edgePointId) {

        List<DeviceBinding> deviceBindings = selectAllByEdgePointId(edgePointId);

        for (DeviceBinding deviceBinding : deviceBindings) {
            cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
            cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
            cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
            cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
            cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());
        }

        return deviceBindingMapper.updateEdgePointNameByEdgePointId(edgePointName, edgePointId);
    }


    @Override
    public int updateGatewayNameByGatewayId(String gatewayName, String gatewayId) {

        List<DeviceBinding> deviceBindings = selectAllByGatewayId(gatewayId);

        for (DeviceBinding deviceBinding : deviceBindings) {
            cacheManager.getCache("deviceBindingCaches").evict(deviceBinding.getId());
            cacheManager.getCache("deviceBindingCaches").evict("gatewayId:" + deviceBinding.getGatewayId());
            cacheManager.getCache("deviceBindingCaches").evict("edgePointId:" + deviceBinding.getEdgePointId());
            cacheManager.getCache("deviceBindingCaches").evict("productId:" + deviceBinding.getProductId());
            cacheManager.getCache("deviceBindingCaches").evict("deviceId:" + deviceBinding.getDeviceId());
        }

        return deviceBindingMapper.updateGatewayNameByGatewayId(gatewayName, gatewayId);
    }
}
