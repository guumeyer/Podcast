//
//  MainTabController.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// The main tab bar controller.
final class MainTabController: UITabBarController {

    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!

    let playerView: PlayerView = {
        let playerView = PlayerView.instanceFromNib()
        playerView.backgroundColor = .white
        return playerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()

        setupPlayerView()
    }

    @objc func minimazePlayerViewAnimation() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.transform = CGAffineTransform.identity
                        self.playerView.maximazePlayer.alpha = 0
                        self.playerView.miniPlayerView.alpha = 1

        })
    }

    func maximizePlayerViewAnimation(episode: Episode? = nil, playList: [Episode] = []) {
        minimizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = 0
        maximizedTopAnchorConstraint.constant = 0
        maximizedTopAnchorConstraint.isActive = true


        if let episode = episode {
            playerView.prepare(by: episode, playList)
        }

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
                        self.playerView.maximazePlayer.alpha = 1
                        self.playerView.miniPlayerView.alpha = 0

        })
    }

    private func buildNavigationViewController(with rootViweController: UIViewController,
                                               title: String,
                                               image: UIImage? = nil) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViweController)
        rootViweController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        return navController
    }

    private func setupViewControllers() {
        viewControllers = [
            buildNavigationViewController(with: PodcastsSearchController(),
                                          title: "Search",
                                          image: UIImage(named: "search")),
            
            buildNavigationViewController(with: ViewController(),
                                          title: "Favorites",
                                          image: UIImage(named: "favorites")),

            buildNavigationViewController(with: ViewController(),
                                          title: "Downloads",
                                          image: UIImage(named: "downloads")),
        ]
    }

    private func setupPlayerView() {
        view.insertSubview(playerView, belowSubview: tabBar)

        // enables auto layout
        playerView.translatesAutoresizingMaskIntoConstraints = false

        maximizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor,
                                                                       constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true

        bottomAnchorConstraint = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                    constant: view.frame.height)
        bottomAnchorConstraint.isActive = true

        minimizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        minimizedTopAnchorConstraint.isActive = true

        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

