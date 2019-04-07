//
//  TransitDetails.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

struct TransitDetails: Codable {
    var arrivalStop: Stop?
    var departureStop: Stop?
    var arrivalTime: Double?
    var departureTime: Double?
    var headsign: String?
    var line: Line?
    
    enum CodingKeys: String, CodingKey {
        case arrivalStop = "arrival_stop"
        case departureStop = "departure_stop"
        case arrivalTime = "arrival_time"
        case departureTime = "departure_time"
        case headsign
        case line
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.arrivalStop = try? container.decode(Stop.self, forKey: CodingKeys.arrivalStop)
        self.departureStop = try? container.decode(Stop.self, forKey: CodingKeys.departureStop)
        self.arrivalTime = try? container.decode(Double.self, forKey: CodingKeys.arrivalTime)
        self.departureTime = try? container.decode(Double.self, forKey: CodingKeys.departureStop)
        self.headsign = try? container.decode(String.self, forKey: CodingKeys.headsign)
        self.line = try? container.decode(Line.self, forKey: CodingKeys.line)
    }
    
    struct Stop: Codable {
        var name: String?
        var location: Location?
    }
    
    struct Line: Codable {
        var agencies: [Agency]?
        var name: String?
        var shortName: String?
        
        enum CodingKeys: String, CodingKey {
            case agencies
            case name
            case shortName = "short_name"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.agencies = try? container.decode([Agency].self, forKey: CodingKeys.agencies)
            self.name = try? container.decode(String.self, forKey: CodingKeys.name)
            self.shortName = try? container.decode(String.self, forKey: CodingKeys.shortName)
        }
    }
}

struct Agency: Codable {
    var name: String?
    var phone: String?
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decode(String.self, forKey: CodingKeys.name)
        self.phone = try? container.decode(String.self, forKey: CodingKeys.phone)
        self.url = try? container.decode(URL.self, forKey: CodingKeys.url)
    }
}
