//
//  IdentifiedBus.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 4/5/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import CoreLocation

struct BusAndDistance {
    var distance: Double
    var distanceString: String
    var vehicleActivity: VehicleActivity
    var position: CLLocationCoordinate2D
}

struct BusAndPosition {
    var vehicleActivity: VehicleActivity
    var position: CLLocationCoordinate2D
}
