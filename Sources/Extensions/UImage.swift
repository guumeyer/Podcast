//
//  UImage.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

extension UIImage {

    /// Creates an image based on the parameters
    ///
    /// - Parameters:
    ///   - color: the color will fill the image
    ///   - size: the size of the image
    /// - Returns: An image
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()

        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("can't create image")
        }
        UIGraphicsEndImageContext()
        return image
    }
}
