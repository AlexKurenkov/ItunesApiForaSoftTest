//
//  DataManager.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import Foundation

// MARK: - Data Manager for working with UserDefaults
protocol DataManagerProtocol {
    
    func getData<T>(forKey key: String) -> T?
    func setData(data: Any, forKey key: String)
    func deleteData(forKey: String)
}

struct DataManager: DataManagerProtocol {
    
    func setData(data: Any, forKey key: String) {
        let ud = UserDefaults.standard
        ud.setValue(data, forKey: key)
    }
    
    func getData<T>(forKey key: String) -> T? {
        let ud = UserDefaults.standard
        if let data = ud.value(forKey: key) as? T {
            return data
        } else {
            return nil
        }
    }
    
    func deleteData(forKey key: String) {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: key)
    }
}
