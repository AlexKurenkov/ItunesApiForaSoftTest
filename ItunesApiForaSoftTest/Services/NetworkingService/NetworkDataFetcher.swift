//
//  NetworkDataFetcher.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import Foundation

// MARK: - Base NetworkDataFetcher. fetch data with NetworkService requests, fetch decoded data, decoded by JSONDecoder
protocol NetworkDataFetcherProtocol {
    
    init(networkService: NetworkServiceProtocol)
    
    func fetchData(from url: String, completion: @escaping (Result<Data?,Error>) -> ())
    func fetchData(from url: URL, completion: @escaping (Result<Data?,Error>) -> ())
    func fetchDecodedData<T: Decodable>(from url: String, completion: @escaping (Result<T?,Error>) -> ())
    func fetchDecodedData<T: Decodable>(from url: URL, completion: @escaping (Result<T?,Error>) -> ())
}

struct NetworkDataFetcher: NetworkDataFetcherProtocol {
    
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchData(from url: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        networkService.request(from: url, completion: completion)
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        networkService.request(from: url, completion: completion)
    }
    
    func fetchDecodedData<T>(from url: String, completion: @escaping (Result<T?, Error>) -> ()) where T : Decodable {
        networkService.request(from: url) { (result) in
            switch result {
            case .success(let data):
                let object = JSONDecoder.getDecodedData(type: T.self, from: data)
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDecodedData<T>(from url: URL, completion: @escaping (Result<T?, Error>) -> ()) where T : Decodable {
        networkService.request(from: url) { (result) in
            switch result {
            case .success(let data):
                let object = JSONDecoder.getDecodedData(type: T.self, from: data)
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
