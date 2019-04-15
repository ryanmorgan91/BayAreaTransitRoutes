//
//  DirectionsController.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

class DirectionsController {

    let baseURL = URL(string: "https://maps.googleapis.com/maps/api/directions/json?")!
    
    var query: [String: String] = [
        "key": "",
        "mode": "transit",
        "transit_mode": "bus",
        "alternatives": "true"
    ]
    
 
    func fetchDirections(forOrigin origin: String, forDestination destination: String, completion: @escaping (Directions?) -> Void)  {
        query["origin"] = origin
        query["destination"] = destination
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let directions = try? jsonDecoder.decode(Directions.self, from: data) {
                completion(directions)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    var busDistanceQuery: [String: String] = [
        "key": "",
        "mode": "driving",
        "alternatives": "false"
    ]
    
    func fetchBusDistance(forOrigin origin: String, forDestination destination: String, completion: @escaping (Directions?) -> Void)  {
        query["origin"] = origin
        query["destination"] = destination
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let directions = try? jsonDecoder.decode(Directions.self, from: data) {
                completion(directions)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
