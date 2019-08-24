//
//  DownloadEpisodesRepository.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-13.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

protocol DownloadEpisodesRepository {
    /// The number of sections
    var numberOfSections: Int { get }

    /// Returns a number of objects by section
    ///
    /// - Parameter section: the selected section
    /// - Returns: the amount of objects present in the section
    func numberOfObjects(by section: Int) -> Int

    /// Gets the Episode by index.
    ///
    /// - Parameter indexPath: the selected index path
    /// - Returns: a podcast.
    func object(at indexPath: IndexPath) -> Episode

    /// Finds the object index
    ///
    /// - Parameter code: the episode id
    /// - Returns: an index or nil
    func objectIndex(by code: String) -> Int?

    /// Finds the object index
    ///
    /// - Parameter id: the episode id
    /// - Returns: an Episode or nil
    func object(by code: String) -> Episode?

    /// Removes the podcast based on the `indextPath`
    ///
    /// - Parameter indexPath: the selected index path
    func remove(at indexPath: IndexPath)

    /// Saves the episode
    ///
    /// - Parameter episode: the episode
    func save(_ episode: Episode)
}
