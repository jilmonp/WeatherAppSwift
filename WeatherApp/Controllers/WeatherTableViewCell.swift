//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
// Subclass of UITableViewCell to show Date, Description and Temperature in the cell

import UIKit
enum ClimateIcon: String {
    case clear = "Clear"
    case rain = "Rain"
    case snow = "Snow"
    case clouds = "Clouds"
}
class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var weatherDescriptionIcon: UIImageView!
    // Configuring the cells by populating labels with the values of date, description and temperature for 5 days
    func configureCell(_ weatherDay: WeatherDataUnique?) {
        if let weatherDate = weatherDay?.day {
            self.weatherDate.text = weatherDate
        }
        if let weatherDescription = weatherDay?.climate {
            let climate = ClimateIcon(rawValue: weatherDescription)
            switch(climate) {
            case .clouds:
                self.weatherDescriptionIcon.image = UIImage(named: "clouds_icon")
            case .rain:
                self.weatherDescriptionIcon.image = UIImage(named: "rain_icon")
            case .snow:
                self.weatherDescriptionIcon.image = UIImage(named: "snow_icon")
            default:
                self.weatherDescriptionIcon.image = UIImage(named: "clear_icon")
            }
        }
        if let weatherTemperature = weatherDay?.temperature {
            self.weatherTemperature.text = weatherTemperature
        }
    }
}
