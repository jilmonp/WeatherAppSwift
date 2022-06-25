//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
// Subclass of UITableViewCell to show Date, Description and Temperature in the cell

import UIKit
class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherDate: UILabel!

    // Configuring the cells by populating labels with the values of date, description and temperature for 5 days
    func configureCell(_ weatherItem: List?) {
        if let weatherDate = weatherItem?.date {
            self.weatherDate.text = weatherDate.formatDate(dateString: Constants.weatherDateFormat)
        }
        if let weatherDescription = weatherItem?.weatherDescription[0].description {
            self.weatherDescription.text = weatherDescription
        }
        if let weatherTemperature = weatherItem?.main.temp {
            self.weatherTemperature.text = String(describing: weatherTemperature)
        }
    }
}
// MARK: created extension of String and created a method to format the date
extension String {
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateString
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = Constants.weatherDateNewFormat
        return  dateFormatter.string(from: date)
    }
}
