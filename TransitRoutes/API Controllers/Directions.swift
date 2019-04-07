//
//  Directions.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

struct Directions: Codable {
    var status: String?
    var geocodedWaypoints: [Waypoints]?
    var routes: [Route]?
    var availableTravelModes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case geocodedWaypoints = "geocoded_waypoints"
        case routes = "routes"
        case availableTravelModes = "available_travel_modes"
    }
}

struct Waypoints: Codable {
    var geocoderStatus: String?
    var placeId: String?
    var types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeId = "place_id"
        case types = "types"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.geocoderStatus = try? container.decode(String.self, forKey: CodingKeys.geocoderStatus)
        self.placeId = try? container.decode(String.self, forKey: CodingKeys.placeId)
        self.types = try? container.decode([String].self, forKey: CodingKeys.types)
    }
}

struct Route: Codable {
    var summary: String?
    var legs: [Leg]?
    var waypointOrder: [Int]?
    var copyrights: String?
    var warnings: [String]?
    var overviewPolyline: Polyline?
    
    enum CodingKeys: String, CodingKey {
        case summary
        case legs
        case waypointOrder = "waypoint_order"
        case copyrights
        case warnings
        case overviewPolyline = "overview_polyline"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.summary = try? container.decode(String.self, forKey: CodingKeys.summary)
        self.legs = try? container.decode([Leg].self, forKey: CodingKeys.legs)
        self.waypointOrder = try? container.decode([Int].self, forKey: CodingKeys.waypointOrder)
        self.copyrights = try? container.decode(String.self, forKey: CodingKeys.copyrights)
        self.warnings = try? container.decode([String].self, forKey: CodingKeys.warnings)
        self.overviewPolyline = try? container.decode(Polyline.self, forKey: CodingKeys.overviewPolyline)
    }
}


