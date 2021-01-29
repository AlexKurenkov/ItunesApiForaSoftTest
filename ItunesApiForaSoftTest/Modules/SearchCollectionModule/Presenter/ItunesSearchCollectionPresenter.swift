//
//  ItunesSearchCollectionPresenter.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import Foundation

protocol ItunesSearchCollectionViewProtocol: class {
    func setAlbum(albums: [Album]?)
    func failure(error: Error)
}

protocol ItunesSearchCollectionPresenterProtocol: class {
    // getAlbums from network
    func getAlbums(fromName name: String)
    // show detail view
    func didSelectAlbum(album: Album?)
    // save searched text
    func saveSearchTextToHistory(text: String)
    // search album 
    func searchAlbum(with searchText: String)
    
    var albums: [Album]? { get set }
    
    init(view: ItunesSearchCollectionViewProtocol?, dataManager: HistoryDataManagerProtocol?, router: ItunesRouterProtocol?, networkDataFetcher: ItunesNetworkDataFetcherProtocol?)
}

class ItunesSearchCollectionPresenter: ItunesSearchCollectionPresenterProtocol {
    // MARK: - Properties
    weak var view: ItunesSearchCollectionViewProtocol?
    var networkDataFetcher: ItunesNetworkDataFetcherProtocol?
    var router: ItunesRouterProtocol?
    
    var albums: [Album]?
    var dataManager: HistoryDataManagerProtocol?
    
    private var timer = Timer()
    
    // MARK: - Initializer
    required init(view: ItunesSearchCollectionViewProtocol?,
                  dataManager: HistoryDataManagerProtocol?,
                  router: ItunesRouterProtocol?,
                  networkDataFetcher: ItunesNetworkDataFetcherProtocol?) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
        self.networkDataFetcher = networkDataFetcher
    }
    
    // MARK: - Methods
    func getAlbums(fromName name: String) {
        networkDataFetcher?.fetchAlbums(fromName: name, completion: { [weak self] (result) in
            switch result {
            case .success(let albums):
                let albums = albums?.results.sorted { $0.collectionName < $1.collectionName }
                self?.albums = albums
                self?.view?.setAlbum(albums: albums)
            case .failure(let error): self?.view?.failure(error: error)
            }
        })
    }
    
    func searchAlbum(with searchText: String) {
        guard let view = self.view as? ItunesSearchCollectionViewController else { return }
        view.notFoundLabel?.isHidden = true
        if searchText.isEmpty {
            albums = nil
            view.collectionView.reloadData()
        } else {
            view.indicator?.startAnimating()
            timer.invalidate()
            albums = nil
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { [weak self]_ in
                self?.saveSearchTextToHistory(text: searchText)
                self?.getAlbums(fromName: searchText)
            })
        }
    }
    
    func didSelectAlbum(album: Album?) {
        router?.showDetailViewController(album: album)
    }
    
    func saveSearchTextToHistory(text: String) {
        dataManager?.addTextToHistory(text: text)
    }
    
    
}


