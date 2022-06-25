//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
import Network

// These are the errors this class might return
enum NetworkError: Error {
    case apiDown
    case noCity
}

// This class is created to make network requests.
// It also monitor the network accessibility using Network framework
class NetworkManager {
    var urlSession: URLSession = URLSession.shared
    static let shared = NetworkManager()
    var isReachable: Bool { status == .satisfied }
    private let monitor = NWPathMonitor()
    private var status = NWPath.Status.requiresConnection

    // Create and configure path monitor
    // Closure gets called every time the connection status changes.
    // Create a DispatchQueue instance for the monitor to run
    func startMonitoring() {
      monitor.pathUpdateHandler = { [weak self] path in
        self?.status = path.status
      }
      let queue = DispatchQueue(label: "NetworkMonitor")
      monitor.start(queue: queue)
    }

    // Stop monitoring the connection status
    func stopMonitoring() {
      monitor.cancel()
    }

    // Request data from the endpoint
    // - Parameters
    //   - url: the URL
    //   - modelType: Metatype of the model. Passing type of generic parameter since T is Decodable.
    //   - completion: The completion closure, returning a Result of either the Generic Type or an Error

    func performRequest<T: Decodable>(with modelType: T.Type, url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
          return
        }
        let task = urlSession.dataTask(with: url) { data, _, error in
          do {
            guard
              let data = data, error == nil
            else {
              completion(.failure(.apiDown))
              return
            }
              let result = try JSONDecoder().decode(T.self, from: data)
              completion(.success(result))
          } catch {
              completion(.failure(.noCity))
          }
        }
        task.resume()
    }
}
