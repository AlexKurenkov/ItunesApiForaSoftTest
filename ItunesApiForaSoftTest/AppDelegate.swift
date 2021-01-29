//
//  AppDelegate.swift
//  ItunesApiForaSoftTest
//
//  Created by Александр on 26.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let navigationVC = UINavigationController()
        let assemblyBuilder = AssemblyBuilder()
        let router = ItunesRouter(navigationController: navigationVC, assemblyBuilder: assemblyBuilder)
        router.showInitialViewController()
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

