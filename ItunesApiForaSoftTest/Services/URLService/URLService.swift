//
//  URLService.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import Foundation

// MARK: - URL Service. creates url from queryItems
protocol URLServiceProtocol {
    func fetchUrlWithComponents(from url: String, components: [URLQueryItem]) -> URL?
}

struct URLService: URLServiceProtocol {
    
    public func fetchUrlWithComponents(from url: String, components: [URLQueryItem] = []) -> URL? {
        guard var urlComponents = URLComponents(string: url) else { return nil }
        urlComponents.queryItems = components
        guard let url = urlComponents.url else { return nil }
        return url
    }
}
