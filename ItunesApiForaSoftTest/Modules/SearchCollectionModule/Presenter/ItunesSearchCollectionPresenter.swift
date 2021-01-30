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
    
    init(view: ItunesSearchCollectionViewProtocol?,
         dataManager: HistoryDataManagerProtocol?,
         router: ItunesRouterProtocol?,
         networkDataFetcher: ItunesNetworkDataFetcherProtocol?)
    
    var albums: [Album]? { get set }
    
    // show detail view
    func didSelectAlbum(album: Album?)
    // save searched text
    func saveSearchTextToHistory(text: String)
    // search album from network
    func searchAlbum(with searchText: String)
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
    
    // MARK: - Private Methods
    // private network methods for fetch albums information
    private func getAlbums(fromName name: String) {
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
    
    // MARK: - Methods
    // work with UI before searching and after searching
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
    
    // show detailVC after select collectionViewCell (Album)
    func didSelectAlbum(album: Album?) {
        router?.showDetailViewController(album: album)
    }
    
    // save searched text from search bar to UserDefaults
    func saveSearchTextToHistory(text: String) {
        dataManager?.addTextToHistory(text: text)
    }
}


