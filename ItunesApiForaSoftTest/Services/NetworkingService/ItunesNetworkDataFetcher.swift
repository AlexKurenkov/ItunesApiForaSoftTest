//
//  ItunesNetworkDataFetcher.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import UIKit

// MARK: - Application DataFetcher. NetworkDataFetcher attached by application needs
protocol ItunesNetworkDataFetcherProtocol {
    
    init(networkDataFetcher: NetworkDataFetcherProtocol, urlService: ItunesURLServiceProtocol)
    
    func fetchAlbums(fromName name: String?, completion: @escaping (Result<Albums?, Error>) ->())
    func fetchTracks(fromName name: String?, completion: @escaping (Result<Tracks?, Error>) ->())
    func fetchImage(from url: URL?, completion: @escaping (Result<UIImage?,Error>) ->())
    func fetchImage(from url: String?, completion: @escaping (Result<UIImage?,Error>) ->())
}

struct ItunesNetworkDataFetcher: ItunesNetworkDataFetcherProtocol {
    
    var networkDataFetcher: NetworkDataFetcherProtocol
    var urlService: ItunesURLServiceProtocol
    
    init(networkDataFetcher: NetworkDataFetcherProtocol = NetworkDataFetcher(),
                  urlService: ItunesURLServiceProtocol = ItunesURLService()) {
        self.networkDataFetcher = networkDataFetcher
        self.urlService = urlService
    }
    
    func fetchAlbums(fromName name: String?, completion: @escaping (Result<Albums?, Error>) -> ()) {
        guard let url = urlService.albumUrl(fromName: name) else { return }
        networkDataFetcher.fetchDecodedData(from: url, completion: completion)
    }
    
    func fetchTracks(fromName name: String?, completion: @escaping (Result<Tracks?, Error>)->()) {
        guard let url = urlService.trackUrl(fromName: name) else { return }
        networkDataFetcher.fetchDecodedData(from: url, completion: completion)
    }
    
    func fetchImage(from url: URL?, completion: @escaping (Result<UIImage?,Error>) -> ()) {
        guard let url = url else { return }
        networkDataFetcher.fetchData(from: url) { (result) in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                completion(.success(UIImage(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(from url: String?, completion: @escaping (Result<UIImage?,Error>) -> ()) {
        guard let url = url else { return }
        networkDataFetcher.fetchData(from: url) { (result) in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                completion(.success(UIImage(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    
    
}
