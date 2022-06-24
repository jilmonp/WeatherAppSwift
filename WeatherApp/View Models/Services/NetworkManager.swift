//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation
import Network
enum NetworkError: Error {
    case apiDown
    case noCity
}
class NetworkManager {
    static let shared = NetworkManager()
    var isReachable: Bool { status == .satisfied }
    private let monitor = NWPathMonitor()
    private var status = NWPath.Status.requiresConnection    
    func startMonitoring() {
      monitor.pathUpdateHandler = { [weak self] path in
        self?.status = path.status
      }
      let queue = DispatchQueue(label: "NetworkMonitor")
      monitor.start(queue: queue)
    }
    func stopMonitoring() {
      monitor.cancel()
    }
    func performRequest<T: Decodable>(with memberType: T.Type, url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
          return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
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
