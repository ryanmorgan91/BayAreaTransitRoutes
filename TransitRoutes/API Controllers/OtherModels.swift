//
//  OtherModels.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation


struct Distance: Codable {
    var value: Double
    var text: String
}

struct Location: Codable {
    var lat: Double
    var lng: Double
}

struct Time: Codable {
    var text: String
    var timeZone: TimeZone
    
    enum CodingKeys: String, CodingKey {
        case text
        case timeZone = "time_zone"
    }
   
}

struct Duration: Codable {
    var value: Int
    var text: String
}

struct Polyline: Codable {
    var points: String?
}

struct BusInformation {
    var operatorId: String
    var lineRef: String
    var arrivalStop: TransitDetails.Stop
    var departureStop: TransitDetails.Stop
}
