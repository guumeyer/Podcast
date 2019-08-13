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
    var imageUrl: String? {
        return episodeImageUrl
    }
    
    var author: String {
        return self.episodeAuthor ?? ""
    }
    
    var title: String {
        return self.episodeTitle ?? ""
    }
    
    var summary: String {
        return self.episodeSummary ?? ""
    }
    
    var pubDate: String {
        return self.episodePubDate ?? ""
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
    

}
