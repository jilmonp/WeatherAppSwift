//
//  WeatherDescription.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
struct WeatherDescription: Decodable {
    let description: String
    enum CodingKeys: String, CodingKey {
      case description = "main"
    }
}
