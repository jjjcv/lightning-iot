package com.ruoyi.iot.plugin.opcua;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.DiscoveredDataPoint;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDeviceConfig;
import com.ruoyi.iot.metadata.Converter;
import org.eclipse.milo.opcua.sdk.client.AddressSpace;
import org.eclipse.milo.opcua.sdk.client.OpcUaClient;
import org.eclipse.milo.opcua.sdk.client.identity.AnonymousProvider;
import org.eclipse.milo.opcua.sdk.client.identity.IdentityProvider;
import org.eclipse.milo.opcua.sdk.client.identity.UsernameProvider;
import org.eclipse.milo.opcua.sdk.client.nodes.UaNode;
import org.eclipse.milo.opcua.sdk.client.nodes.UaVariableNode;
import org.eclipse.milo.opcua.sdk.client.subscriptions.OpcUaMonitoredItem;
import org.eclipse.milo.opcua.sdk.client.subscriptions.OpcUaSubscription;
import org.eclipse.milo.opcua.stack.core.NodeIds;
import org.eclipse.milo.opcua.stack.core.security.CertificateValidator;
import org.eclipse.milo.opcua.stack.core.security.DefaultClientCertificateValidator;
import org.eclipse.milo.opcua.stack.core.security.FileBasedTrustListManager;
import org.eclipse.milo.opcua.stack.core.security.MemoryCertificateQuarantine;
import org.eclipse.milo.opcua.stack.core.security.SecurityPolicy;
import org.eclipse.milo.opcua.stack.core.types.builtin.DataValue;
import org.eclipse.milo.opcua.stack.core.types.builtin.DateTime;
import org.eclipse.milo.opcua.stack.core.types.builtin.LocalizedText;
import org.eclipse.milo.opcua.stack.core.types.builtin.NodeId;
import org.eclipse.milo.opcua.stack.core.types.builtin.StatusCode;
import org.eclipse.milo.opcua.stack.core.types.builtin.Variant;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.UByte;
import org.eclipse.milo.opcua.stack.core.types.enumerated.MessageSecurityMode;
import org.eclipse.milo.opcua.stack.core.types.enumerated.NodeClass;
import org.eclipse.milo.opcua.stack.core.types.enumerated.TimestampsToReturn;
import org.eclipse.milo.opcua.stack.core.types.enumerated.UserTokenType;
import org.eclipse.milo.opcua.stack.core.types.structured.EndpointDescription;
import org.eclipse.milo.opcua.stack.core.util.EndpointUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.InputStream;
import java.lang.reflect.Array;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.time.Duration;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.Unsigned.uint;

/**
 * 基于 Eclipse Milo 的 OPC UA 客户端型边缘适配器。
 *
 * <p>连接成功后优先使用 OPC UA Subscription/MonitoredItem 接收数据变化；服务器不支持订阅或
 * 建立订阅失败时，可按配置回退到批量轮询。Milo 的阻塞服务调用均由边缘虚拟线程调度器执行。</p>
 */
public class OpcUaEdgeAdapter extends EdgeAdapter {

    private static final Logger log = LoggerFactory.getLogger(OpcUaEdgeAdapter.class);
    private static final int DEFAULT_MONITORED_ITEM_QUEUE_SIZE = 10;
    private static final int MAX_DISCOVERED_POINTS = 10_000;
    private static final int MAX_BROWSE_DEPTH = 32;

    private final Object lifecycleLock = new Object();
    private final AtomicBoolean connected = new AtomicBoolean(false);

    private volatile OpcUaClient client;
    private volatile OpcUaSubscription subscription;
    private volatile Disposable pollingDisposable;
    private volatile Disposable detectionDisposable;
    private volatile FileBasedTrustListManager trustListManager;
    private volatile List<OpcUaPoint> points = List.of();

    private String endpointUrl;
    private String securityPolicy = SecurityPolicy.None.name();
    private String securityMode = MessageSecurityMode.None.name();
    private String username;
    private String password;
    private String applicationName = "Lightning OPC UA Edge";
    private String applicationUri;
    private int requestTimeout = 5000;
    private int connectInterval = 30000;
    private int publishingInterval = 1000;
    private int samplingInterval = 1000;
    private boolean autoCreatePoints = true;
    private boolean preferSubscription = true;
    private boolean fallbackToPolling = true;
    private boolean trustAll = false;
    private String trustListPath;
    private String keyStorePath;
    private String keyStoreType = "PKCS12";
    private String keyStorePassword;
    private String keyPassword;
    private String keyAlias;

    @Override
    public void init(EdgeDeviceConfig edgeDevice) {
        JSONObject config = JSON.parseObject(edgeDevice.getConfiguration());
        if (config == null) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 OPC UA 配置");
        }

