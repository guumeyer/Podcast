//
//  FavoritePodcastsRepository.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-12.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// Favorite Podcasts Repository object
protocol FavoritePodcastsRepository {
    /// Completion handler to notify when the FavoritePodcasts context has been changed
    var changeContentCompletionHandler: RepositoryFeatchChangeContentResultType? { get }
    
    init(_ changeContentCompletion: RepositoryFeatchChangeContentResultType?)
    
    /// The number of sections
    var numberOfSections: Int { get }
    
    /// Returns a number of objects by section
    ///
    /// - Parameter section: the selected section
    /// - Returns: the amount of objects present in the section
    func numberOfObjects(by section: Int) -> Int
    
    /// Gets the Podcast by index.
    ///
    /// - Parameter indexPath: the selected index path
    /// - Returns: a podcast.
    func object(at indexPath: IndexPath) -> Podcast
    
    /// Removes the podcast based on the `indextPath`
    ///
    /// - Parameter indexPath: the selected index path
    func remove(at indexPath: IndexPath)
    
    /// Finds the podcast by title and feedURL.
    ///
    /// - Parameters:
    ///   - title: the podcast title.
    ///   - feedUrl: the podcast feed URL
    /// - Returns: a podcast if exists or nil.
    func findByTitleAndFeedUrl(title: String, feedUrl: String?) -> Podcast?
    
    /// Saves the podcast
    ///
    /// - Parameter podcast: the podcast
    func save(_ podcast: Podcast)
}

