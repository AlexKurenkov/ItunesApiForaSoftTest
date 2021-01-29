//
//  DetailViewPresenter.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

protocol DetailViewProtocol: class {
    func setupImage(image: UIImage?)
    func setupUI(from album: Album?)
    func setTracks(tracks: [Track]?)
    func failure(error: Error)
}

protocol DetailViewPresenterProtocol: class {
    func getTracks()
    func setupUI()
    func swipeBack()
    
    var tracks: [Track]? { get set }
    var album: Album? { get set }
    
    init(view: DetailViewProtocol?, album: Album?, router: ItunesRouterProtocol?, networkDataFetcher: ItunesNetworkDataFetcherProtocol?)
}

class DetailViewPresenter: DetailViewPresenterProtocol {
    
    //MARK: - Properties
    weak var view: DetailViewProtocol?
    var networkDataFetcher: ItunesNetworkDataFetcherProtocol?
    var router: ItunesRouterProtocol?
    
    var tracks: [Track]?
    var album: Album?
    
    // MARK: - Initializer
    required init(view: DetailViewProtocol?, album: Album?, router: ItunesRouterProtocol?, networkDataFetcher: ItunesNetworkDataFetcherProtocol?) {
        self.view = view
        self.album = album
        self.router = router
        self.networkDataFetcher = networkDataFetcher
    }
    
    // MARK: - Private Methods
    private func trackConfirmation(tracks: [Track]?) -> [Track] {
        guard let tracks = tracks else { return [] }
        var result: [Track] = []
        for track in tracks {
            if track.collectionId == album?.collectionId {
                result.append(track)
            }
        }
        return result
    }
    
    private func getImage() {
        networkDataFetcher?.fetchImage(from: album?.artworkUrl100, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image): self.view?.setupImage(image: image)
            case .failure(let error):
                self.view?.setupImage(image: UIImage(.errorImage))
                self.view?.failure(error: error)
            }
        })
    }

    // MARK: - Methods
    func getTracks() {
        networkDataFetcher?.fetchTracks(fromName: album?.collectionName, completion: { [weak self] (result) in
            switch result {
            case .success(let tracks):
                let tracks = self?.trackConfirmation(tracks: tracks?.results).sorted { $0.trackName < $1.trackName }
                self?.tracks = tracks
                self?.view?.setTracks(tracks: tracks)
            case .failure(let error):
                self?.view?.failure(error: error)
            }
        })
    }
    
    func setupUI() {
        view?.setupUI(from: album)
        getImage()
    }
    
    func swipeBack() {
        router?.popToRoot()
    }

}


