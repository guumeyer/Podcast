//
//  EpisodeFeed.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-13.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class FeedEpisode: Episode {
    var author: String
    var title: String
    var summary: String
    var description: String
    var pubDate: String
    var mediaUrl: String
    var imageUrl: String?
    var imageData: Data?
    
    init(author: String,
         title: String,
         summary: String,
         description: String,
         pubDate: String,
         mediaUrl: String,
         imageUrl: String? = nil,
         imageData: Data? = nil) {
        
        self.author = author
        self.title = title
        self.summary = summary
        self.description = description
        self.pubDate = pubDate
        self.mediaUrl = mediaUrl
        self.imageUrl = imageUrl
        self.imageData = imageData
    }
    
    func setImage(data: Data) {
        imageData = data
    }
    
    func getImage() -> Data? {
        return imageData
    }
}
