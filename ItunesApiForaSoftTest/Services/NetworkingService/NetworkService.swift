//
//  NetworkService.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import UIKit

// MARK: - Base Network Service. Create and send requests
protocol NetworkServiceProtocol {
    func request(from url: String, completion: @escaping (Result<Data?,Error>) -> ())
    func request(from url: URL, completion: @escaping (Result<Data?,Error>) -> ())
}

struct NetworkService: NetworkServiceProtocol {
    func request(from url: String, completion: @escaping (Result<Data?,Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        let task = createDataTask(from: url, completion: completion)
        task.resume()
    }
    
    func request(from url: URL, completion: @escaping (Result<Data?,Error>) -> ()) {
        let task = createDataTask(from: url, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from url: URL,
                                completion: @escaping (Result<Data?,Error>) -> ()) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            // on failure
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noHTTPResponse))
                }
                return
            }
            guard response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unacceptableStatusCode))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noDataReceived))
                }
                return
            }
            // on success
            let cache = URLCache.shared
            if let data = cache.cachedResponse(for: request)?.data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
    }
}




