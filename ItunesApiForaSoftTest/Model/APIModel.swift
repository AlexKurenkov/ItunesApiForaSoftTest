//
//  APIModel.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import Foundation

// MARK: - Itunes Api Model. https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/

// MARK: - Album

struct Albums: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    let artistId: Int
    let collectionId: Int
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let releaseDate: String
    let trackCount: Int
    let primaryGenreName: String
}


// MARK: - Track

struct Tracks: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    let collectionId: Int
    let artistName: String
    let trackName: String
    let artworkUrl60: String
}
