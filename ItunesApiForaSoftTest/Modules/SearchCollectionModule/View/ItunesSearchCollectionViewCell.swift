//
//  ItunesSearchCollectionViewCell.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

let itunesSearchCollectionViewCellIdentifier = "itunesSearchCollectionViewCellIdentifier"
let standartCollectionViewCellIdentifier = "CollectionViewCellIdentifier"

class ItunesSearchCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                indicator.style = .large
            } else if #available(iOS 12.0, *){
                indicator.style = .gray
            }
        }
    }

    // MARK: - Private Properties
    private var imageURL: String? {
        didSet {
            imageView?.image = nil
            updateUI()
        }
    }
    
    private let networkService = ItunesNetworkDataFetcher()

    // MARK: - Private Methods
    private func updateUI() {
        guard let url = imageURL else { return }
        indicator.startAnimating()
        
        networkService.fetchImage(from: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.imageView.image = image
                self.indicator.stopAnimating()
            case .failure(let error):
                print (error.localizedDescription)
                self.imageView.image = UIImage(.errorImage)
            }
        }
    }

    // MARK: - Public Methods
    public func setupItunesSearchCollectionViewCell(by album: Album?) {
        imageURL = album?.artworkUrl100
        albumNameLabel.text = album?.collectionName
        artistNameLabel.text = album?.artistName
    }
  
}

