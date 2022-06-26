//
//  Constants.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
struct Constants {
    static let apiKey = "eff8d26ad3b725c3e9fc01609b54819a"
    static let baseURL = "https://api.openweathermap.org/data/2.5/forecast?"
    static let locationBasedURL = "lat=%@&lon=%@&appid=%@"
    static let cityBasedURL = "q=%@&units=metric&appid=%@"
    static let dsc_image = "date_dsc"
    static let asc_image = "date_asc"
    static let searchPlaceHolder = "Search"
    static let weatherInputCity = "city"
    static let weatherInputLocation = "location"
    static let alertTitle = "Message"
    static let networkErrorMsg = "Internet connectivity is not available"
    static let apiErrorMsg = "API is not accessible"
    static let invalidCityMsg = "City name is invalid"
    static let weatherDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let weatherDateNewFormat = "EE"
    static let weatherHourNewFormat = "hh:mm"
}
