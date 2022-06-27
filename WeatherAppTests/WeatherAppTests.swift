//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Jilmon on 23/06/22.
//

import XCTest
@testable import WeatherApp
class WeatherAppTests: XCTestCase {
    var sut: WeatherViewModel!
    override func setUpWithError() throws {
        /// Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = WeatherViewModel()
    }

    override func tearDownWithError() throws {
        /// Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    /// Test network connectivity status
    func testNetworkConnectivity() throws {
        try XCTSkipUnless(
            NetworkManager.shared.isReachable ,
          "Network connectivity needed for this test.")

    }

    /// Test
    func testFetchWeatherUsingMockSession() {

      /// Fake Json data
      let entryjsonString = "{\"code\":200,\"list\":[{\"main\":{\"temp\": 37.05},\"weather\":[{\"main\":\"Clear\"}], \"dt_txt\":\"2022-06-25 18:00:00\"}], \"city\": {\"name\":\"London\"}}"
      let mockData = entryjsonString.data(using: .utf8)

      /// Url with city name Delhi
      let urlString = Constants.baseURL + String(format:Constants.cityBasedURL, "Delhi",Constants.apiKey)
      guard let url = URL(string: urlString) else { return }
      let mockedResponse = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil)

      let mockedUrlSession = MockURLSession(
        data: mockData,
        response: mockedResponse,
        error: nil)

      NetworkManager.shared.urlSession = mockedUrlSession

      let promise = expectation(description: "Value Received")
      let inputData = WeatherInput(
            lat: "",
            lon: "",
            city: "London",
            type: Constants.weatherInputCity)
       sut.fetchWeather(inputData)
        self.sut.result.bind { weather in
            if weather != nil {
                XCTAssertEqual(weather?.city.name, "London")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
