//
//  AppDelegate.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        guard let window = window else { return false }
        let feedsService = FeedsService()
        let feedsViewModel = FeedsViewModel(feedsService: feedsService)
        let feedsViewController = FeedsViewController(viewModel: feedsViewModel)
        let navigationController = UINavigationController(rootViewController: feedsViewController)
        window.rootViewController = navigationController
        return true
    }
}

