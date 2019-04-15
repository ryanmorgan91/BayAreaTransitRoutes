//
//  TransitController.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

class TransitController {
    
    func fetchOperatorIDs(completion: @escaping ([BusOperator]?) -> Void) {
        let baseURL = URL(string: "http://api.511.org/transit/operators?")!
        
        var query: [String: String] = [
            "api_key": "",
            "format": "json"
        ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let busOperators = try? jsonDecoder.decode([BusOperator].self, from: data) {
                completion(busOperators)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func fetchBusLocation(forOperatorId operatorId: String, forLineRef lineRef: String, completion: @escaping ([BusLocation]?) -> Void) {
        
        let baseURL = URL(string: "http://api.511.org/transit/VehicleMonitoring?")!
        var query: [String: String] = [
            "api_key": "",
            "agency": operatorId
        ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let busLocation = try? jsonDecoder.decode(BusLocation.self, from: data) {
                completion([busLocation])
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchStopId(forOperatorId operatorId: String, completion: @escaping ([BusStop]?) -> Void) {
        
        var query: [String: String] = [
            "api_key": "25cd4c1d-7294-4d82-b167-4c3fb0342278",
            "operator_id": "SC"
        ]
        
        let baseURL = URL(string: "http://api.511.org/transit/stops?")!
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let busStop = try? jsonDecoder.decode(BusStop.self, from: data) {
                completion([busStop])
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

