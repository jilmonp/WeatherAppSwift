//
//  List.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
struct List: Decodable {
    let main: Temperature
    let date: String
    let weatherDescription: [WeatherDescription]
    enum CodingKeys: String, CodingKey {
      case main
      case date = "dt_txt"
      case weatherDescription = "weather"
    }
}
