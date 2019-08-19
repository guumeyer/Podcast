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
    
    private func localFilePath(for url: URL) -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(url.lastPathComponent)
    }
    
    func download(_ episode: Episode,
                  progressCompletion: ProgressCompletionHandlerType?,
                  downloadFinishedCompletion: (() -> Void)? ) {
        guard let streamUrl = URL(string: episode.mediaUrl) else {
            print("Invalid URL: EpisodeDownloadManager: episode.mediaUrl")
            return
        }
        
        downloadClient.download(with: streamUrl, progressCompletion: { (url, progress, fileTotalSize) in
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                progressCompletion?(url, progress, fileTotalSize)
            }
            
        }) { (sourceURL, location) in
            guard let destinationURL = self.localFilePath(for: sourceURL) else {
                print("destinationURL is nil")
                return
            }
            
            print(destinationURL)
            try? FileManager.default.removeItem(at: destinationURL)
            
            do {
                try FileManager.default.copyItem(at: location, to: destinationURL)
            } catch let error {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
            
            episode.setFileUrl(url: destinationURL)
            // TODO: check memory leak
            self.episodesRepository.save(episode)
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                downloadFinishedCompletion?()
            }
        }
    }
}
