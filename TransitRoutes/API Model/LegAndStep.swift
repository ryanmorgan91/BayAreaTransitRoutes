//
//  Leg.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation


struct Leg: Codable {
    var distance: Distance?
    var startLocation: Location?
    var endLocation: Location?
    var duration: Duration?
    var steps: [Step]?
    var startAddress: String?
    var endAddress: String?
        
    enum CodingKeys: String, CodingKey {
        case distance
        case startLocation = "start_location"
        case endLocation = "end_location"
        case duration
        case steps
        case startAddress = "start_address"
        case endAddress = "end_address"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.distance = try? container.decode(Distance.self, forKey: CodingKeys.distance)
        self.startLocation = try? container.decode(Location.self, forKey: CodingKeys.startLocation)
        self.endLocation = try? container.decode(Location.self, forKey: CodingKeys.endLocation)
        self.duration = try? container.decode(Duration.self, forKey: CodingKeys.duration)
        self.steps = try? container.decode([Step].self, forKey: CodingKeys.steps)
        self.startAddress = try? container.decode(String.self, forKey: CodingKeys.startAddress)
        self.endAddress = try? container.decode(String.self, forKey: CodingKeys.endAddress)
    }
             
    struct Step: Codable {
        var htmlInstructions: String?
        var distance: Distance?
        var startLocation: Location?
        var endLocation: Location?
        var transitDetails: TransitDetails?
        var polyline: Polyline?
        
        enum CodingKeys: String, CodingKey {
            case htmlInstructions = "html_instructions"
            case distance
            case startLocation = "start_location"
            case endLocation = "end_location"
            case transitDetails = "transit_details"
            case polyline
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.htmlInstructions = try? container.decode(String.self, forKey: CodingKeys.htmlInstructions)
            self.distance = try? container.decode(Distance.self, forKey: CodingKeys.distance)
            self.startLocation = try? container.decode(Location.self, forKey: CodingKeys.startLocation)
            self.endLocation = try? container.decode(Location.self, forKey: CodingKeys.endLocation)
            self.transitDetails = try? container.decode(TransitDetails.self, forKey: CodingKeys.transitDetails)
            self.polyline = try? container.decode(Polyline.self, forKey: CodingKeys.polyline)
        }
    }
}

