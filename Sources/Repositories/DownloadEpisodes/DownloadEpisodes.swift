//
//  DownloadEpisodes.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-13.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

// the DownloadEpisodes extension to conform to the Episode protocol
extension DownloadEpisodes: Episode {
    
    var author: String {
        return self.episodeAuthor ?? ""
    }

    var imageUrl: String? {
        return episodeImageUrl
    }
    
    var title: String {
        return self.episodeTitle ?? ""
    }
    
    var summary: String {
        return self.episodeSummary ?? ""
    }
    
    var pubDate: Date {
        return self.episodePubDate ?? Date()
    }
    
    var mediaUrl: String {
        return self.episodeMediaUrl ?? ""
    }
    
    func setImage(data: Data) {
        episodeImage = data
    }
    
    func getImage() -> Data? {
        return episodeImage
    }
    
    func setFileUrl(url: URL?) {
        self.episodeFileUrl = url
    }
    
    func getFileUrl() -> URL? {
        return self.episodeFileUrl
    }
}
