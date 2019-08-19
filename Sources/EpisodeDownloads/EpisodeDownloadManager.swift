//
//  EpisodeDownloadManager.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-18.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class EpisodeDownloadManager {
    static let shared = EpisodeDownloadManager()
    private let downloadClient: HTTPDownloadClient = URLSessionHTTPDownloadClient()
    private lazy var episodesRepository: DownloadEpisodesRepository = LocalDownloadEpisodesRepository(nil)
    
    private init() {}
    
    func download(_ episode: Episode,
                  _ progressCompletion: ProgressCompletionHandlerType? = nil,
                  _ downloadFinishedCompletion: (() -> Void)? = nil ) {
        guard let streamUrl = URL(string: episode.mediaUrl) else {
            print("Invalid URL: EpisodeDownloadManager: episode.mediaUrl")
            return
        }
        
        downloadClient.download(with: streamUrl, progressCompletion: { (url, progress, fileTotalSize) in
            print("progress:", progress, "; url:", url, "; fileSize:", fileTotalSize)
            NotificationCenter.default.post(name: .episodeDownloadProgress,
                                            object: nil,
                                            userInfo: ["id": url.absoluteString,
                                                       "progress": progress,
                                                       "totalSize": fileTotalSize])
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                progressCompletion?(url, progress, fileTotalSize)
            }
        }) { (sourceURL, location) in
            guard let destinationURL = LocalFileRepository.localFilePath(for: sourceURL) else {
                print("destinationURL is nil")
                return
            }
            print(destinationURL)
            LocalFileRepository.copyItem(at: location, to: destinationURL)
            
            episode.setFileUrl(url: destinationURL)
            // TODO: check memory leak
            self.episodesRepository.save(episode)
            
            NotificationCenter.default.post(name: .episodeDownloadComplete,
                                            object: nil,
                                            userInfo: nil)
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                downloadFinishedCompletion?()
            }
        }
    }
}
