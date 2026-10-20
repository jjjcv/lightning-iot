package com.ruoyi.iot.cache;

import com.ruoyi.iot.domain.DeviceTelemetry;
import org.jctools.maps.NonBlockingHashMap;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class SubscribeCache {

    //ticket, List<product:device:telemetryId>
    private final Map<String, Set<DeviceTelemetry>> cacheTicket = new NonBlockingHashMap<>();

    //product:device:telemetryId, List<ticket>
    private final Map<String, Set<String>> cacheTelemetryId = new NonBlockingHashMap<>();

    public void put(String ticket, Set<DeviceTelemetry> data) {
        Set<DeviceTelemetry> previous = cacheTicket.put(ticket, data);
        removeTicketFromTelemetryIndex(ticket, previous);

        for (DeviceTelemetry deviceTelemetry : data) {
            String key = deviceTelemetry.getProductId() + ":" + deviceTelemetry.getDeviceId() + ":" + deviceTelemetry.getTelemetryKey();
            Set<String> tickets = cacheTelemetryId.get(key);
            if (tickets == null) {
                tickets = new HashSet<>();
            }
            tickets.add(ticket);
            cacheTelemetryId.put(key, tickets);
        }

    }

    public void addTelemetryTag(String ticket, DeviceTelemetry deviceTelemetry) {
        Set<DeviceTelemetry> deviceTelemetries = cacheTicket.get(ticket);

        if (deviceTelemetries == null) {
            deviceTelemetries = new HashSet<>();
        }
        deviceTelemetries.add(deviceTelemetry);
        cacheTicket.put(ticket, deviceTelemetries);
    }

    public void removeTelemetryTag(String ticket, DeviceTelemetry deviceTelemetry) {
        Set<DeviceTelemetry> deviceTelemetries = cacheTicket.get(ticket);
        if (deviceTelemetries != null) {
            deviceTelemetries.remove(deviceTelemetry);
            if (deviceTelemetries.isEmpty()) {
                cacheTicket.remove(ticket);
            }
        }
    }

    public Set<DeviceTelemetry> getTelemetryTags (String ticket) {
        return cacheTicket.get(ticket);
    }

    public Set<String> getTickets (String telemetryTag) {
        return cacheTelemetryId.get(telemetryTag);
    }

    public void remove(String ticket) {
        Set<DeviceTelemetry> telemetries = cacheTicket.remove(ticket);
        removeTicketFromTelemetryIndex(ticket, telemetries);
    }

    private void removeTicketFromTelemetryIndex(String ticket, Set<DeviceTelemetry> telemetries) {
        if (telemetries == null) {
            return;
        }
        for (DeviceTelemetry deviceTelemetry : telemetries) {
            String key = deviceTelemetry.getProductId() + ":" + deviceTelemetry.getDeviceId() + ":" + deviceTelemetry.getTelemetryKey();
            Set<String> tickets = cacheTelemetryId.get(key);
            if (tickets == null) {
                continue;
            }
            tickets.remove(ticket);
            if (tickets.isEmpty()) {
                cacheTelemetryId.remove(key);
            }
        }
    }



}
