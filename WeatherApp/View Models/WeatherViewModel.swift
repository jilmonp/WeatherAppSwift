//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation

// Use WeatherInput to create input data for weather web api
struct WeatherInput {
    let lat: String?
    let lon: String?
    let city: String?
    let type: String?
}
// U
struct WeatherDataUnique {
    var day: String?
    var climate: String?
    var temperature: String?
}
enum DateType {
    case day
    case hour
}
// This is the view model class for Weather data
public class WeatherViewModel: NSObject {
    var result: Bindable<Weather?> = Bindable(nil)
    var alertViewDelegate: AlertViewHandlerProtocol?

    // Create url to call weather web api and check internet connectivity.
    // Finally call method which send request for weather data
    func fetchWeather(_ inputData: WeatherInput) {
        var urlString = ""
        if inputData.type == Constants.weatherInputLocation {
            urlString = Constants.baseURL + String(format:Constants.locationBasedURL, inputData.lat ?? "", inputData.lon ?? "", Constants.apiKey)
        } else {
            urlString = Constants.baseURL + String(format:Constants.cityBasedURL, inputData.city ?? "",Constants.apiKey)
        }
        if NetworkManager.shared.isReachable {
            callWeatherApi(urlString)
        } else {
            self.alertView(title: Constants.alertTitle, message: Constants.networkErrorMsg)
        }
    }

    // Call Weather web api
    func callWeatherApi(_ urlString: String) {
        NetworkManager.shared.performRequest(with: Weather.self, url: urlString,
                                             completion: { [weak self] result in
                                                guard let self = self else { return }
                                                switch result {
                                                case .success(let weatherData):
                                                    self.result.value = weatherData
                                                case .failure(let error):
                                                    switch error {
                                                    case .apiDown:
                                                        self.alertView(title: Constants.alertTitle, message: Constants.apiErrorMsg )
                                                    case .noCity:
                                                        self.alertView(title: Constants.alertTitle, message: Constants.invalidCityMsg)
                                                    }
                                                }
        })
    }
    // Tells the class who adopted the method of AlertViewHandlerProtocol to implement the same
    func alertView(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertViewDelegate?.alertView(title: title, message: message)
        }
    }
}
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
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
