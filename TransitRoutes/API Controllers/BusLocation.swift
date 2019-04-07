//
//  BusLocation.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 4/1/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

struct BusLocation: Codable {
    var siri: Siri
    
    enum CodingKeys: String, CodingKey {
        case siri = "Siri"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.siri = try container.decode(Siri.self, forKey: CodingKeys.siri)
    }
}

struct Siri: Codable {
    var serviceDelivery: ServiceDelivery
    
    enum CodingKeys: String, CodingKey {
        case serviceDelivery = "ServiceDelivery"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serviceDelivery = try container.decode(ServiceDelivery.self, forKey: CodingKeys.serviceDelivery)
    }
}



struct ServiceDelivery: Codable {
    var vehicleMonitoringDelivery: VehicleMonitoringDelivery
    
    enum CodingKeys: String, CodingKey {
        case vehicleMonitoringDelivery = "VehicleMonitoringDelivery"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicleMonitoringDelivery = try container.decode(VehicleMonitoringDelivery.self, forKey: CodingKeys.vehicleMonitoringDelivery)
    }
}

struct VehicleMonitoringDelivery: Codable {
    var vehicleActivity: [VehicleActivity]
    
    enum CodingKeys: String, CodingKey {
        case vehicleActivity = "VehicleActivity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicleActivity = try container.decode([VehicleActivity].self, forKey: CodingKeys.vehicleActivity)
    }
}

struct VehicleActivity: Codable {
    var monitoredVehicleJourney: MonitoredVehicleJourney
    
    enum CodingKeys: String, CodingKey {
        case monitoredVehicleJourney = "MonitoredVehicleJourney"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.monitoredVehicleJourney = try container.decode(MonitoredVehicleJourney.self, forKey: CodingKeys.monitoredVehicleJourney)
    }
}

struct MonitoredVehicleJourney: Codable {
    var vehicleLocation: LongLocation
    var lineRef: String
    var monitoredCall: CallData?
    var onwardCall: OnwardCall?
    var vehicleRef: String?
    
    enum CodingKeys: String, CodingKey {
        case vehicleLocation = "VehicleLocation"
        case lineRef = "LineRef"
        case monitoredCall = "MonitoredCall"
        case onwardCall = "OnwardCall"
        case vehicleRef = "VehicleRef"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicleLocation = try container.decode(LongLocation.self, forKey: CodingKeys.vehicleLocation)
        self.lineRef = try container.decode(String.self, forKey: CodingKeys.lineRef)
        self.monitoredCall = try? container.decode(CallData.self, forKey: CodingKeys.monitoredCall)
        self.onwardCall = try? container.decode(OnwardCall.self, forKey: CodingKeys.onwardCall)
        self.vehicleRef = try? container.decode(String.self, forKey: CodingKeys.vehicleRef)
    }
}

struct OnwardCall: Codable {
    var callData: [CallData]?
    
    enum CodingKeys: String, CodingKey {
        case callData = "OnwardCall"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.callData = try? container.decode([CallData].self, forKey: CodingKeys.callData)
    }
}

struct CallData: Codable {
    var stopName: String?
    var stopPointRef: String?
    
    enum CodingKeys: String, CodingKey {
        case stopName = "StopPointName"
        case stopPointRef = "StopPointRef"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stopName = try? container.decode(String.self, forKey: CodingKeys.stopName)
        self.stopPointRef = try? container.decode(String.self, forKey: CodingKeys.stopPointRef)
    }
}

