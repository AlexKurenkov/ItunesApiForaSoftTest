//
//  Router.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import UIKit

protocol RouterMainProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?)
}

// MARK: - ItunesRouterProtocol - the abstract protocol required for routing in Application
protocol ItunesRouterProtocol: RouterMainProtocol {
    func showInitialViewController()
    func showDetailViewController(album: Album?)
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?)
    func popToRoot()
}

struct ItunesRouter: ItunesRouterProtocol {
    var assemblyBuilder: AssemblyBuilderProtocol?
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?) {
        self.assemblyBuilder = assemblyBuilder
        self.navigationController = navigationController
    }

    func showInitialViewController() {
        if let navigationVC = navigationController {
            guard let tabBarVC = assemblyBuilder?.createMainTabBarController(router: self) else { return }
            navigationVC.viewControllers = [tabBarVC]
        }
    }

    func showDetailViewController(album: Album?) {
        if let navigationVC = navigationController {
            guard let detailVC = assemblyBuilder?.createDetailViewController(router: self, album: album) else { return }
            navigationVC.pushViewController(detailVC, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            guard let vc = navigationController.viewControllers.first else { return }
            navigationController.popToViewController(vc, animated: true)
        }
    }
}


