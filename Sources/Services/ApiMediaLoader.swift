//
//  ApiMediaLoader.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/14/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

protocol ApiMediaLoader {
    func featchMedias(searchText: String, completion: @escaping (Result<[Podcast], Error>) -> Void )
    func featchEpisodes(for podcast: Podcast, completion: @escaping EpisodesFeedHandler)
}
