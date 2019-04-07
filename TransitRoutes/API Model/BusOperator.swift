//
//  Operator.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation

struct BusOperator: Codable {
    var id: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: CodingKeys.id)
        self.name = try? container.decode(String.self, forKey: CodingKeys.name)
    }
}

