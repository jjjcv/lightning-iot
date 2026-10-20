package com.ruoyi.iot.plugin.modbus;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.digitalpetri.modbus.client.ModbusTcpClient;
import com.digitalpetri.modbus.exceptions.ModbusConnectException;
import com.digitalpetri.modbus.exceptions.ModbusResponseException;
import com.digitalpetri.modbus.exceptions.ModbusTimeoutException;
import com.digitalpetri.modbus.pdu.ReadCoilsRequest;
import com.digitalpetri.modbus.pdu.ReadDiscreteInputsRequest;
import com.digitalpetri.modbus.pdu.ReadHoldingRegistersRequest;
import com.digitalpetri.modbus.pdu.ReadInputRegistersRequest;
import com.digitalpetri.modbus.pdu.WriteMultipleCoilsRequest;
import com.digitalpetri.modbus.pdu.WriteMultipleRegistersRequest;
import com.digitalpetri.modbus.pdu.WriteSingleCoilRequest;
import com.digitalpetri.modbus.pdu.WriteSingleRegisterRequest;
import com.digitalpetri.modbus.tcp.client.NettyTcpClientTransport;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDeviceConfig;
import com.ruoyi.iot.metadata.Converter;
import io.netty.channel.ChannelOption;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.EnumMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletionException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeoutException;

@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
public class ModbusEdgeAdapter extends EdgeAdapter {

    private static final int MAX_READ_REGISTERS = 125;
    private static final int MAX_READ_BITS = 2000;
    private static final int MAX_WRITE_REGISTERS = 123;
    private static final int MAX_WRITE_COILS = 1968;

    private volatile Disposable connectDisposable;
    private volatile Disposable readDisposable;
    private volatile ModbusTcpClient modbusClient;
    private List<RegisterBlock> readPlan = List.of();
    private String ip;
    private int port;
    private int slaveId;
    private int timeout;
    private int refreshInterval;
    private int connectInterval = 30000;
    private int maxBlockSize = 125;
    private int maxBitBlockSize = MAX_READ_BITS;
    private int maxBlockGap;
    private int maxInFlightRequests = 1;
    private int retryAttempts = 1;
    private int retryBackoff = 200;
    private ByteOrder byteOrder = ByteOrder.BIG_ENDIAN;

