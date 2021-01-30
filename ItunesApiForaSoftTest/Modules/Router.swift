//
//  Router.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import UIKit

protocol RouterMainProtocol {
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?)
    
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

// MARK: - ItunesRouterProtocol - the abstract protocol required for routing in Application
protocol ItunesRouterProtocol: RouterMainProtocol {
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?)
    
    func showInitialViewController()
    func showDetailViewController(album: Album?)
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
            navigationController.popToRootViewController(animated: true)
        }
    }
}


