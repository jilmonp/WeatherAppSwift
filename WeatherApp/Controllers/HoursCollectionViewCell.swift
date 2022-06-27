//
//  HoursCollectionViewCell.swift
//  WeatherApp
//
//  Created by Jilmon on 26/06/22.
//

import UIKit

class HoursCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    func configure(weatherDay: List?) {
        self.timeLabel.text = weatherDay?.date.formatDate(.hour)
        if let temperature = weatherDay?.main.temp {
            self.temperatureLabel.text = temperature.measurementForTemperature()
        }
    }
}
