//
//  Extension.swift
//  WeatherApp
//
//  Created by ADMIN on 27/06/22.
//

import Foundation
// MARK: created extension of String and created a method to format the date
extension String {
    func formatDate(_ type: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.weatherDateFormat
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        switch(type) {
        case .day:
            dateFormatter.dateFormat = Constants.weatherDateNewFormat
        case .hour:
            dateFormatter.dateFormat = Constants.weatherHourNewFormat
        }
        return  dateFormatter.string(from: date)
    }
}
// MARK: To remove duplicate elements from an Array
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
// MARK: to convert double value into temperature measurement value
extension Double {
    func measurementForTemperature() -> String {
        let measurement = Measurement(value: self, unit: UnitTemperature.celsius)
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        return measurementFormatter.string(from: measurement)
    }
}
