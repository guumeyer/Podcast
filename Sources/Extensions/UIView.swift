//
//  UIView.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-03.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

extension UIView {
    /// Animates the UIView with the default curveEaseOut parameters
    ///
    /// - Parameter animations: The animation completion handler
    static func animateCurveEaseOut(animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: animations)
    }
}
