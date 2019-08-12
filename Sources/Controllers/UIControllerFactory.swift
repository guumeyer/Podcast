//
//  UIControllerFactory.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-03.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// Controller factory to build the UIViewControllers
final public class UIControllerFactory {
 
    public enum ViewType {
        case favorites
        case search
        case donwload
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
        case .donwload:
            return build(with: DonwloadController(),
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
