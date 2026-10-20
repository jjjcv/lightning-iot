package com.ruoyi.iot.service.impl;

import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.iot.domain.*;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInterceptor;
import tools.jackson.databind.json.JsonMapper;
import com.ruoyi.iot.mapper.*;
import com.ruoyi.iot.service.IDevicesService;
import com.ruoyi.iot.service.ConnectionStatusStore;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.iot.service.IProductTemplatesService;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.mapping.Environment;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.*;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.transaction.SpringManagedTransactionFactory;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.AnnotationTransactionAttributeSource;
import org.springframework.transaction.interceptor.TransactionInterceptor;
import org.springframework.validation.DataBinder;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.List;
import java.util.UUID;
import java.util.Properties;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/** 执行实际 Mapper SQL 和 Spring 事务，覆盖标签筛选、统计与关联生命周期。 */
class BasicTagsIntegrationTest {
    private JdbcTemplate jdbc;
    private DataSourceTransactionManager transactionManager;
    private TagBindingMapper bindingMapper;
    private TagDetailMapper tagMapper;
    private ProductsMapper productMapper;
    private DeviceMapper deviceMapper;
    private TagBindingService bindings;
    private TagDetailServiceImpl tags;
    private ConnectionStatusStore connectionStatusStore;

    @BeforeEach
    void setUp() throws Exception {
        JdbcDataSource source = new JdbcDataSource();
        source.setURL("jdbc:h2:mem:" + UUID.randomUUID() + ";MODE=MySQL;DB_CLOSE_DELAY=-1");
        jdbc = new JdbcTemplate(source);
        transactionManager = new DataSourceTransactionManager(source);
        jdbc.execute("create table products (id varchar(255) primary key, name varchar(64), photo_url varchar(255), description varchar(255), product_category_id bigint, protocol_id varchar(64), transport_codec_id varchar(64), storage_interval bigint, data_expiration bigint, device_type varchar(64), status varchar(64), create_by varchar(64), create_time timestamp, update_by varchar(64), update_time timestamp)");
        jdbc.execute("create table devices (id varchar(255) primary key, name varchar(64), token varchar(64), alias varchar(64), product_id varchar(255), group_id bigint, description varchar(255), status varchar(64), ext varchar(255), gateway_id varchar(255), device_type varchar(64), link_status varchar(64), status_time timestamp, create_by varchar(64), create_time timestamp, update_time timestamp)");
        jdbc.execute("create table tag_detail (tag_id bigint auto_increment primary key, tag_name varchar(64) not null unique, description varchar(255), tag_type varchar(100), css_class varchar(100), create_by varchar(64), create_time timestamp, update_by varchar(64), update_time timestamp, remark varchar(500))");
        jdbc.execute("create table product_tag (product_id varchar(255), tag_id bigint, primary key(product_id, tag_id))");
        jdbc.execute("create table device_tag (device_id varchar(255), tag_id bigint, primary key(device_id, tag_id))");
        jdbc.execute("insert into products(id, name, status) values ('p1', 'one', 'enable'), ('p2', 'two', 'enable'), ('p3', 'three', 'disable')");
        jdbc.execute("insert into devices(id, name, product_id) values ('d1', 'one', 'p1'), ('d2', 'two', 'p2'), ('d3', 'three', 'p3')");
        jdbc.execute("insert into tag_detail(tag_id, tag_name) values (1, 'critical'), (2, 'floor-1'), (3, 'unused')");
        jdbc.execute("insert into product_tag values ('p1', 1), ('p1', 2), ('p2', 1)");
        jdbc.execute("insert into device_tag values ('d1', 1), ('d1', 2), ('d2', 1)");
        Configuration configuration = new Configuration(new Environment("tags-test", new SpringManagedTransactionFactory(), source));
        PageInterceptor pagination = new PageInterceptor();
        Properties properties = new Properties(); properties.setProperty("helperDialect", "mysql");
        pagination.setProperties(properties);
        configuration.addInterceptor(pagination);
        configuration.getTypeAliasRegistry().registerAlias("Product", Product.class);
        configuration.getTypeAliasRegistry().registerAlias("Device", Device.class);
        configuration.getTypeAliasRegistry().registerAlias("TagDetail", TagDetail.class);
        for (String file : List.of("ProductsMapper.xml", "DeviceMapper.xml", "TagDetailMapper.xml", "TagBindingMapper.xml")) {
            String resource = "mapper/iot/" + file;
            try (InputStream input = Resources.getResourceAsStream(resource)) {
                new XMLMapperBuilder(input, configuration, resource, configuration.getSqlFragments()).parse();
            }
        }
        SqlSessionTemplate session = new SqlSessionTemplate(new SqlSessionFactoryBuilder().build(configuration));
        bindingMapper = session.getMapper(TagBindingMapper.class);
        tagMapper = session.getMapper(TagDetailMapper.class);
        productMapper = session.getMapper(ProductsMapper.class);
        deviceMapper = session.getMapper(DeviceMapper.class);
        bindings = transactional(new TagBindingService(bindingMapper));
        connectionStatusStore = mock(ConnectionStatusStore.class);
        tags = transactional(new TagDetailServiceImpl(tagMapper, bindingMapper, connectionStatusStore));
        SysUser user = new SysUser();
        user.setUserName("tags-test");
        LoginUser login = new LoginUser();
        login.setUser(user);
        SecurityContextHolder.getContext().setAuthentication(UsernamePasswordAuthenticationToken.authenticated(login, null, List.of()));
    }

