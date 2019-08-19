//
//  Episode.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/16/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// The Episode protocol will be diplayed on the UI components
protocol Episode {
    /// The identification
    var id: String { get }
    /// The author name
    var author: String { get }
    /// The episode title
    var title: String { get }
    /// The episode summary
    var summary: String { get }
    /// The episode decription
    var description: String { get }
    /// The publication date
    var pubDate: String { get }
    /// The media URL
    var mediaUrl: String { get }
    /// The episode image URL
    var imageUrl: String? { get }
    /// Sets the artwork image
    ///
    /// - Parameter data: the image data.
    func setImage(data: Data)
    
    /// Gets the image data
    ///
    /// - Returns: an image data.
    func getImage() -> Data?
    
    /// Sets the episode local file URL
    ///
    /// - Parameter url: the episode local file URL
    func setFileUrl(url:URL?)
    
    /// Gets the episode local file URL
    ///
    /// - Returns: an local URL
    func getFileUrl() -> URL?
}

extension Episode {
    var id: String {
        return mediaUrl
    }
}