    @Override
    public void startDetectionLoop() {
        this.connectDisposable = Flux.interval(Duration.ofMillis(this.connectInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> {
                    // 检测循环中的异常在内部消化，避免单次异常终止整个重连循环
                    try {
                        if (isConnected()) {
                            return Mono.empty();
                        }
                        if (connect()) {
                            log.info("modbus边缘网关{}重连成功", getEdgeDeviceName());
                            startDataRefresh();
                            online();
                        } else {
                            offline();
                        }
                    } catch (Exception e) {
                        log.error("modbus边缘网关{}检测循环异常：", getEdgeDeviceName(), e);
                    }
                    return Mono.empty();
                })
                .subscribe();
    }

    @Override
    public void stopDetectionLoop() {
        Disposable disposable = this.connectDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
    }

    @Override
    public void enable() {
        if (isEnabled()) {
            return;
        }

        setEnabledStatus(true);

        log.debug("Enabling ModbusEdgeAdapter.");
        if (connect()) {
            log.info("Connection successful. Starting data refresh and detection loop.");
            startDataRefresh();
            online();
        } else {
            log.warn("Connection failed. Marking as offline.");
            offline();
        }

        startDetectionLoop();
    }

    @Override
    public void disable() {
        // 无论是否曾启用，都确保释放连接与定时任务，避免资源泄漏
        setEnabledStatus(false);
        stopDetectionLoop();
        disconnect();
    }

    @Override
    public void online() {
        if (!isOnline()) {
            log.info("Setting online status to true.");
            setOnlineStatus(true);
            if (getRuntimeContext() != null) {
                getRuntimeContext().publishOnline(getEdgeDeviceId());
            }
        } else {
            log.debug("Already online.");
        }
    }

    @Override
    public void offline() {
        if (isOnline()) {
            log.info("Setting online status to false.");
            setOnlineStatus(false);
            if (getRuntimeContext() != null) {
                getRuntimeContext().publishOffline(getEdgeDeviceId());
            }
        } else {
            log.debug("Already offline.");
        }
    }


    @Override
    public void init(EdgeDeviceConfig edgeDevice) {
        JSONObject config = JSON.parseObject(edgeDevice.getConfiguration());
        if (config == null) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少配置");
        }
        this.ip = config.getString("ip_address");
        Integer port = config.getInteger("port");
        this.port = port != null ? port : 502;
        Integer slaveId = config.getInteger("slave_id");
        this.slaveId = slaveId != null ? slaveId : 1;
        Integer timeout = config.getInteger("timeout");
        this.timeout = timeout != null ? timeout : 3000;
        Integer refreshInterval = config.getInteger("refresh_interval");
        this.refreshInterval = refreshInterval != null ? refreshInterval : 1000;
        Integer connectInterval = config.getInteger("connect_interval");
        this.connectInterval = connectInterval != null ? connectInterval : 30000;
        Integer maxBlockSize = config.getInteger("max_block_size");
        this.maxBlockSize = clamp(maxBlockSize, 1, MAX_READ_REGISTERS, MAX_READ_REGISTERS);
        Integer maxBitBlockSize = config.getInteger("max_bit_block_size");
        this.maxBitBlockSize = clamp(maxBitBlockSize, 1, MAX_READ_BITS, MAX_READ_BITS);
        Integer maxBlockGap = config.getInteger("max_block_gap");
        this.maxBlockGap = clamp(maxBlockGap, 0, MAX_READ_BITS - 1, 0);
        Integer maxInFlightRequests = config.getInteger("max_in_flight_requests");
        this.maxInFlightRequests = clamp(maxInFlightRequests, 1, 16, 1);
        Integer retryAttempts = config.getInteger("retry_attempts");
        this.retryAttempts = clamp(retryAttempts, 0, 5, 1);
        Integer retryBackoff = config.getInteger("retry_backoff");
        this.retryBackoff = clamp(retryBackoff, 1, 10000, 200);
        String order = config.getString("byte_order");
        this.byteOrder = (order != null && order.trim().equalsIgnoreCase("LITTLE_ENDIAN"))
                ? ByteOrder.LITTLE_ENDIAN : ByteOrder.BIG_ENDIAN;

        if (this.ip == null || this.ip.isBlank()) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 ip_address 配置");
        }

