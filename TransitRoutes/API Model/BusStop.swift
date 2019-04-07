//
//  BusStop.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 4/1/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

struct BusStop: Codable {
    var busStopContents: BusStopContents?
    
    enum CodingKeys: String, CodingKey {
        case busStopContents = "Contents"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.busStopContents = try? container.decode(BusStopContents.self, forKey: CodingKeys.busStopContents)
    }
}

struct BusStopContents: Codable {
    var dataObjects: DataObjects?
    
    enum CodingKeys: String, CodingKey {
        case dataObjects
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dataObjects = try? container.decode(DataObjects.self, forKey: CodingKeys.dataObjects)
    }
}

struct DataObjects: Codable {
    var scheduledStopPoint: [ScheduledStopPoint]?
    
    enum CodingKeys: String, CodingKey {
        case scheduledStopPoint = "ScheduledStopPoint"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scheduledStopPoint = try? container.decode([ScheduledStopPoint].self, forKey: CodingKeys.scheduledStopPoint)
    }
}
    
    
struct ScheduledStopPoint: Codable {
    var id: String?
    var name: String?
    var location: LongLocation?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case location = "Location"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: CodingKeys.id)
        self.name = try? container.decode(String.self, forKey: CodingKeys.name)
        self.location = try? container.decode(LongLocation.self, forKey: CodingKeys.location)
    }
}

struct LongLocation: Codable {
    var longitude: String
    var latitude: String
    
    enum CodingKeys: String, CodingKey {
        case longitude = "Longitude"
        case latitude = "Latitude"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.longitude = try container.decode(String.self, forKey: CodingKeys.longitude)
        self.latitude = try container.decode(String.self, forKey: CodingKeys.latitude)
        
    }
    
}

