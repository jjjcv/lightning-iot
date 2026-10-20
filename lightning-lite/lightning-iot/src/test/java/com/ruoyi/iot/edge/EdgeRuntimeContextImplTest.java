package com.ruoyi.iot.edge;

import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.service.IEdgeDataPointService;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class EdgeRuntimeContextImplTest {

    @Test
    void persistsAndReturnsNewDiscoveredPoint() {
        IEdgeDataPointService pointService = mock(IEdgeDataPointService.class);
        when(pointService.selectEdgeDataPointListByEdgeId("gateway-1")).thenReturn(List.of());
        EdgeRuntimeContext context = new EdgeRuntimeContextImpl(pointService);

        List<DataPoint> result = context.registerDataPoints(
                "gateway-1",
                "opcua",
                List.of(discoveredPoint()));

        assertEquals(1, result.size());
        assertNotNull(result.getFirst().getId());
        assertEquals("double", result.getFirst().getType().getType());
        verify(pointService).insertEdgeDataPoint(any(EdgeDataPoint.class));
    }

    @Test
    void reusesExistingPointWithSameNodeId() {
        EdgeDataPoint existing = new EdgeDataPoint();
        existing.setId("point-1");
        existing.setName("Machine/Temperature");
        existing.setType("double");
        existing.setConfig("{\"node_id\":\"ns=2;s=Temperature\"}");
        IEdgeDataPointService pointService = mock(IEdgeDataPointService.class);
        when(pointService.selectEdgeDataPointListByEdgeId("gateway-1")).thenReturn(List.of(existing));
        EdgeRuntimeContext context = new EdgeRuntimeContextImpl(pointService);

        List<DataPoint> result = context.registerDataPoints(
                "gateway-1",
                "opcua",
                List.of(discoveredPoint()));

        assertEquals(1, result.size());
        assertEquals("point-1", result.getFirst().getId());
        verify(pointService, never()).insertEdgeDataPoint(any(EdgeDataPoint.class));
    }

    @Test
    void reusesExistingBacnetPointWithSameObjectIdentifier() {
        EdgeDataPoint existing = new EdgeDataPoint();
        existing.setId("bacnet-point-1");
        existing.setName("1001/Room Temperature");
        existing.setType("float");
        existing.setConfig("""
                {"deviceInstance":1001,"objectType":"analogInput","objectInstance":7}
                """);
        IEdgeDataPointService pointService = mock(IEdgeDataPointService.class);
        when(pointService.selectEdgeDataPointListByEdgeId("gateway-1")).thenReturn(List.of(existing));
        EdgeRuntimeContext context = new EdgeRuntimeContextImpl(pointService);

        DiscoveredDataPoint discovered = new DiscoveredDataPoint(
                "1001/analogInput/7/presentValue",
                "1001/Room Temperature",
                "float",
                "r",
                "{\"deviceInstance\":1001,\"objectType\":\"analogInput\",\"objectInstance\":7}");
        List<DataPoint> result = context.registerDataPoints(
                "gateway-1", "bacnet", List.of(discovered));

        assertEquals(1, result.size());
        assertEquals("bacnet-point-1", result.getFirst().getId());
        verify(pointService, never()).insertEdgeDataPoint(any(EdgeDataPoint.class));
    }

    private static DiscoveredDataPoint discoveredPoint() {
        return new DiscoveredDataPoint(
                "ns=2;s=Temperature",
                "Machine/Temperature",
                "double",
                "r",
                "{\"node_id\":\"ns=2;s=Temperature\"}");
    }
}
