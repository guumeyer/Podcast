//
//  EpisodeDownload.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-17.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class EpisodeDownload {
    /// Indicates the download is downloading or pause.
    var isDownloading = false
    /// The fractional progress of the download, expressed as a float between 0.0 and 1.0.
    var progress: Float = 0
    /// Stores the Data produced when the user pauses a download task
    var resumeData: Data?
    /// The `URLSessionDownloadTask` that downloads the episode.
    var task: URLSessionDownloadTask?
    /// The episode to download. The episode's url property also acts as a unique identifier for Download.
    var episode: Episode
    
    init(episode: Episode) {
        self.episode = episode
    }
}
