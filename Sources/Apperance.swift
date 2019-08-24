//
//  Apperance.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-23.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// Custom the UI Appearance
final class Appearance {
    static func apply() {
        // Navigation bar
        let proxyNavBar = UINavigationBar.appearance()
        proxyNavBar.prefersLargeTitles = true
        proxyNavBar.isTranslucent = false
        proxyNavBar.backgroundColor = .white
        proxyNavBar.shadowImage = UIImage.imageWithColor(
            color: .clear,
            size: CGSize(width: 1, height: 1)
        )

        proxyNavBar.shadowImage = UIImage()
        proxyNavBar.backIndicatorImage = UIImage()

        let proxyTabBar = UITabBar.appearance()
        proxyTabBar.isTranslucent = false
    }
}
