//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
struct WeatherInput {
    let lat: String?
    let lon: String?
    let city: String?
    let type: String?
}
protocol AlertViewHandler {
    func alertView(title: String, message: String)
}
public class WeatherViewModel: NSObject {
    var result: Bindable<Weather?> = Bindable(nil)
    var alertViewDelegate: AlertViewHandler?
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
            self.alertViewDelegate?.alertView(title: Constants.alertTitle, message: Constants.networkErrorMsg)
        }
    }
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
    func alertView(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertViewDelegate?.alertView(title: title, message: message)
        }
    }
}