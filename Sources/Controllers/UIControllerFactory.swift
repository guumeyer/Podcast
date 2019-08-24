//
//  UIControllerFactory.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-03.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// Controller factory to build the UIViewControllers
public final class UIControllerFactory {
    /// Represents the view types
    ///
    /// - favorites: The favorires view
    /// - search: The search view
    /// - download: The download view
    public enum ViewType {
        /// The favorires view type
        case favorites
        /// The search view type
        case search
        /// The download view type
        case download
    }

    /// Creates a new instance of UIViewController
    ///
    /// - Parameter viewType: the view controller type
    /// - Returns: an UIViewController

    static func create(_ viewType: ViewType) -> UIViewController {
        switch viewType {
        case .favorites:
            let layout = UICollectionViewFlowLayout()
            let favoritesController = FavoritesController(collectionViewLayout: layout)
            return build(with: favoritesController,
                         title: "Favorites",
                         image: UIImage(named: "favorites"))

        case .search:
            return build(with: PodcastsSearchController(),
                         title: "Search",
                         image: UIImage(named: "search"))

        case .download:
            return build(with: DownloadController(),
                         title: "Downloads",
                         image: UIImage(named: "downloads"))
        }
    }

    private static func build(with rootViweController: UIViewController,
                              title: String,
                              image: UIImage? = nil) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViweController)
        rootViweController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        return navController
    }
}
