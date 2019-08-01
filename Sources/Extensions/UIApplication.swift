//
//  UIApplication.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 8/1/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainController() -> MainTabController? {
        return shared.keyWindow?.rootViewController as? MainTabController
    }
}
