//
//  ItunesSearchResults.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/13/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// Represents the Itunes search result 
struct ItunesSearchResults: Decodable {
    let resultCount: Int
    let results: [ItunesMedia]
}
