//
//  DetailViewController.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Constants
    private let tableViewRowHeight: CGFloat = 100.0

    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    // MARK: - UIViewControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        presenter?.getTracks()
        presenter?.setupUI()
        setupTableView()
        setupGestures()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private Methods
    private func setupTableView() {
        tracksTableView.tableFooterView = UIView()
        tracksTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: detailTableViewCellIdentifier)
        tracksTableView.register(UINib(nibName: "TracksNotFoundTableViewCell", bundle: nil), forCellReuseIdentifier: tracksNotFoundTableViewCellIdentifier)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupGestures() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBack(_:)))
        view.addGestureRecognizer(swipe)
    }

    // MARK: - Public Properties
    var presenter: DetailViewPresenterProtocol?
    
    // MARK: - Actions
    @objc func swipeBack(_ sender: UISwipeGestureRecognizer) {
        presenter?.swipeBack()
    }
  
}
// MARK: -UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewRowHeight
    }
}

// MARK: -UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter?.tracks?.count == 0 {
            return 1
        } else {
            return presenter?.tracks?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter?.tracks?.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: tracksNotFoundTableViewCellIdentifier, for: indexPath) as? TracksNotFoundTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: detailTableViewCellIdentifier, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
            cell.setupDetailTableViewCell(from: presenter?.tracks?[indexPath.row], andRow: indexPath.row)
            return cell
        }
    }
}

// MARK: -DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    
    func setupImage(image: UIImage?) {
        imageView.image = image
        indicator.stopAnimating()
    }
    
    func setupUI(from album: Album?) {
        artistNameLabel.text = album?.artistName
        albumNameLabel.text = album?.collectionName
        trackCountLabel.text = "Tracks: \(album?.trackCount ?? 0) "
        releaseDateLabel.text = album?.releaseDate.formatted()
        genreLabel.text = "Genre: \(album?.primaryGenreName ?? "")"
    }
    
    func setTracks(tracks: [Track]?) {
        let range = IndexPath.getInsertedIndexPaths(to: tracks)
            tracksTableView.performBatchUpdates({
                if tracks?.count != 0 {
                    tracksTableView.insertRows(at: range, with: .right)
                } else {
                    // insert not found cell
                    tracksTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                }
            }, completion: nil)
    }
    
    func failure(error: Error) {
        let alertController = UIAlertController.applicationErrorAlert(controllerTitle: "Something's go wrong",
                                                                      cotrollerMessage: error.localizedDescription,
                                                                      actionTitle: "reload",
                                                                      cancelActionTitle: "cancel",
                                                                      actionHandler:  { [weak self] (action) in
                                                                        guard let self = self else { return }
                                                                        self.presenter?.getTracks()
                                                                      })
        self.present(alertController, animated: true, completion: nil)
    }
}
