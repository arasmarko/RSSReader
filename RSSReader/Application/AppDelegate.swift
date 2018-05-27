//
//  AppDelegate.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import UIKit
import UserNotifications

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

        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge];
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                print("Authorization granted")
            }
        }

        return true
    }
}

