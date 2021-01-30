//
//  DetailTableViewCell.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

let detailTableViewCellIdentifier = "detailTableViewCellIdentifier"

class DetailTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
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
            trackImageView.image = nil
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
                self.trackImageView.image = image
                self.indicator.stopAnimating()
            case .failure(let error):
                print (error.localizedDescription)
                self.trackImageView.image = UIImage(.errorImage)
            }
        }
    }

    // MARK: - Public methods
    public func setupDetailTableViewCell(from track: Track?, andRow row: Int) {
        imageURL = track?.artworkUrl60
        numberLabel.text = "\(row + 1)."
        trackNameLabel.text = track?.trackName
        artistNameLabel.text = track?.artistName
    }
}
