//
//  HistoryTableViewPresenter.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//


import Foundation

protocol HistoryTableViewProtocol: class {
    
    func setHistory(history: [String]?)
}

protocol HistoryTableViewPresenterProtocol: class {
    
    init(view: HistoryTableViewProtocol?, dataManager: HistoryDataManagerProtocol?, router: ItunesRouterProtocol?, networkDataFetcher: ItunesNetworkDataFetcherProtocol?)
    
    var history: [String]? { get set }
    
    // get history from UserDefaults
    func getHistory()
    // search from history table
    func searchInHistory(searchText: String)
    // clear search history
    func clearHistory()
}

class HistoryTableViewPresenter: HistoryTableViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: HistoryTableViewProtocol?
    var router: ItunesRouterProtocol?
    var networkDataFetcher: ItunesNetworkDataFetcherProtocol?
    var dataManager: HistoryDataManagerProtocol?
    var history: [String]?
    
    // MARK: - Initializer
    required init(view: HistoryTableViewProtocol?,
                  dataManager: HistoryDataManagerProtocol?,
                  router: ItunesRouterProtocol?,
                  networkDataFetcher: ItunesNetworkDataFetcherProtocol?) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
        self.networkDataFetcher = networkDataFetcher
    }
    
    // MARK: - Methods
    func getHistory() {
        history = dataManager?.getHistory()
        view?.setHistory(history: history)
    }
    
    func searchInHistory(searchText: String) {
        if searchText.isEmpty {
            getHistory()
        } else {
            guard let history = self.history else { return }
            var searchedHistory: [String] = []
            for text in history {
                if text.contains(searchText) {
                    searchedHistory.append(text)
                }
            }
            self.history = searchedHistory
            view?.setHistory(history: searchedHistory)
        }
    }
    
    func clearHistory() {
        dataManager?.clearHistory()
        history = nil
        view?.setHistory(history: history)
    }
}
