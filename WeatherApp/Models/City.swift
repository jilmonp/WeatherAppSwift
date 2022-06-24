//
//  City.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
struct City: Decodable {
    let name: String
    enum CodingKeys: String, CodingKey {
      case name
    }
}
