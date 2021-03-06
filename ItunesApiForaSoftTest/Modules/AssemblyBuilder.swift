//  AssemblyBuilder.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    
    func createMainTabBarController(router: ItunesRouterProtocol) -> UITabBarController
    func createDetailViewController(router: ItunesRouterProtocol, album: Album?) -> DetailViewController
    func createSearchCollectionViewController(router: ItunesRouterProtocol) -> ItunesSearchCollectionViewController
    func createHistoryTableViewController(router: ItunesRouterProtocol) -> HistoryTableViewController
}

struct AssemblyBuilder: AssemblyBuilderProtocol {

    func createMainTabBarController(router: ItunesRouterProtocol) -> UITabBarController {
        let searchCVC = createSearchCollectionViewController(router: router)
        searchCVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: Tags.searchVCTabBarItemTag)

        let historyTVC = createHistoryTableViewController(router: router)
        historyTVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: Tags.historyVCTabBarItemTag)
        historyTVC.delegate = searchCVC as? HistoryTableViewControllerDelegate

        let tabBarController = TabBarViewController()
        tabBarController.setViewControllers([searchCVC,historyTVC], animated: true)

        return tabBarController
    }
    
    func createDetailViewController(router: ItunesRouterProtocol, album: Album?) -> DetailViewController {
        let view = DetailViewController()
        let networkDataFetcher = ItunesNetworkDataFetcher()
        let presenter = DetailViewPresenter(view: view, album: album, router: router, networkDataFetcher: networkDataFetcher)
        view.presenter = presenter
        return view
    }

    func createSearchCollectionViewController(router: ItunesRouterProtocol) -> ItunesSearchCollectionViewController {
        let view = ItunesSearchCollectionViewController()
        let networkDataFetcher = ItunesNetworkDataFetcher()
        let dataManager = HistoryDataManager()
        let presenter = ItunesSearchCollectionPresenter(view: view,
                                                        dataManager: dataManager,
                                                        router: router,
                                                        networkDataFetcher: networkDataFetcher)
        view.presenter = presenter
        return view
    }

    func createHistoryTableViewController(router: ItunesRouterProtocol) -> HistoryTableViewController {
        let view = HistoryTableViewController()
        let dataManager = HistoryDataManager()
        let networkDataFetcher = ItunesNetworkDataFetcher()
        let presenter = HistoryTableViewPresenter(view: view,
                                                  dataManager: dataManager,
                                                  router: router,
                                                  networkDataFetcher: networkDataFetcher)
        view.presenter = presenter
        return view
    }
}
