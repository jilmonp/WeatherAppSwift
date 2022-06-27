//
//  Weather.swift
//  WeatherApp
//
//  Created by Jilmon on 23/06/22.
//

import Foundation

struct Weather: Decodable {
    var list: [List]
    let city: City
    enum CodingKeys: String, CodingKey {
      case list
      case city
    }
}
