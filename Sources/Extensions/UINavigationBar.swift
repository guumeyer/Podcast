//
//  UINavigationBar.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
