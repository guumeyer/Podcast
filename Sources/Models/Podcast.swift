//
//  Podcast.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// The podcast protocol will be diplayed on the UI components
protocol Podcast {
    /// the name
    var name: String { get }
    /// the author
    var author: String { get }
    /// the amount of episodes
    var audioCount: Int { get }
    /// the feed URL
    var feedUrl: String? { get }
    /// the artwork URL
    var artworkUrl: String? { get }

    /// Sets the artwork image
    ///
    /// - Parameter data: the image data.
    func setImage(data: Data)

    /// Gets the image data
    ///
    /// - Returns: an image data.
    func getImage() -> Data?
}
