//
//  Podcast.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation


var artistName: String?
var artworkUrl600: String?
var feedUrl: String?
var primaryGenreName: String?
var trackCount: Int?
var trackName: String?

protocol Podcast {
    var name: String { get }
    var author: String { get }
    var audioCount: Int { get }
    var feedUrl : String? { get }
    var artworkUrl: String? { get }
}
