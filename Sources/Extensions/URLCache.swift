//
//  URLCache.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-23.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

extension URLCache {
     // 500 MB
    private static let memoryCapacity = 500 * 1024 * 1024
    private static let diskCapacity = 1000 * 1024 * 1024

    /// Setups the URLCache with the size
    public static func setupCache() {
        let cache = URLCache(memoryCapacity: memoryCapacity,
                             diskCapacity: diskCapacity,
                             diskPath: "imagePath")
        URLCache.shared = cache
    }
}
