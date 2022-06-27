//
//  MockURLSession.swift
//  WeatherApp
//
//  Created by Jilmon on 23/06/22.

import Foundation

///  Create subclasses of URLSession and URLSessionDataTask to pass fake input for unit testing.
///  Overriding dataTask and resume methods
///
typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

// MARK: Subclass of URLSession to add fake Input data
class MockURLSession: URLSession {
  private let mockedData: Data?
  private let mockedResponse: URLResponse?
  private let mockedError: Error?

  public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
    self.mockedData = data
    self.mockedResponse = response
    self.mockedError = error
  }

  public override func dataTask( with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
      URLSessionMockDataTask(
      mockedData: mockedData,
      mockedResponse: mockedResponse,
      mockedError: mockedError,
      completionHandler: completionHandler
    )
  }
}

// MARK: Subclass of URLSessionDataTask 
class URLSessionMockDataTask: URLSessionDataTask {
  private let mockedData: Data?
  private let mockedResponse: URLResponse?
  private let mockedError: Error?
  private let completionHandler: DataTaskCompletionHandler?

  init(
    mockedData: Data? = nil,
    mockedResponse: URLResponse? = nil,
    mockedError: Error? = nil,
    completionHandler: DataTaskCompletionHandler? = nil
  ) {
    self.mockedData = mockedData
    self.mockedResponse = mockedResponse
    self.mockedError = mockedError
    self.completionHandler = completionHandler
  }
  /// overriding resume method of URLSessionTask
  override func resume() {
    completionHandler?(mockedData, mockedResponse, mockedError)
  }
}
