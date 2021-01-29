//
//  HistoryDataManager.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import Foundation

// MARK: - Application DataManager attached by application needs
protocol HistoryDataManagerProtocol {
    init(dataManager: DataManagerProtocol)
    func addTextToHistory(text: String)
    func getHistory() -> [String]
    func clearHistory()
}

struct HistoryDataManager: HistoryDataManagerProtocol {
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    func addTextToHistory(text: String) {
        var history: [String] = []
        if let cachedHistory:[String] = dataManager.getData(forKey: UserDefaults.DefaultKeys.history) {
            history = cachedHistory
            if !cachedHistory.contains(text) {
                history.append(text)
            }
        } else {
            history.append(text)
        }
        dataManager.setData(data: history, forKey: UserDefaults.DefaultKeys.history)
    }
    
    func getHistory() -> [String] {
        let history: [String] = []
        if let cachedHistory:[String] = dataManager.getData(forKey: UserDefaults.DefaultKeys.history) {
            return cachedHistory
        } else {
            return history
        }
    }
    
    func clearHistory() {
        dataManager.deleteData(forKey: UserDefaults.DefaultKeys.history)
    }
}
