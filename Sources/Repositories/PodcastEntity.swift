//
//  PodcastEntity.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-11.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

extension PodcastEntity: Podcast {
    func setImage(data: Data) {
        image = data
    }
    
    func getImage() -> Data? {
        return image
    }
    
    var name: String {
        return title ?? ""
    }
    
    var author: String {
        return authorName ?? ""
    }
    
    var audioCount: Int {
        return Int(episodes)
    }
}
