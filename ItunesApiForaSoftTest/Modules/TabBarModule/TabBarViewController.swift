//
//  TabBarViewController.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 28.01.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - UIViewControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAlbumNavigationBar()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isEditing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isEditing = false
    }


    // MARK: - Visual Components
    public var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Private Methods
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setupNavigationBar(searchPlaceholderText text: String,
                                    searchBarTag tag: Int,
                                    title: String,
                                    rightBarButton: UIBarButtonItem?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 12.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        navigationItem.largeTitleDisplayMode = .automatic
        searchController.searchBar.placeholder = text
        searchController.searchBar.tag = tag
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setAlbumNavigationBar() {
        setupNavigationBar(searchPlaceholderText: "Enter Artist name",
                           searchBarTag: Tags.searchVCSearchBarTag,
                           title: "Albums",
                           rightBarButton: nil)
    }
    
    private func setHistoryNavigationBar() {
        let barButton = UIBarButtonItem(title: "Clear History", style: .plain, target: self, action: #selector(rightBarButtonItemAction(_:)))
        setupNavigationBar(searchPlaceholderText: "Search from history",
                           searchBarTag: Tags.historyVCSearchBarTag,
                           title: "History",
                           rightBarButton: barButton)
    }
    
    private func searchAlbum(from searchText: String) {
        guard let view = self.selectedViewController as? ItunesSearchCollectionViewController else { return }
        view.presenter?.searchAlbum(with: searchText)
        
    }
    
    private func searchHistory(from searchText: String) {
        guard let view = self.selectedViewController as? HistoryTableViewController else { return }
        view.presenter?.searchInHistory(searchText: searchText)
    }
    
    // MARK: - Actions
    @objc func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        guard let view = tabBarController?.selectedViewController as? HistoryTableViewController else { return }
        view.presenter?.clearHistory()
    }

}

//MARK: -UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case let view where view is ItunesSearchCollectionViewController: setAlbumNavigationBar()
        case let view where view is HistoryTableViewController: setHistoryNavigationBar()
        default: break
        }
    }
}

// MARK: -UISearchBarDelegate
extension TabBarViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchBar.tag {
        case Tags.searchVCSearchBarTag:
            searchAlbum(from: searchText)
        case Tags.historyVCSearchBarTag:
            searchHistory(from: searchText)
        default: break
        }
    }
}

// MARK: -UISearchControllerDelegate
extension TabBarViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        switch searchController.searchBar.tag {
        case Tags.searchVCSearchBarTag:
            searchAlbum(from: "")
        case Tags.historyVCSearchBarTag:
            searchHistory(from: "")
        default:break
        }
        
    }

}














