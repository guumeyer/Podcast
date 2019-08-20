//
//  UIViewController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Shows alert view
    ///
    /// - Parameters:
    ///   - title: the title
    ///   - message: the message
    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.accessibilityLabel = title
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
