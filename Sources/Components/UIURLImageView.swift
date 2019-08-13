//
//  UIURLImageView.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/16/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// The UIURLImageView loads image based on the url web or local cache.
final class UIURLImageView: UIImageView {
    /// The image URL String
    var url: String?
    private static let placeHolderImage = UIImage(named: "placeholder")

    /// Loads image based on the url web or local cache
    ///
    /// - Parameter url: the image URL
    func load(url: String, completion: ((UIImage?) -> Void)? = nil)  {
        image = nil
        self.url = url
        guard let imageUrl = URL(string: url) else {
            print("Invalid image URL")
            return
        }
        ImageCacheService.shared.load(imageUrl) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success( let image):
                if self?.url == url {
                    DispatchQueue.main.async {
                        completion?(image)
                        strongSelf.transition(toImage: image)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion?(UIURLImageView.placeHolderImage)
                    strongSelf.transition(toImage: UIURLImageView.placeHolderImage)
                }
                print(error.localizedDescription)
            }
        }
    }
}