    @AfterEach
    void clearAuthentication() { SecurityContextHolder.clearContext(); PageHelper.clearPage(); jdbc.execute("shutdown"); }

    @Test
    void anyAndAllFiltersReturnDistinctObjectsAndCombineWithExistingFilters() {
        Product product = new Product();
        product.setTagIds(List.of(1L, 2L, 1L));
        assertEquals(List.of("p1", "p2"), productMapper.selectProductsList(product).stream().map(Product::getId).sorted().toList());
        product.setTagMatchMode("all");
        assertEquals(List.of("p1"), productMapper.selectProductsList(product).stream().map(Product::getId).toList());
        product.setStatus("disable");
        assertTrue(productMapper.selectProductsList(product).isEmpty());
        Device device = new Device();
        device.setTagIds(List.of(1L, 2L));
        assertEquals(2, deviceMapper.selectDeviceList(device).size());
        device.setTagMatchMode("all");
        assertEquals("d1", deviceMapper.selectDeviceList(device).getFirst().getId());
        device.setTagMatchMode("any");
        device.setName("two");
        assertEquals("d2", deviceMapper.selectDeviceList(device).getFirst().getId());
        product.setStatus(null);
        product.setTagIds(List.of());
        assertEquals(3, productMapper.selectProductsList(product).size());
        product.setTagIds(List.of(3L));
        assertTrue(productMapper.selectProductsList(product).isEmpty());
    }

    @Test
    void tagDeviceStatisticsCountsOnlyDirectAssociationsAndExcludesDanglingDevices() {
        // 数据库状态故意与 Redis 相反，验证统计以实时状态为准。
        jdbc.execute("update devices set link_status = 'offline' where id in ('d1', 'd3')");
        jdbc.execute("update devices set link_status = 'online' where id = 'd2'");
        when(connectionStatusStore.countOnlineDevices(anyCollection())).thenAnswer(invocation -> {
            java.util.Collection<String> ids = invocation.getArgument(0);
            return ids.stream().filter(id -> id.equals("d1") || id.equals("d3")).count();
        });
        jdbc.execute("insert into device_tag values ('missing-device', 1)");
        TagDeviceStatistics first = tags.selectDeviceStatisticsByTagId(1L);
        assertEquals(2L, first.getTotal());
        assertEquals(1L, first.getOnline());
        assertEquals(1L, first.getOffline());
        TagDeviceStatistics second = tags.selectDeviceStatisticsByTagId(2L);
        assertEquals(1L, second.getTotal());
        assertEquals(1L, second.getOnline());
        assertEquals(0L, second.getOffline());
        // 产品被打标不影响设备统计，只有 device_tag 的直接关联生效。
        jdbc.execute("insert into product_tag values ('p3', 1)");
        assertEquals(2L, tags.selectDeviceStatisticsByTagId(1L).getTotal());
    }

    @Test
    void tagDeviceStatisticsHandlesUnusedTagsUnknownStatusesAndInvalidIds() {
        TagDeviceStatistics unused = tags.selectDeviceStatisticsByTagId(3L);
        assertEquals(0L, unused.getTotal());
        assertEquals(0L, unused.getOnline());
        assertEquals(0L, unused.getOffline());
        jdbc.execute("update devices set link_status = 'unknown' where id = 'd1'");
        TagDeviceStatistics unknown = tags.selectDeviceStatisticsByTagId(1L);
        assertEquals(2L, unknown.getTotal());
        assertEquals(0L, unknown.getOnline());
        assertEquals(2L, unknown.getOffline());
        verify(connectionStatusStore).countOnlineDevices(List.of("d1", "d2"));
        assertThrows(ServiceException.class, () -> tags.selectDeviceStatisticsByTagId(null));
        assertThrows(ServiceException.class, () -> tags.selectDeviceStatisticsByTagId(0L));
        assertThrows(ServiceException.class, () -> tags.selectDeviceStatisticsByTagId(-1L));
        assertThrows(ServiceException.class, () -> tags.selectDeviceStatisticsByTagId(999L));
        tags.deleteTagDetailByTagId(3L);
        assertThrows(ServiceException.class, () -> tags.selectDeviceStatisticsByTagId(3L));
    }