        endpointUrl = resolveEndpointUrl(config);
        if (endpointUrl == null || endpointUrl.isBlank()) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 endpoint 配置");
        }
        URI endpoint = URI.create(endpointUrl);
        if (!"opc.tcp".equalsIgnoreCase(endpoint.getScheme())) {
            throw new IllegalArgumentException("endpoint_url 必须使用 opc.tcp 协议");
        }

        securityPolicy = defaultString(firstString(config, "security", "security_policy", "securityPolicy"), securityPolicy);
        SecurityPolicy selectedPolicy = parseSecurityPolicy(securityPolicy);
        String configuredSecurityMode = firstString(config, "security_mode", "securityMode", "message_security");
        securityMode = defaultString(configuredSecurityMode,
                selectedPolicy == SecurityPolicy.None
                        ? MessageSecurityMode.None.name()
                        : MessageSecurityMode.SignAndEncrypt.name());
        username = firstString(config, "username", "user_name");
        password = firstString(config, "password");
        applicationName = defaultString(firstString(config, "application_name", "applicationName"), applicationName);
        applicationUri = defaultString(firstString(config, "application_uri", "applicationUri"),
                "urn:lightning:edge:opcua:" + edgeDevice.getId());
        requestTimeout = positiveInt(config, requestTimeout, "request_timeout", "requestTimeout");
        connectInterval = positiveInt(config, connectInterval, "connect_interval", "connectInterval");
        publishingInterval = positiveInt(config, publishingInterval, "publishing_interval", "publishingInterval");
        samplingInterval = positiveInt(config, samplingInterval, "sampling_interval", "samplingInterval");
        autoCreatePoints = booleanValue(config, autoCreatePoints, "auto_create_points", "autoCreatePoints");
        preferSubscription = booleanValue(config, preferSubscription, "prefer_subscription", "preferSubscription");
        fallbackToPolling = booleanValue(config, fallbackToPolling, "fallback_to_polling", "fallbackToPolling");
        trustAll = booleanValue(config, trustAll, "trust_all", "trustAll");
        trustListPath = firstString(config, "trust_list_path", "trustListPath");
        keyStorePath = firstString(config, "key_store_path", "keyStorePath", "key_store_file");
        keyStoreType = defaultString(firstString(config, "key_store_type", "keyStoreType"), keyStoreType);
        keyStorePassword = firstString(config, "key_store_password", "keyStorePassword");
        keyPassword = firstString(config, "key_password", "keyPassword");
        keyAlias = firstString(config, "key_alias", "keyAlias");

        MessageSecurityMode selectedMode = parseSecurityMode(securityMode);
        if ((selectedPolicy == SecurityPolicy.None) != (selectedMode == MessageSecurityMode.None)) {
            throw new IllegalArgumentException("security_policy=None 必须与 security_mode=None 配对");
        }
        if (selectedPolicy != SecurityPolicy.None && (keyStorePath == null || keyStorePath.isBlank())) {
            throw new IllegalArgumentException("安全端点必须配置 key_store_path");
        }
        if (selectedPolicy != SecurityPolicy.None && !trustAll
                && (trustListPath == null || trustListPath.isBlank())) {
            throw new IllegalArgumentException("安全端点必须配置 trust_list_path，或显式设置 trust_all=true");
        }

        initializePoints();
        log.info("OPC UA 边缘网关 {} 初始化成功，endpoint:{},securityPolicy:{},securityMode:{},points:{}",
                getEdgeDeviceName(), endpointUrl, selectedPolicy, securityMode, points.size());
    }

    private void initializePoints() {
        List<OpcUaPoint> valid = new ArrayList<>();
        for (Map.Entry<String, DataPoint> entry : getDataPointMap().entrySet()) {
            try {
                OpcUaPoint point = parsePoint(entry.getValue());
                point.setId(entry.getKey());
                point.parseNodeId();
                valid.add(point);
            } catch (Exception e) {
                log.warn("OPC UA 边缘网关 {} 点位 {} 配置无效，已跳过：{}",
                        getEdgeDeviceName(), entry.getKey(), e.getMessage());
            }
        }
        points = List.copyOf(valid);
    }

    OpcUaPoint parsePoint(DataPoint dataPoint) {
        if (dataPoint.getConfig() == null || dataPoint.getConfig().isBlank()) {
            throw new IllegalArgumentException("点位配置为空");
        }
        OpcUaPoint point = JSON.parseObject(dataPoint.getConfig(), OpcUaPoint.class);
        if (point.getNodeId() == null || point.getNodeId().isBlank()) {
            JSONObject object = JSON.parseObject(dataPoint.getConfig());
            String address = firstString(object, "address", "nodeId", "tag_address");
            if (address != null && !address.isBlank()) {
                point.setNodeId(address);
            }
        }
        point.setPlatformDataType(dataPoint.getType() == null ? null : dataPoint.getType().getType());
        return point;
    }

    private void discoverAndRegisterPoints() {
        if (!autoCreatePoints) {
            return;
        }
        OpcUaClient current = client;
        if (!isConnected() || current == null) {
            return;
        }
        try {
            List<DiscoveredDataPoint> discovered = browseDataPoints(current);
            List<DataPoint> registered = registerDiscoveredDataPoints(discovered);
            if (!registered.isEmpty()) {
                initializePoints();
            }
            log.info("OPC UA 边缘网关 {} 自动发现 {} 个变量节点，同步 {} 个点位",
                    getEdgeDeviceName(), discovered.size(), registered.size());
        } catch (Exception e) {
            log.warn("OPC UA 边缘网关 {} 自动发现点位失败：{}",
                    getEdgeDeviceName(), rootMessage(e), e);
        }
    }

    private List<DiscoveredDataPoint> browseDataPoints(OpcUaClient current) {
        AddressSpace addressSpace = current.getAddressSpace();
        AddressSpace.BrowseOptions options = AddressSpace.BrowseOptions.builder()
                .setNodeClassMask(Set.of(NodeClass.Object, NodeClass.Variable))
                .build();
        List<DiscoveredDataPoint> discovered = new ArrayList<>();
        Deque<BrowseCursor> pending = new ArrayDeque<>();
        Set<NodeId> visited = new HashSet<>();
        pending.push(new BrowseCursor(NodeIds.ObjectsFolder, "", 0));

        while (!pending.isEmpty() && discovered.size() < MAX_DISCOVERED_POINTS) {
            BrowseCursor cursor = pending.pop();
            if (!visited.add(cursor.nodeId()) || cursor.depth() >= MAX_BROWSE_DEPTH) {
                continue;
            }
            List<? extends UaNode> children;
            try {
                children = addressSpace.browseNodes(cursor.nodeId(), options);
            } catch (Exception e) {
                log.debug("OPC UA 节点 {} 浏览失败：{}", cursor.nodeId(), rootMessage(e));
                continue;
            }
            for (UaNode node : children) {
                NodeId nodeId = node.getNodeId();
                if (nodeId == null || nodeId.getNamespaceIndex().intValue() == 0) {
                    continue;
                }
                String path = appendPath(cursor.path(), nodeName(node, nodeId));
                if (node instanceof UaVariableNode variableNode) {
                    discovered.add(toDiscoveredPoint(variableNode, path));
                    if (discovered.size() >= MAX_DISCOVERED_POINTS) {
                        break;
                    }
                } else if (node.getNodeClass() == NodeClass.Object) {
                    pending.push(new BrowseCursor(nodeId, path, cursor.depth() + 1));
                }
            }
        }
        if (discovered.size() >= MAX_DISCOVERED_POINTS) {
            log.warn("OPC UA 边缘网关 {} 自动发现达到 {} 个点位上限，其余节点已忽略",
                    getEdgeDeviceName(), MAX_DISCOVERED_POINTS);
        }
        return discovered;
    }

    private DiscoveredDataPoint toDiscoveredPoint(UaVariableNode variableNode, String path) {
        NodeId nodeId = variableNode.getNodeId();
        NodeId opcUaDataType = variableNode.getDataType();
        String type = platformDataType(opcUaDataType);
        UByte accessLevel = variableNode.getUserAccessLevel();
        boolean writable = isWritable(accessLevel);
        String operationType = writable ? "w" : "r";
        String key = nodeId.toParseableString();
        String browseName = variableNode.getBrowseName() == null
                ? null : variableNode.getBrowseName().getName();
        String displayName = variableNode.getDisplayName() == null
                ? null : variableNode.getDisplayName().getText();
        String config = discoveredPointConfig(key, browseName, displayName, opcUaDataType,
                accessLevel);
        return new DiscoveredDataPoint(key, path, type, operationType, config);
    }

    static String discoveredPointConfig(String nodeId, String browseName, String displayName,
            NodeId dataTypeNodeId, UByte accessLevel) {
        Map<String, Object> config = new LinkedHashMap<>();
        config.put("nodeId", nodeId);
        config.put("browseName", browseName);
        config.put("displayName", displayName);
        config.put("dataType", opcUaDataTypeName(dataTypeNodeId));
        config.put("dataTypeNodeId", explicitNamespaceNodeId(dataTypeNodeId));
        config.put("accessLevel", accessLevelName(accessLevel));
        config.put("writable", isWritable(accessLevel));
        return JSON.toJSONString(config);
    }

    private static String explicitNamespaceNodeId(NodeId nodeId) {
        if (nodeId == null) {
            return null;
        }
        String value = nodeId.toParseableString();
        return value.startsWith("ns=") ? value
                : "ns=" + nodeId.getNamespaceIndex().intValue() + ";" + value;
    }

    static String opcUaDataTypeName(NodeId dataType) {
        if (dataType == null) {
            return null;
        }
        if (NodeIds.Boolean.equals(dataType)) return "Boolean";
        if (NodeIds.SByte.equals(dataType)) return "SByte";
        if (NodeIds.Byte.equals(dataType)) return "Byte";
        if (NodeIds.Int16.equals(dataType)) return "Int16";
        if (NodeIds.UInt16.equals(dataType)) return "UInt16";
        if (NodeIds.Int32.equals(dataType)) return "Int32";
        if (NodeIds.UInt32.equals(dataType)) return "UInt32";
        if (NodeIds.Int64.equals(dataType)) return "Int64";
        if (NodeIds.UInt64.equals(dataType)) return "UInt64";
        if (NodeIds.Float.equals(dataType)) return "Float";
        if (NodeIds.Double.equals(dataType)) return "Double";
        if (NodeIds.String.equals(dataType)) return "String";
        if (NodeIds.DateTime.equals(dataType)) return "DateTime";
        if (NodeIds.Guid.equals(dataType)) return "Guid";
        if (NodeIds.ByteString.equals(dataType)) return "ByteString";
        if (NodeIds.XmlElement.equals(dataType)) return "XmlElement";
        if (NodeIds.NodeId.equals(dataType)) return "NodeId";
        if (NodeIds.ExpandedNodeId.equals(dataType)) return "ExpandedNodeId";
        if (NodeIds.StatusCode.equals(dataType)) return "StatusCode";
        if (NodeIds.QualifiedName.equals(dataType)) return "QualifiedName";
        if (NodeIds.LocalizedText.equals(dataType)) return "LocalizedText";
        if (NodeIds.Structure.equals(dataType)) return "ExtensionObject";
        if (NodeIds.DataValue.equals(dataType)) return "DataValue";
        if (NodeIds.BaseDataType.equals(dataType)) return "Variant";
        if (NodeIds.DiagnosticInfo.equals(dataType)) return "DiagnosticInfo";
        if (NodeIds.Number.equals(dataType)) return "Number";
        if (NodeIds.Integer.equals(dataType)) return "Integer";
        if (NodeIds.UInteger.equals(dataType)) return "UInteger";
        if (NodeIds.Enumeration.equals(dataType)) return "Enumeration";
        return dataType.toParseableString();
    }

    static String accessLevelName(UByte accessLevel) {
        boolean readable = accessLevel != null && (accessLevel.intValue() & 0x01) != 0;
        boolean writable = isWritable(accessLevel);
        if (readable && writable) return "Read/Write";
        if (readable) return "Read";
        if (writable) return "Write";
        return "None";
    }

    private static boolean isWritable(UByte accessLevel) {
        return accessLevel != null && (accessLevel.intValue() & 0x02) != 0;
    }

    static String platformDataType(NodeId dataType) {
        if (NodeIds.Boolean.equals(dataType)) {
            return "boolean";
        }
        if (NodeIds.SByte.equals(dataType) || NodeIds.Byte.equals(dataType)
                || NodeIds.Int16.equals(dataType)) {
            return "short";
        }
        if (NodeIds.UInt16.equals(dataType) || NodeIds.Int32.equals(dataType)) {
            return "int";
        }
        if (NodeIds.UInt32.equals(dataType) || NodeIds.Int64.equals(dataType)) {
            return "long";
        }
        if (NodeIds.Float.equals(dataType)) {
            return "float";
        }
        if (NodeIds.Double.equals(dataType)) {
            return "double";
        }
        if (NodeIds.DateTime.equals(dataType)) {
            return "date";
        }
        return "string";
    }

    private static String nodeName(UaNode node, NodeId nodeId) {
        LocalizedText displayName = node.getDisplayName();
        if (displayName != null && displayName.getText() != null && !displayName.getText().isBlank()) {
            return displayName.getText();
        }
        if (node.getBrowseName() != null && node.getBrowseName().getName() != null
                && !node.getBrowseName().getName().isBlank()) {
            return node.getBrowseName().getName();
        }
        return nodeId.toParseableString();
    }

    private static String appendPath(String parent, String child) {
        return parent == null || parent.isBlank() ? child : parent + "/" + child;
    }

    private record BrowseCursor(NodeId nodeId, String path, int depth) {
    }

    @Override
    public void enable() {
        synchronized (lifecycleLock) {
            if (isEnabled()) {
                return;
            }
            setEnabledStatus(true);
        }
        if (connect()) {
            discoverAndRegisterPoints();
            online();
            startDataRefresh();
        } else {
            offline();
        }
        startDetectionLoop();
    }

    @Override
    public void disable() {
        setEnabledStatus(false);
        stopDetectionLoop();
        disconnect();
    }

    @Override
    public void online() {
        if (!isOnline()) {
            setOnlineStatus(true);
            if (getRuntimeContext() != null) {
                getRuntimeContext().publishOnline(getEdgeDeviceId());
            }
        }
    }

    @Override
    public void offline() {
        if (isOnline()) {
            setOnlineStatus(false);
            if (getRuntimeContext() != null) {
                getRuntimeContext().publishOffline(getEdgeDeviceId());
            }
        }
    }

    @Override
    public boolean connect() {
        synchronized (lifecycleLock) {
            if (isConnected()) {
                return true;
            }
            disconnectClientQuietly();
            try {
                SecurityPolicy policy = parseSecurityPolicy(securityPolicy);
                MessageSecurityMode mode = parseSecurityMode(securityMode);
                CertificateValidator validator = createCertificateValidator(policy);
                IdentityProvider identityProvider = username == null || username.isBlank()
                        ? AnonymousProvider.INSTANCE
                        : new UsernameProvider(username, Objects.requireNonNullElse(password, ""), validator);
                KeyMaterial keyMaterial = loadKeyMaterial(policy);

                client = OpcUaClient.create(
                        endpointUrl,
                        endpoints -> selectEndpoint(endpoints, policy, mode),
                        transportBuilder -> {
                        },
                        configBuilder -> {
                            configBuilder
                                    .setApplicationName(LocalizedText.english(applicationName))
                                    .setApplicationUri(applicationUri)
                                    .setProductUri("urn:lightning:edge:opcua")
                                    .setIdentityProvider(identityProvider)
                                    .setCertificateValidator(validator)
                                    .setRequestTimeout(uint(requestTimeout));
                            if (keyMaterial != null) {
                                configBuilder
                                        .setKeyPair(keyMaterial.keyPair())
                                        .setCertificate(keyMaterial.certificate())
                                        .setCertificateChain(keyMaterial.chain());
                            }
                        });
                client.connect();
                client.readNamespaceTable();
                connected.set(true);
                log.info("OPC UA 边缘网关 {} 已连接：{}", getEdgeDeviceName(), endpointUrl);
                return true;
            } catch (Exception e) {
                log.error("OPC UA 边缘网关 {} 连接失败：{}", getEdgeDeviceName(), endpointUrl, e);
                connected.set(false);
                disconnectClientQuietly();
                return false;
            }
        }
    }

    private Optional<EndpointDescription> selectEndpoint(List<EndpointDescription> endpoints,
                                                          SecurityPolicy policy,
                                                          MessageSecurityMode mode) {
        return endpoints.stream()
                .filter(endpoint -> policy.getUri().equals(endpoint.getSecurityPolicyUri()))
                .filter(endpoint -> endpoint.getSecurityMode() == mode)
                .filter(this::supportsConfiguredIdentity)
                .findFirst()
                .map(endpoint -> EndpointUtil.updateUrl(
                        endpoint,
                        EndpointUtil.getHost(endpointUrl),
                        EndpointUtil.getPort(endpointUrl)));
    }

    private boolean supportsConfiguredIdentity(EndpointDescription endpoint) {
        UserTokenType required = username == null || username.isBlank()
                ? UserTokenType.Anonymous
                : UserTokenType.UserName;
        return endpoint.getUserIdentityTokens() != null
                && Arrays.stream(endpoint.getUserIdentityTokens())
                .anyMatch(policy -> policy.getTokenType() == required);
    }

    @Override
    public boolean isConnected() {
        OpcUaClient current = client;
        if (!connected.get() || current == null) {
            return false;
        }
        try {
            return current.getSession() != null;
        } catch (Exception e) {
            connected.set(false);
            return false;
        }
    }

    @Override
    public boolean disconnect() {
        stopDataRefresh();
        synchronized (lifecycleLock) {
            disconnectClientQuietly();
        }
        offline();
        return true;
    }

    private void disconnectClientQuietly() {
        connected.set(false);
        OpcUaClient current = client;
        client = null;
        if (current != null) {
            try {
                current.disconnect();
            } catch (Exception e) {
                log.warn("OPC UA 边缘网关 {} 断开连接失败", getEdgeDeviceName(), e);
            }
        }
        FileBasedTrustListManager manager = trustListManager;
        trustListManager = null;
        if (manager != null) {
            try {
                manager.close();
            } catch (Exception e) {
                log.warn("OPC UA 边缘网关 {} 关闭证书信任目录失败", getEdgeDeviceName(), e);
            }
        }
    }

    @Override
    public DataPoint readDataPoint(DataPoint point) {
        OpcUaClient current = client;
        if (!isConnected() || current == null) {
            return point;
        }
        try {
            OpcUaPoint opcUaPoint = parsePoint(point);
            opcUaPoint.setId(point.getId());
            DataValue value = current.readValue(0.0, TimestampsToReturn.Both, opcUaPoint.parseNodeId());
            updatePoint(point.getId(), value, false);
            DataPoint cached = getDataPointMap().get(point.getId());
            if (cached != null && cached != point) {
                copyValue(cached, point);
            }
        } catch (Exception e) {
            log.error("OPC UA 边缘网关 {} 读取点位 {} 失败", getEdgeDeviceName(), point.getId(), e);
        }
        return point;
    }

    private void copyValue(DataPoint source, DataPoint target) {
        target.updateValue(source.getValue());
        target.setLastTime(source.getLastTime());
    }

    @Override
    public List<DataPoint> readDataPoints(List<DataPoint> requestedPoints) {
        List<DataPoint> results = new ArrayList<>(requestedPoints.size());
        for (DataPoint point : requestedPoints) {
            results.add(readDataPoint(point));
        }
        return results;
    }

    @Override
    public DataWriteResult writeDataPoint(String pointId, Object value) {
        DataPoint dataPoint = getDataPointMap().get(pointId);
        if (dataPoint == null) {
            return DataWriteResult.of(false, "下置点位缓存中不存在，请重启边缘网关设备");
        }
        OpcUaClient current = client;
        if (!isConnected() || current == null) {
            return DataWriteResult.of(false, "边缘网关未连接");
        }

        try {
            OpcUaPoint point = parsePoint(dataPoint);
            Object converted = dataPoint.getType() instanceof Converter<?>
                    ? ((Converter<?>) dataPoint.getType()).convert(value)
                    : value;
            Object miloValue = OpcUaValueConverter.toMilo(converted, point.getPlatformDataType());
            List<StatusCode> results = current.writeValues(
                    List.of(point.parseNodeId()),
                    List.of(DataValue.valueOnly(Variant.of(miloValue))));
            StatusCode statusCode = results.getFirst();
            if (statusCode.isGood()) {
                dataPoint.updateValue(converted);
                dataPoint.setLastTime(new Date());
                return DataWriteResult.of(true, "点位下置成功");
            }
            return DataWriteResult.of(false, "点位下置失败：" + statusCode);
        } catch (Exception e) {
            log.error("OPC UA 边缘网关 {} 点位 {} 下置失败", getEdgeDeviceName(), pointId, e);
            return DataWriteResult.of(false, "点位下置失败：" + rootMessage(e));
        }
    }

    @Override
    public Map<String, DataWriteResult> writeDataPoints(Map<String, Object> pointValues) {
        Map<String, DataWriteResult> results = new LinkedHashMap<>();
        pointValues.forEach((id, value) -> results.put(id, writeDataPoint(id, value)));
        return results;
    }

    @Override
    public void startDataRefresh() {
        stopDataRefresh();
        if (points.isEmpty() || !isConnected()) {
            return;
        }
        if (preferSubscription && startSubscription()) {
            return;
        }
        if (!preferSubscription || fallbackToPolling) {
            startPolling();
        }
    }

    private boolean startSubscription() {
        OpcUaClient current = client;
        if (current == null) {
            return false;
        }
        try {
            OpcUaSubscription newSubscription = new OpcUaSubscription(current, publishingInterval);
            newSubscription.create();
            subscription = newSubscription;
            List<OpcUaMonitoredItem> items = new ArrayList<>(points.size());
            for (OpcUaPoint point : points) {
                OpcUaMonitoredItem item = OpcUaMonitoredItem.newDataItem(point.parseNodeId());
                item.setSamplingInterval(samplingInterval);
                item.setQueueSize(uint(DEFAULT_MONITORED_ITEM_QUEUE_SIZE));
                item.setDiscardOldest(true);
                item.setUserObject(point.getId());
                item.setDataValueListener(this::handleDataValue);
                items.add(item);
            }
            newSubscription.addMonitoredItems(items);
            newSubscription.synchronizeMonitoredItems();
            log.info("OPC UA 边缘网关 {} 已建立 {} 个监控项", getEdgeDeviceName(), items.size());
            return true;
        } catch (Exception e) {
            log.error("OPC UA 边缘网关 {} 建立订阅失败", getEdgeDeviceName(), e);
            deleteSubscriptionQuietly();
            return false;
        }
    }

    private void handleDataValue(OpcUaMonitoredItem item, DataValue value) {
        item.getUserObject().map(Object::toString).ifPresent(pointId -> updatePoint(pointId, value, true));
    }

    private void startPolling() {
        pollingDisposable = Flux.interval(Duration.ZERO, Duration.ofMillis(publishingInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> Mono.fromRunnable(this::readAllPoints)
                        .subscribeOn(virtualThreadScheduler)
                        .onErrorResume(error -> {
                            log.error("OPC UA 边缘网关 {} 轮询读取失败", getEdgeDeviceName(), error);
                            return Mono.empty();
                        }))
                .subscribe();
        log.info("OPC UA 边缘网关 {} 使用 {}ms 周期轮询", getEdgeDeviceName(), publishingInterval);
    }

    private void readAllPoints() {
        OpcUaClient current = client;
        if (!isConnected() || current == null || points.isEmpty()) {
            return;
        }
        List<NodeId> nodeIds = points.stream().map(OpcUaPoint::parseNodeId).toList();
        try {
            List<DataValue> values = current.readValues(0.0, TimestampsToReturn.Both, nodeIds);
            Map<String, DataPoint> changed = new HashMap<>();
            for (int i = 0; i < values.size(); i++) {
                DataPoint snapshot = updatePoint(points.get(i).getId(), values.get(i), false);
                if (snapshot != null) {
                    changed.put(snapshot.getId(), snapshot);
                }
            }
            publishChanged(changed);
        } catch (Exception e) {
            throw new IllegalStateException("OPC UA 批量读取失败", e);
        }
    }

    private DataPoint updatePoint(String pointId, DataValue dataValue, boolean publish) {
        if (dataValue == null || dataValue.getStatusCode() == null || !dataValue.getStatusCode().isGood()) {
            log.warn("OPC UA 边缘网关 {} 点位 {} 数据质量异常：{}",
                    getEdgeDeviceName(), pointId, dataValue == null ? "null" : dataValue.getStatusCode());
            return null;
        }
        DataPoint dataPoint = getDataPointMap().get(pointId);
        if (dataPoint == null) {
            return null;
        }
        Object oldValue = dataPoint.getValue();
        Object value = OpcUaValueConverter.fromMilo(dataValue.getValue().getValue());
        dataPoint.updateValue(value);
        DateTime sourceTime = dataValue.getSourceTime();
        dataPoint.setLastTime(sourceTime != null && sourceTime.isValid() ? sourceTime.getJavaDate() : new Date());

        DataPoint snapshot = dataPoint.clone();
        if (valuesEqual(oldValue, value)) {
            return null;
        }
        if (publish) {
            publishChanged(Map.of(pointId, snapshot));
        }
        return snapshot;
    }

    private void publishChanged(Map<String, DataPoint> changed) {
        if (!changed.isEmpty() && getRuntimeContext() != null) {
            getRuntimeContext().publishDataPoints(getEdgeDeviceId(), changed);
        }
    }

    @Override
    public void stopDataRefresh() {
        Disposable polling = pollingDisposable;
        pollingDisposable = null;
        if (polling != null) {
            polling.dispose();
        }
        deleteSubscriptionQuietly();
    }

    private void deleteSubscriptionQuietly() {
        OpcUaSubscription current = subscription;
        subscription = null;
        if (current != null) {
            try {
                current.delete();
            } catch (Exception e) {
                log.warn("OPC UA 边缘网关 {} 删除订阅失败", getEdgeDeviceName(), e);
            }
        }
    }

    @Override
    public void startDetectionLoop() {
        stopDetectionLoop();
        detectionDisposable = Flux.interval(Duration.ofMillis(connectInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> Mono.fromRunnable(this::detectAndReconnect)
                        .subscribeOn(virtualThreadScheduler))
                .onErrorContinue((error, ignored) ->
                        log.error("OPC UA 边缘网关 {} 连接检测异常", getEdgeDeviceName(), error))
                .subscribe();
    }

    private void detectAndReconnect() {
        if (!isEnabled()) {
            return;
        }
        if (healthCheck()) {
            online();
            return;
        }
        offline();
        stopDataRefresh();
        connected.set(false);
        if (connect()) {
            discoverAndRegisterPoints();
            online();
            startDataRefresh();
        }
    }

    private boolean healthCheck() {
        OpcUaClient current = client;
        if (!isConnected() || current == null) {
            return false;
        }
        try {
            DataValue value = current.readValue(0.0, TimestampsToReturn.Neither,
                    NodeIds.Server_ServerStatus_State);
            boolean healthy = value != null && value.getStatusCode() != null && value.getStatusCode().isGood();
            connected.set(healthy);
            return healthy;
        } catch (Exception e) {
            log.warn("OPC UA 边缘网关 {} 健康检查失败：{}", getEdgeDeviceName(), rootMessage(e));
            connected.set(false);
            return false;
        }
    }

    @Override
    public void stopDetectionLoop() {
        Disposable detection = detectionDisposable;
        detectionDisposable = null;
        if (detection != null) {
            detection.dispose();
        }
    }

    private CertificateValidator createCertificateValidator(SecurityPolicy policy) throws Exception {
        if (policy == SecurityPolicy.None || trustAll) {
            return new CertificateValidator.InsecureCertificateValidator();
        }
        FileBasedTrustListManager manager = FileBasedTrustListManager.createAndInitialize(Path.of(trustListPath));
        trustListManager = manager;
        return new DefaultClientCertificateValidator(manager, new MemoryCertificateQuarantine());
    }

    private KeyMaterial loadKeyMaterial(SecurityPolicy policy) throws Exception {
        if (policy == SecurityPolicy.None) {
            return null;
        }
        char[] storePassword = chars(keyStorePassword);
        KeyStore keyStore = KeyStore.getInstance(keyStoreType);
        try (InputStream input = Files.newInputStream(Path.of(keyStorePath))) {
            keyStore.load(input, storePassword);
        }
        String alias = keyAlias;
        if (alias == null || alias.isBlank()) {
            alias = keyStore.aliases().asIterator().next();
        }
        char[] privateKeyPassword = keyPassword == null ? storePassword : chars(keyPassword);
        Key key = keyStore.getKey(alias, privateKeyPassword);
        if (!(key instanceof PrivateKey privateKey)) {
            throw new IllegalArgumentException("key_store_path 中别名 " + alias + " 不包含私钥");
        }
        Certificate[] certificates = keyStore.getCertificateChain(alias);
        if (certificates == null || certificates.length == 0) {
            throw new IllegalArgumentException("key_store_path 中别名 " + alias + " 不包含证书链");
        }
        X509Certificate[] chain = Arrays.copyOf(certificates, certificates.length, X509Certificate[].class);
        return new KeyMaterial(new KeyPair(chain[0].getPublicKey(), privateKey), chain[0], chain);
    }

    private static SecurityPolicy parseSecurityPolicy(String raw) {
        for (SecurityPolicy policy : SecurityPolicy.values()) {
            if (policy.name().equalsIgnoreCase(raw) || policy.getUri().equalsIgnoreCase(raw)) {
                return policy;
            }
        }
        throw new IllegalArgumentException("不支持的 security_policy: " + raw);
    }

    private static MessageSecurityMode parseSecurityMode(String raw) {
        String normalized = raw.replace("_", "").replace("-", "").toLowerCase(Locale.ROOT);
        return switch (normalized) {
            case "none" -> MessageSecurityMode.None;
            case "sign" -> MessageSecurityMode.Sign;
            case "signandencrypt" -> MessageSecurityMode.SignAndEncrypt;
            default -> throw new IllegalArgumentException("不支持的 security_mode: " + raw);
        };
    }

    private static boolean valuesEqual(Object left, Object right) {
        if (left == null || right == null) {
            return left == right;
        }
        if (left.getClass().isArray() && right.getClass().isArray()) {
            int leftLength = Array.getLength(left);
            if (leftLength != Array.getLength(right)) {
                return false;
            }
            for (int i = 0; i < leftLength; i++) {
                if (!valuesEqual(Array.get(left, i), Array.get(right, i))) {
                    return false;
                }
            }
            return true;
        }
        return Objects.equals(left, right);
    }

    private static int positiveInt(JSONObject config, int fallback, String... keys) {
        for (String key : keys) {
            Integer value = config.getInteger(key);
            if (value != null) {
                return value > 0 ? value : fallback;
            }
        }
        return fallback;
    }

    static String resolveEndpointUrl(JSONObject config) {
        String configured = firstString(config,
                "endpoint", "endpoint_url", "endpointUrl", "url", "connection_string");
        if (configured != null && !configured.isBlank()) {
            String endpoint = configured.trim();
            // 兼容旧 PLC4X opcua:tcp://host:port 配置；Milo 使用标准 opc.tcp:// URI。
            if (endpoint.regionMatches(true, 0, "opcua:tcp://", 0, "opcua:tcp://".length())) {
                endpoint = "opc.tcp://" + endpoint.substring("opcua:tcp://".length());
                int queryIndex = endpoint.indexOf('?');
                if (queryIndex >= 0) {
                    endpoint = endpoint.substring(0, queryIndex);
                }
            }
            if (!endpoint.contains("://")) {
                endpoint = "opc.tcp://" + endpoint;
            }
            return withDefaultPort(endpoint);
        }

        String host = firstString(config, "host", "ip_address");
        if (host == null || host.isBlank()) {
            return null;
        }
        int port = positiveInt(config, 4840, "port");
        String path = firstString(config, "endpoint_path", "endpointPath");
        String normalizedHost = host.trim();
        if (normalizedHost.contains(":") && !normalizedHost.startsWith("[")) {
            normalizedHost = "[" + normalizedHost + "]";
        }
        String normalizedPath = path == null || path.isBlank()
                ? ""
                : (path.startsWith("/") ? path : "/" + path);
        return "opc.tcp://" + normalizedHost + ":" + port + normalizedPath;
    }

    private static String withDefaultPort(String endpoint) {
        URI uri = URI.create(endpoint);
        if (uri.getPort() >= 0 || !"opc.tcp".equalsIgnoreCase(uri.getScheme())) {
            return endpoint;
        }
        String host = EndpointUtil.getHost(endpoint);
        if (host == null || host.isBlank()) {
            return endpoint;
        }
        String path = uri.getRawPath() == null ? "" : uri.getRawPath();
        return "opc.tcp://" + host + ":4840" + path;
    }

    private static boolean booleanValue(JSONObject config, boolean fallback, String... keys) {
        for (String key : keys) {
            Boolean value = config.getBoolean(key);
            if (value != null) {
                return value;
            }
        }
        return fallback;
    }

    private static String firstString(JSONObject object, String... keys) {
        for (String key : keys) {
            String value = object.getString(key);
            if (value != null) {
                return value;
            }
        }
        return null;
    }

    private static String defaultString(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value.trim();
    }

    private static char[] chars(String value) {
        return Objects.requireNonNullElse(value, "").toCharArray();
    }

    private static String rootMessage(Throwable error) {
        Throwable current = error;
        while (current.getCause() != null) {
            current = current.getCause();
        }
        return current.getMessage() == null ? current.getClass().getSimpleName() : current.getMessage();
    }

    private record KeyMaterial(KeyPair keyPair, X509Certificate certificate, X509Certificate[] chain) {
    }
}
