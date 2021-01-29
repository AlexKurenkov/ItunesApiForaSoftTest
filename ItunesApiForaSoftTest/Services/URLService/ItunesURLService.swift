//
//  ITunesURLService.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import Foundation

// MARK: - Application URLService attached by application needs
protocol ItunesURLServiceProtocol {
    init(urlService: URLServiceProtocol)
    
    func albumUrl(fromName name: String?) -> URL?
    func trackUrl(fromName name: String?) -> URL?
}

class ItunesURLService: ItunesURLServiceProtocol {
    
    var urlService: URLServiceProtocol
    
    required init(urlService: URLServiceProtocol = URLService()) {
        self.urlService = urlService
    }
    
    private var mainURL = "https://itunes.apple.com/search"
    
    func albumUrl(fromName name: String?) -> URL? {
        let term      = URLQueryItem(name: "term", value: name)
        let entity    = URLQueryItem(name: "entity", value: "album")
        let attribute = URLQueryItem(name: "attribure", value: "albumTerm")
        let items: [URLQueryItem] = [term,entity,attribute]
        return urlService.fetchUrlWithComponents(from: mainURL, components: items)
    }
    
    func trackUrl(fromName name: String?) -> URL? {
        let term        = URLQueryItem(name: "term", value: name)
        let entity      = URLQueryItem(name: "entity", value: "song")
        let attribute   = URLQueryItem(name: "attribute", value: "albumTerm")
        let items: [URLQueryItem] = [term,entity,attribute]
        return urlService.fetchUrlWithComponents(from: mainURL, components: items)
    }
    
    
}