    @Test
    void indexedQueryParametersBindAndDeduplicateForAllMatching() {
        for (Object query : List.of(new Product(), new Device())) {
            DataBinder binder = new DataBinder(query);
            MutablePropertyValues values = new MutablePropertyValues();
            values.add("tagIds[0]", "1");
            values.add("tagIds[1]", "2");
            values.add("tagIds[2]", "1");
            values.add("tagMatchMode", "all");
            binder.bind(values);
            assertFalse(binder.getBindingResult().hasErrors(), binder.getBindingResult().toString());
            if (query instanceof Product product) { assertEquals(1, productMapper.selectProductsList(product).size()); }
            else { assertEquals(1, deviceMapper.selectDeviceList((Device) query).size()); }
        }
    }

    @Test
    void countsIncludeZeroUsageWithoutMultiplyingProductAndDeviceJoins() {
        TagDetail used = tagMapper.selectTagDetailByTagId(1L);
        assertEquals(2L, used.getProductCount());
        assertEquals(2L, used.getDeviceCount());
        TagDetail unused = tagMapper.selectTagDetailByTagId(3L);
        assertEquals(0L, unused.getProductCount());
        assertEquals(0L, unused.getDeviceCount());
        assertEquals(3, tagMapper.selectTagDetailList(new TagDetail()).size());
    }

    @Test
    void paginationCountsDistinctObjectsAndTagEnrichmentPreservesThePage() {
        Product query = new Product(); query.setTagIds(List.of(1L, 2L));
        PageHelper.startPage(1, 1);
        List<Product> rows = productMapper.selectProductsList(query);
        bindings.fillTags("product", rows);
        assertInstanceOf(Page.class, rows);
        assertEquals(2L, ((Page<?>) rows).getTotal());
        assertEquals(1, rows.size());
        assertFalse(rows.getFirst().getTags().isEmpty());
    }

    @Test
    void responseLabelsCannotOverwriteEditedIdsInSaveRequests() {
        JsonMapper json = JsonMapper.builder().build();
        Product product = json.readValue("{\"tagIds\":[2],\"tags\":[{\"tagId\":1,\"tagName\":\"old\"}]}", Product.class);
        Device device = json.readValue("{\"tagIds\":[],\"tags\":[{\"tagId\":1}]}", Device.class);
        assertEquals(List.of(2L), product.getTagIds());
        assertTrue(device.getTagIds().isEmpty());
        assertTrue(product.getTags().isEmpty());
        assertFalse(json.writeValueAsString(product).contains("tagFilterIds"));
    }

    @Test
    void replacingTagsDeduplicatesAndDistinguishesOmittedFromEmptySelection() {
        bindings.replaceTags("product", "p1", List.of(2L, 2L));
        assertEquals(1, count("product_tag", "product_id = 'p1'"));
        bindings.replaceTags("product", "p1", null);
        assertEquals(1, count("product_tag", "product_id = 'p1'"));
        bindings.replaceTags("product", "p1", List.of());
        assertEquals(0, count("product_tag", "product_id = 'p1'"));
        bindings.replaceTags("device", "d1", List.of());
        assertEquals(0, count("device_tag", "device_id = 'd1'"));
        assertThrows(ServiceException.class, () -> bindings.replaceTags("product", "missing", List.of(1L)));
        assertThrows(ServiceException.class, () -> bindings.replaceTags("device", "d2", List.of(999L)));
        assertEquals(1, count("device_tag", "device_id = 'd2'"));
    }

    @Test
    void deletingTagsRemovesBothAssociationsAndRollsBackIfCleanupFails() {
        TagBindingMapper failing = spy(bindingMapper);
        doThrow(new IllegalStateException("cleanup failed")).when(failing).deleteDeviceBindingsByTagIds(List.of(1L));
        TagDetailServiceImpl failingService = transactional(new TagDetailServiceImpl(tagMapper, failing, connectionStatusStore));
        assertThrows(IllegalStateException.class, () -> failingService.deleteTagDetailByTagIds(new Long[]{1L}));
        assertEquals(2, count("product_tag", "tag_id = 1"));
        assertEquals(1, count("tag_detail", "tag_id = 1"));
        assertEquals(1, tags.deleteTagDetailByTagIds(new Long[]{1L, 1L}));
        assertEquals(0, count("product_tag", "tag_id = 1"));
        assertEquals(0, count("device_tag", "tag_id = 1"));
    }

