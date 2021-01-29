//
//  ItunesSearchCollectionViewController.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

class ItunesSearchCollectionViewController: UIViewController {
    
    // MARK: -IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                indicator.style = .large
            } else if #available(iOS 12.0, *){
                indicator.style = .gray
            }
        }
    }
    
    // MARK: - UIViewControllerLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        indicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlbums()
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "ItunesSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: itunesSearchCollectionViewCellIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "standartCell")
    }
    
    private func getAlbums() {
        guard
            let view = self.tabBarController as? TabBarViewController,
            let text = view.navigationItem.searchController?.searchBar.text
        else { return }
        if !text.isEmpty {
            presenter?.getAlbums(fromName: text)
        }
    }
    
    // MARK: - Public Properties
    var presenter: ItunesSearchCollectionPresenterProtocol?
    
}

// MARK: -UICollectionViewDelegate
extension ItunesSearchCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectAlbum(album: presenter?.albums?[indexPath.row])
    }
}

// MARK: -UICollectionViewDelegateFlowLayout
extension ItunesSearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat.zero
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat.zero
        
    }
    
}
// MARK: -UICollectionViewDataSource
extension ItunesSearchCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itunesSearchCollectionViewCellIdentifier, for: indexPath) as? ItunesSearchCollectionViewCell else { return UICollectionViewCell() }
        cell.setupItunesSearchCollectionViewCell(by: presenter?.albums?[indexPath.row])
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ItunesSearchCollectionViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tabBarVC = self.tabBarController as? TabBarViewController,
              let searchBar = tabBarVC.navigationItem.searchController?.searchBar
        else { return }
        searchBar.endEditing(true)
    }
}

// MARK: -ItunesSearchCollectionViewProtocol
extension ItunesSearchCollectionViewController: ItunesSearchCollectionViewProtocol {
    
    func setAlbum(albums: [Album]?) {
        guard let albums = albums else { return }
        notFoundLabel.isHidden = albums.count == 0 ? false : true
        indicator.stopAnimating()
        collectionView.reloadData()
    }
    
    func failure(error: Error) {
        
        let alertController = UIAlertController.applicationErrorAlert(controllerTitle: "Something's go wrong",
                                                                      cotrollerMessage: error.localizedDescription,
                                                                      actionTitle: "reload",
                                                                      cancelActionTitle: "cancel",
                                                                      actionHandler:  { [weak self] (action) in
                                                                        guard let self = self else { return }
                                                                        self.presenter?.getAlbums(fromName: "")
                                                                      })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
