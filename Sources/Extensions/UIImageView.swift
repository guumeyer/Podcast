//
//  UIImageView.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/17/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

extension UIImageView {
    public func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.image = image
        }, completion: nil)
    }
}