    @Test
    void namesAreTrimmedRequiredUniqueAndRefreshedInObjectResponses() {
        TagDetail tag = new TagDetail();
        tag.setTagName("  renamed  ");
        tag.setTagId(2L);
        assertEquals(1, tags.updateTagDetail(tag));
        List<Product> products = productMapper.selectProductsList(new Product());
        bindings.fillTags("product", products);
        assertEquals(List.of(1L, 2L), products.stream().filter(p -> p.getId().equals("p1")).findFirst().orElseThrow().getTagIds());
        assertEquals("renamed", products.stream().filter(p -> p.getId().equals("p1")).findFirst().orElseThrow().getTags().get(1).getTagName());
        TagDetail duplicate = new TagDetail();
        duplicate.setTagName(" critical ");
        assertThrows(ServiceException.class, () -> tags.insertTagDetail(duplicate));
        duplicate.setTagName("  ");
        assertThrows(ServiceException.class, () -> tags.insertTagDetail(duplicate));
        duplicate.setTagName("a".repeat(65));
        assertThrows(ServiceException.class, () -> tags.insertTagDetail(duplicate));
        duplicate.setTagName("new-tag");
        assertEquals(1, tags.insertTagDetail(duplicate));
        assertNotNull(duplicate.getTagId());
        assertEquals("tags-test", tagMapper.selectTagDetailByTagId(duplicate.getTagId()).getCreateBy());
    }

    @Test
    void objectWritesRollbackWithInvalidTagsAndDeletionCleansAssociations() throws Exception {
        ProductsServiceImpl productService = new ProductsServiceImpl();
        inject(productService, "productsMapper", productMapper);
        inject(productService, "tagBindingService", bindings);
        inject(productService, "devicesService", mock(IDevicesService.class));
        inject(productService, "productTemplatesService", mock(IProductTemplatesService.class));
        inject(productService, "cacheManager", new ConcurrentMapCacheManager("product"));
        productService = transactional(productService);
        Product product = new Product(); product.setId("new-product"); product.setTagIds(List.of(999L));
        ProductsServiceImpl finalProductService = productService;
        assertThrows(ServiceException.class, () -> finalProductService.insertProducts(product));
        assertEquals(0, count("products", "id = 'new-product'"));
        product.setTagIds(List.of(1L, 2L));
        assertEquals(1, productService.insertProducts(product));
        assertEquals(2, count("product_tag", "product_id = 'new-product'"));
        product.setTagIds(null); product.setName("updated");
        productService.updateProduct(product);
        assertEquals(2, count("product_tag", "product_id = 'new-product'"));
        productService.deleteProductsById("new-product");
        assertEquals(0, count("product_tag", "product_id = 'new-product'"));
        DevicesServiceImpl deviceService = new DevicesServiceImpl();
        inject(deviceService, "deviceMapper", deviceMapper);
        inject(deviceService, "connectionStatusStore", connectionStatusStore);
        inject(deviceService, "tagBindingService", bindings);
        inject(deviceService, "deviceBindingService", mock(IDeviceBindingService.class));
        deviceService = transactional(deviceService);
        Device device = new Device(); device.setId("new-device"); device.setTagIds(List.of(999L));
        DevicesServiceImpl finalDeviceService = deviceService;
        assertThrows(ServiceException.class, () -> finalDeviceService.insertDevices(device));
        assertEquals(0, count("devices", "id = 'new-device'"));
        device.setTagIds(List.of(1L));
        deviceService.insertDevices(device);
        deviceService.deleteDevicesByIds(new String[]{"new-device"});
        assertEquals(0, count("device_tag", "device_id = 'new-device'"));
    }

    private int count(String table, String condition) {
        return jdbc.queryForObject("select count(*) from " + table + " where " + condition, Integer.class);
    }
    @SuppressWarnings("unchecked")
    private <T> T transactional(T target) {
        ProxyFactory factory = new ProxyFactory(target);
        factory.setProxyTargetClass(true);
        factory.addAdvice(new TransactionInterceptor(transactionManager, new AnnotationTransactionAttributeSource()));
        return (T) factory.getProxy();
    }
    private void inject(Object target, String name, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(name);
        field.setAccessible(true);
        field.set(target, value);
    }
}
