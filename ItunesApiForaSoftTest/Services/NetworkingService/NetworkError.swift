//
//  NetworkError.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import Foundation

// MARK: - response error enum
enum NetworkError: Error {
    case noHTTPResponse
    case noDataReceived
    case unacceptableStatusCode
}