        initializeRegisters();
        log.info("modbus边缘网关{}初始化成功，ip:{},port:{},slaveId:{},timeout:{},refreshInterval:{},"
                        + "byteOrder:{},readBlocks:{},maxInFlight:{}",
                this.getEdgeDeviceName(), this.ip, this.port, this.slaveId, this.timeout,
                this.refreshInterval, this.byteOrder, this.readPlan.size(), this.maxInFlightRequests);
    }


    private static int clamp(Integer value, int min, int max, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        return Math.max(min, Math.min(max, value));
    }


    private void initializeRegisters() {
        List<ModbusRegister> valid = new ArrayList<>();
        for (Map.Entry<String, DataPoint> entry : getDataPointMap().entrySet()) {
            try {
                // 提前校验寄存器类型，避免单个坏点位在刷新时拖垮整个网关
                ModbusRegister register = toRegister(entry.getValue());
                register.setId(entry.getKey());
                valid.add(register);
            } catch (Exception e) {
                log.warn("modbus边缘网关{}点位{}寄存器配置无效，已跳过：{}", getEdgeDeviceName(), entry.getKey(), e.getMessage());
            }
        }
        this.readPlan = List.copyOf(buildReadPlan(valid));
    }

    private void validateRegister(ModbusRegister register) {
        RegisterType registerType = register.getRegisterTypeEnum();
        if (register.getOffset() < 0) {
            throw new IllegalArgumentException("寄存器地址不能小于 0");
        }
        if (register.getQuantity() <= 0) {
            throw new IllegalArgumentException("寄存器数量必须大于 0");
        }
        int protocolLimit = isBitType(registerType) ? MAX_READ_BITS : MAX_READ_REGISTERS;
        if (register.getQuantity() > protocolLimit) {
            throw new IllegalArgumentException("寄存器数量超过协议上限 " + protocolLimit);
        }
        if ((long) register.getOffset() + register.getQuantity() > 65536L) {
            throw new IllegalArgumentException("寄存器地址范围超过 65535");
        }
    }

    private static boolean isBitType(RegisterType registerType) {
        return registerType == RegisterType.COIL || registerType == RegisterType.DISCRETE;
    }

    @Override
    public void startDataRefresh() {
        if (readDisposable != null && !readDisposable.isDisposed()) {
            log.warn("Data refresh is already running. Skipping duplicate start.");
            return;
        }

        this.readDisposable = Flux.interval(Duration.ofMillis(this.refreshInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> readAllRegisters()
                        .onErrorResume(error -> {
                            log.error("modbus边缘网关{}刷新失败：", getEdgeDeviceName(), error);
                            if (isConnectionFailure(error)) {
                                disconnect();
                            }
                            return Mono.empty();
                        }))
                .subscribe();
    }

    @Override
    public void stopDataRefresh() {
        Disposable disposable = this.readDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
    }

    private Mono<Void> readAllRegisters() {
        List<RegisterBlock> plan = this.readPlan;
        if (plan.isEmpty()) {
            return Mono.empty();
        }
        Date cycleTimestamp = new Date();
        return executeReadPlan(plan, getDataPointMap(), cycleTimestamp, false, true)
                .collectMap(DataPoint::getId, point -> point, LinkedHashMap::new)
                .doOnNext(this::publishDataPoints)
                .then();
    }

    private void publishDataPoints(Map<String, DataPoint> changed) {
        if (!changed.isEmpty() && getRuntimeContext() != null) {
            getRuntimeContext().publishDataPoints(this.getEdgeDeviceId(), changed);
        }
    }

    private static boolean valuesEqual(Object a, Object b) {
        if (a == b) {
            return true;
        }
        if (a == null || b == null) {
            return false;
        }
        // 线圈多位置返回 boolean[]，需用 Arrays.equals 而非引用相等
        if (a instanceof boolean[] && b instanceof boolean[]) {
            return Arrays.equals((boolean[]) a, (boolean[]) b);
        }
        return a.equals(b);
    }

    private Flux<DataPoint> executeReadPlan(
            List<RegisterBlock> plan,
            Map<String, DataPoint> targetPoints,
            Date timestamp,
            boolean updateCache,
            boolean changesOnly) {
        return Flux.fromIterable(plan)
                .flatMap(
                        block -> readBlockReactive(block, targetPoints, timestamp, updateCache, changesOnly),
                        maxInFlightRequests);
    }

    private Flux<DataPoint> readBlockReactive(
            RegisterBlock block,
            Map<String, DataPoint> targetPoints,
            Date timestamp,
            boolean updateCache,
            boolean changesOnly) {
        Mono<byte[]> request = readBlockAsync(block);
        if (retryAttempts > 0) {
            request = request.retryWhen(Retry.backoff(retryAttempts, Duration.ofMillis(retryBackoff))
                    .maxBackoff(Duration.ofMillis(Math.max(retryBackoff, 1000)))
                    .filter(this::isRetryableFailure)
                    .onRetryExhaustedThrow((spec, signal) -> signal.failure()));
        }
        return request
                .flatMapMany(data -> decodeBlock(block, data, targetPoints, timestamp, updateCache, changesOnly))
                .onErrorResume(error -> {
                    if (isConnectionFailure(error)) {
                        return Flux.error(error);
                    }
                    log.warn("modbus边缘网关{}读取块失败(type={},start={},quantity={})，本轮跳过：{}",
                            getEdgeDeviceName(), block.getRegisterType(), block.getStart(),
                            block.getTotalQuantity(), rootCause(error).getMessage());
                    return Flux.empty();
                });
    }

    private Mono<byte[]> readBlockAsync(RegisterBlock block) {
        return Mono.defer(() -> {
            ModbusTcpClient client = this.modbusClient;
            if (client == null || !client.isConnected()) {
                return Mono.error(new ModbusConnectException("Modbus client 未连接"));
            }
            int start = block.getStart();
            int quantity = block.getTotalQuantity();
            return switch (block.getRegisterType()) {
                case HOLDING -> Mono.fromCompletionStage(client.readHoldingRegistersAsync(
                                slaveId, new ReadHoldingRegistersRequest(start, quantity)))
                        .map(response -> response.registers());
                case INPUT -> Mono.fromCompletionStage(client.readInputRegistersAsync(
                                slaveId, new ReadInputRegistersRequest(start, quantity)))
                        .map(response -> response.registers());
                case COIL -> Mono.fromCompletionStage(client.readCoilsAsync(
                                slaveId, new ReadCoilsRequest(start, quantity)))
                        .map(response -> response.coils());
                case DISCRETE -> Mono.fromCompletionStage(client.readDiscreteInputsAsync(
                                slaveId, new ReadDiscreteInputsRequest(start, quantity)))
                        .map(response -> response.inputs());
            };
        });
    }

    private boolean isRetryableFailure(Throwable error) {
        Throwable cause = rootCause(error);
        return cause instanceof TimeoutException
                || cause instanceof ModbusTimeoutException
                || cause instanceof ModbusConnectException
                || cause instanceof IOException;
    }

    private boolean isConnectionFailure(Throwable error) {
        return isRetryableFailure(error);
    }

    private static Throwable rootCause(Throwable error) {
        Throwable current = error;
        while ((current instanceof CompletionException || current instanceof ExecutionException)
                && current.getCause() != null) {
            current = current.getCause();
        }
        while (current.getCause() != null
                && !(current instanceof ModbusResponseException)
                && !(current instanceof ModbusTimeoutException)
                && !(current instanceof ModbusConnectException)
                && !(current instanceof IOException)
                && !(current instanceof TimeoutException)) {
            current = current.getCause();
        }
        return current;
    }

    /** 初始化或点位集合变化时生成一次读取计划，刷新周期内直接复用。 */
    List<RegisterBlock> buildReadPlan(List<ModbusRegister> source) {
        Map<RegisterType, List<ModbusRegister>> grouped = new EnumMap<>(RegisterType.class);
        for (ModbusRegister register : source) {
            grouped.computeIfAbsent(register.getRegisterTypeEnum(), ignored -> new ArrayList<>()).add(register);
        }

        List<RegisterBlock> blocks = new ArrayList<>();
        for (RegisterType registerType : RegisterType.values()) {
            List<ModbusRegister> group = grouped.get(registerType);
            if (group == null) {
                continue;
            }
            group.sort(Comparator.comparingInt(ModbusRegister::getOffset));
            RegisterBlock last = null;
            for (ModbusRegister register : group) {
                if (last == null || !canMergeWithLastBlock(last, register)) {
                    last = new RegisterBlock(register);
                    blocks.add(last);
                } else {
                    last.add(register);
                }
            }
        }
        return blocks;
    }

    private boolean canMergeWithLastBlock(RegisterBlock block, ModbusRegister register) {
        long blockEnd = block.getEndExclusive();
        long registerEnd = (long) register.getOffset() + register.getQuantity();
        long gap = Math.max(0, (long) register.getOffset() - blockEnd);
        long mergedQuantity = Math.max(blockEnd, registerEnd) - block.getStart();
        int limit = isBitType(block.getRegisterType()) ? maxBitBlockSize : maxBlockSize;
        return gap <= maxBlockGap && mergedQuantity <= limit;
    }

    private Flux<DataPoint> decodeBlock(
            RegisterBlock block,
            byte[] data,
            Map<String, DataPoint> targetPoints,
            Date timestamp,
            boolean updateCache,
            boolean changesOnly) {
        return Flux.fromIterable(block.getRegisters()).handle((register, sink) -> {
            try {
                Object value = convertToValue(register, block.getRegisterType(), block.getStart(), data);
                DataPoint target = targetPoints.get(register.getId());
                if (target == null) {
                    return;
                }
                DataPoint snapshot = updatePoint(target, value, timestamp);
                if (updateCache) {
                    DataPoint cached = getDataPointMap().get(register.getId());
                    if (cached != null && cached != target) {
                        updatePoint(cached, value, timestamp);
                    }
                }
                if (!changesOnly || !valuesEqual(snapshot.getValue(), snapshot.getOldValue())) {
                    sink.next(snapshot);
                }
            } catch (Exception e) {
                log.warn("modbus边缘网关{}点位{}数据解析失败，本轮跳过：{}",
                        getEdgeDeviceName(), register.getId(), e.getMessage());
            }
        });
    }

    private static DataPoint updatePoint(DataPoint dataPoint, Object value, Date timestamp) {
        synchronized (dataPoint) {
            dataPoint.updateValue(value);
            dataPoint.setLastTime(timestamp);
            return dataPoint.clone();
        }
    }

    private Object convertToValue(
            ModbusRegister register,
            RegisterType registerType,
            int start,
            byte[] data) {
        String type = register.getType();
        int quantity = register.getQuantity();

        return switch (registerType) {
            case HOLDING, INPUT -> convertRegisterValue(
                    type, quantity, data, (register.getOffset() - start) * 2);
            case COIL, DISCRETE -> convertBitValue(register.getOffset(), start, quantity, data);
        };
    }

    private Object convertRegisterValue(String type, int quantity, byte[] data, int position) {
        int length = quantity * 2;
        if (position < 0 || position + length > data.length) {
            throw new IllegalArgumentException(
                    "寄存器数据越界：position=" + position + "，length=" + length + "，dataLen=" + data.length);
        }
        ByteBuffer buffer = ByteBuffer.wrap(data, position, length).order(byteOrder);

        //16位int
        if (type.equals("int") && quantity == 1) {
            return buffer.getShort();
        }
        //32位int
        if (type.equals("int") && quantity == 2) {
            return buffer.getInt();
        }
        //32位float
        if (type.equals("float") && quantity == 2) {
            return buffer.getFloat();
        }
        //64位double
        if (type.equals("double") && quantity == 4) {
            return buffer.getDouble();
        }
        //64位Long
        if (type.equals("long") && quantity == 4) {
            return buffer.getLong();
        }

        throw new IllegalArgumentException("Unknown type: " + type + "，寄存器数量：" + quantity);
    }

    private Object convertBitValue(int offset, int start, int quantity, byte[] data) {
        int bitStart = offset - start;
        if (bitStart < 0 || bitStart + quantity > data.length * 8) {
            throw new IllegalArgumentException(
                    "位数据越界：bitStart=" + bitStart + "，quantity=" + quantity + "，dataBits=" + (data.length * 8));
        }
        if (quantity == 1) {
            return ((data[bitStart / 8] >> (bitStart % 8)) & 0x01) == 1;
        }
        boolean[] values = new boolean[quantity];
        for (int i = 0; i < quantity; i++) {
            int absBit = bitStart + i;
            int byteIdx = absBit / 8;
            int bitIdx = absBit % 8;
            values[i] = ((data[byteIdx] >> bitIdx) & 0x01) == 1;
        }
        return values;
    }


    @Override
    public boolean connect() {
        // 关闭可能残留的旧连接，避免句柄泄漏
        disconnectClientQuietly();
        try {
            NettyTcpClientTransport transport = NettyTcpClientTransport.create(config -> config
                    .setHostname(this.ip)
                    .setPort(this.port)
                    .setConnectTimeout(Duration.ofMillis(this.timeout))
                    .setBootstrapCustomizer(bootstrap -> bootstrap.option(ChannelOption.SO_KEEPALIVE, true))
                    // 由适配器的检测循环统一负责重连，避免库内部与外部重复重连
                    .setConnectPersistent(false));
            ModbusTcpClient client = ModbusTcpClient.create(
                    transport,
                    config -> config.setRequestTimeout(Duration.ofMillis(this.timeout)));
            this.modbusClient = client;
            client.connect();
            // 触发实际 TCP 连接并校验从机可达性（使用真实 slaveId）
            client.readCoils(this.slaveId, new ReadCoilsRequest(0, 1));
            return isConnected();
        } catch (ModbusResponseException e) {
            // 从机已返回协议异常码，说明传输层已连通
            log.warn("modbus边缘网关{}连接探测返回协议异常（传输层已连通）：", this.getEdgeDeviceName(), e);
            return isConnected();
        } catch (Exception e) {
            log.error("modbus边缘网关{}连接失败：", this.getEdgeDeviceName(), e);
            disconnectClientQuietly();
            return false;
        }
    }

    @Override
    public boolean isConnected() {
        ModbusTcpClient client = this.modbusClient;
        return client != null && client.isConnected();
    }

    @Override
    public boolean disconnect() {
        stopDataRefresh();
        disconnectClientQuietly();
        offline();
        return true;
    }

    private void disconnectClientQuietly() {
        ModbusTcpClient client = this.modbusClient;
        this.modbusClient = null;
        if (client != null) {
            try {
                client.disconnect();
            } catch (Exception e) {
                log.warn("modbus边缘网关{}关闭连接失败：", this.getEdgeDeviceName(), e);
            }
        }
    }

    @Override
    public DataPoint readDataPoint(DataPoint point) {
        readDataPoints(List.of(point));
        return point;
    }

    @Override
    public List<DataPoint> readDataPoints(List<DataPoint> points) {
        List<DataPoint> results = new ArrayList<>(points);
        if (points.isEmpty() || !isConnected()) {
            return results;
        }

        Map<String, DataPoint> targets = new LinkedHashMap<>();
        List<ModbusRegister> requestedRegisters = new ArrayList<>();
        for (DataPoint point : points) {
            try {
                ModbusRegister register = toRegister(point);
                targets.put(point.getId(), point);
                requestedRegisters.add(register);
            } catch (Exception e) {
                log.warn("modbus边缘网关{}点位{}读取配置无效，已跳过：{}",
                        getEdgeDeviceName(), point.getId(), e.getMessage());
            }
        }
        if (requestedRegisters.isEmpty()) {
            return results;
        }

        try {
            executeReadPlan(buildReadPlan(requestedRegisters), targets, new Date(), true, false)
                    .then()
                    .block();
        } catch (Exception e) {
            log.error("modbus边缘网关{}批量读取点位失败：", getEdgeDeviceName(), e);
        }
        return results;
    }

    private ModbusRegister toRegister(DataPoint point) {
        ModbusRegister register = JSON.parseObject(point.getConfig(), ModbusRegister.class);
        if (register == null) {
            throw new IllegalArgumentException("缺少 Modbus 点位配置");
        }
        register.setId(point.getId());
        register.setType(point.getType().getId());
        validateRegister(register);
        return register;
    }

    @Override
    public DataWriteResult writeDataPoint(String pointId, Object value) {
        Map<String, Object> values = new LinkedHashMap<>();
        values.put(pointId, value);
        return writeDataPoints(values).get(pointId);
    }

    @Override
    public Map<String, DataWriteResult> writeDataPoints(Map<String, Object> pointValues) {
        Map<String, DataWriteResult> results = new LinkedHashMap<>();
        if (pointValues.isEmpty()) {
            return results;
        }

        ModbusTcpClient client = this.modbusClient;
        if (client == null || !client.isConnected()) {
            pointValues.keySet().forEach(id -> results.put(id, DataWriteResult.of(false, "边缘网关未连接")));
            return results;
        }

        List<WriteCommand> holdingCommands = new ArrayList<>();
        List<WriteCommand> coilCommands = new ArrayList<>();
        pointValues.forEach((id, value) -> {
            results.put(id, null);
            DataPoint dataPoint = getDataPointMap().get(id);
            if (dataPoint == null) {
                results.put(id, DataWriteResult.of(false, "下置点位缓存中不存在，请重启边缘网关设备！"));
                return;
            }
            try {
                WriteCommand command = createWriteCommand(id, dataPoint, value);
                if (command.register().getRegisterTypeEnum() == RegisterType.HOLDING) {
                    holdingCommands.add(command);
                } else {
                    coilCommands.add(command);
                }
            } catch (Exception e) {
                results.put(id, DataWriteResult.of(false, e.getMessage()));
            }
        });

        holdingCommands.sort(Comparator.comparingInt(command -> command.register().getOffset()));
        coilCommands.sort(Comparator.comparingInt(command -> command.register().getOffset()));
        executeHoldingWriteBatches(client, holdingCommands, results);
        executeCoilWriteBatches(client, coilCommands, results);
        return results;
    }

    private WriteCommand createWriteCommand(String id, DataPoint dataPoint, Object rawValue) {
        ModbusRegister register = toRegister(dataPoint);
        RegisterType registerType = register.getRegisterTypeEnum();
        Object convertedValue = ((Converter) dataPoint.getType()).convert(rawValue);
        return switch (registerType) {
            case HOLDING -> new WriteCommand(
                    id, register, encodeHoldingValue(dataPoint.getType().getId(), register.getQuantity(), convertedValue), null);
            case COIL -> {
                if (register.getQuantity() != 1) {
                    throw new IllegalArgumentException("线圈下置仅支持 quantity=1");
                }
                yield new WriteCommand(id, register, null, (Boolean) convertedValue);
            }
            default -> throw new IllegalArgumentException("不支持下置的寄存器类型: " + registerType);
        };
    }

    private byte[] encodeHoldingValue(String type, int quantity, Object value) {
        if (type.equals("int") && quantity == 1) {
            int shortValue = ((Number) value).intValue();
            if (shortValue < Short.MIN_VALUE || shortValue > Short.MAX_VALUE) {
                throw new IllegalArgumentException("16位int下置值超出范围：" + shortValue);
            }
            return ByteBuffer.allocate(2).order(ByteOrder.BIG_ENDIAN).putShort((short) shortValue).array();
        }
        if (type.equals("int") && quantity == 2) {
            return TypeConversionUtils.intToByteArray(((Number) value).intValue(), byteOrder);
        }
        if (type.equals("float") && quantity == 2) {
            return TypeConversionUtils.floatToByteArray(((Number) value).floatValue(), byteOrder);
        }
        if (type.equals("double") && quantity == 4) {
            return TypeConversionUtils.doubleToByteArray(((Number) value).doubleValue(), byteOrder);
        }
        if (type.equals("long") && quantity == 4) {
            return TypeConversionUtils.longToByteArray(((Number) value).longValue(), byteOrder);
        }
        throw new IllegalArgumentException("Unknown type: " + type + "，寄存器数量：" + quantity);
    }

    private void executeHoldingWriteBatches(
            ModbusTcpClient client,
            List<WriteCommand> commands,
            Map<String, DataWriteResult> results) {
        int from = 0;
        while (from < commands.size()) {
            int to = from + 1;
            int end = commands.get(from).register().getOffset() + commands.get(from).register().getQuantity();
            while (to < commands.size()) {
                ModbusRegister next = commands.get(to).register();
                int start = commands.get(from).register().getOffset();
                if (next.getOffset() != end || next.getOffset() + next.getQuantity() - start > MAX_WRITE_REGISTERS) {
                    break;
                }
                end = next.getOffset() + next.getQuantity();
                to++;
            }
            writeHoldingBatch(client, commands.subList(from, to), results);
            from = to;
        }
    }

    private void writeHoldingBatch(
            ModbusTcpClient client,
            List<WriteCommand> batch,
            Map<String, DataWriteResult> results) {
        try {
            WriteCommand first = batch.getFirst();
            int start = first.register().getOffset();
            int quantity = batch.stream().mapToInt(command -> command.register().getQuantity()).sum();
            if (batch.size() == 1 && quantity == 1) {
                byte[] bytes = first.registerBytes();
                int value = ((bytes[0] & 0xFF) << 8) | (bytes[1] & 0xFF);
                client.writeSingleRegister(slaveId, new WriteSingleRegisterRequest(start, value));
            } else {
                byte[] values = new byte[quantity * 2];
                int position = 0;
                for (WriteCommand command : batch) {
                    System.arraycopy(command.registerBytes(), 0, values, position, command.registerBytes().length);
                    position += command.registerBytes().length;
                }
                client.writeMultipleRegisters(
                        slaveId, new WriteMultipleRegistersRequest(start, quantity, values));
            }
            markWriteBatch(batch, results, true);
        } catch (Exception e) {
            log.error("modbus边缘网关{}保持寄存器批量下置失败：", getEdgeDeviceName(), e);
            markWriteBatch(batch, results, false);
        }
    }

    private void executeCoilWriteBatches(
            ModbusTcpClient client,
            List<WriteCommand> commands,
            Map<String, DataWriteResult> results) {
        int from = 0;
        while (from < commands.size()) {
            int to = from + 1;
            int start = commands.get(from).register().getOffset();
            int end = start + 1;
            while (to < commands.size()) {
                int nextOffset = commands.get(to).register().getOffset();
                if (nextOffset != end || nextOffset - start + 1 > MAX_WRITE_COILS) {
                    break;
                }
                end++;
                to++;
            }
            writeCoilBatch(client, commands.subList(from, to), results);
            from = to;
        }
    }

    private void writeCoilBatch(
            ModbusTcpClient client,
            List<WriteCommand> batch,
            Map<String, DataWriteResult> results) {
        try {
            WriteCommand first = batch.getFirst();
            int start = first.register().getOffset();
            if (batch.size() == 1) {
                client.writeSingleCoil(slaveId, new WriteSingleCoilRequest(start, first.coilValue()));
            } else {
                byte[] values = new byte[(batch.size() + 7) / 8];
                for (int i = 0; i < batch.size(); i++) {
                    if (batch.get(i).coilValue()) {
                        values[i / 8] |= (byte) (1 << (i % 8));
                    }
                }
                client.writeMultipleCoils(
                        slaveId, new WriteMultipleCoilsRequest(start, batch.size(), values));
            }
            markWriteBatch(batch, results, true);
        } catch (Exception e) {
            log.error("modbus边缘网关{}线圈批量下置失败：", getEdgeDeviceName(), e);
            markWriteBatch(batch, results, false);
        }
    }

    private static void markWriteBatch(
            List<WriteCommand> batch,
            Map<String, DataWriteResult> results,
            boolean success) {
        String message = success ? "点位下置成功" : "点位下置失败";
        batch.forEach(command -> results.put(command.id(), DataWriteResult.of(success, message)));
    }

    private record WriteCommand(
            String id,
            ModbusRegister register,
            byte[] registerBytes,
            Boolean coilValue) {
    }

}
