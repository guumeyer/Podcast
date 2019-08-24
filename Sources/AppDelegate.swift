//
//  AppDelegate.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Loads the database
        PodcastDataManager.default.load()

        // Custom the UI Appearence
        Appearance.apply()

        // Setup the URLCache
        URLCache.setupCache()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabController()
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession handleEventsForBackgroundURLSessionidentifier: String,
                     completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        try? PodcastDataManager.default.saveViewContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? PodcastDataManager.default.saveViewContext()
    }
}
