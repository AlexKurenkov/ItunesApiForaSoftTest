//
//  IndexPath + InsertedIndexPath.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import Foundation

// MARK: - Need for get a sequnce to perform batch update in table view
extension IndexPath {
    
    static func getInsertedIndexPaths(from a1: [Any]? = [], to a2: [Any]?) -> [IndexPath] {
        guard a1 != nil, a2 != nil else { return [] }
        var insertedIndexPaths: [IndexPath] = []
        let insertRange = a1!.count..<a2!.count + a1!.count
        for i in insertRange {
            insertedIndexPaths.append(IndexPath(row: i, section: 0))
        }
        return insertedIndexPaths
    }
}


