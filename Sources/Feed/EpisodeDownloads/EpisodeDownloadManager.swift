//
//  EpisodeDownloadManager.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-18.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

enum EpisodeDownloadError: LocalizedError {
    case downloadInProgress
    case invalidUrl

    public var errorDescription: String? {
        switch self {
        case .downloadInProgress:
            return "EpisodeDownloadError.downloadInProgress".localized()

        case .invalidUrl:
            return "EpisodeDownloadError.invalidUrl".localized()
        }
    }
}

/// This class manages the episode download.
/// Dispatch the notification with the donwload progress and update the episode with the file URL.
final class EpisodeDownloadManager {
    static let shared = EpisodeDownloadManager(URLSessionHTTPDownloadClient(), LocalDownloadEpisodesRepository(nil))
    private let downloadClient: HTTPDownloadClient
    private let episodesRepository: DownloadEpisodesRepository
    private var activeDownloads = [URL: EpisodeDownload]()

    private init(_ downloadClient: HTTPDownloadClient, _ episodesRepository: DownloadEpisodesRepository) {
        self.downloadClient = downloadClient
        self.episodesRepository = episodesRepository
    }

    /// Indicates the downalod is in progress
    ///
    /// - Parameter episode: the `Episode`
    /// - Returns: a booelan
    func isDonwloadInProgress(_ episode: Episode) -> Bool {
        guard let streamUrl = URL(string: episode.mediaUrl),
            activeDownloads[streamUrl] != nil else { return false }
        return true
    }

    func isDonwloadInPause(_ episode: Episode) -> Bool {
        guard let streamUrl = URL(string: episode.mediaUrl),
            let episodeDownload = activeDownloads[streamUrl] else { return false }
        return !episodeDownload.isDownloading
    }

    /// Cancel the episode download.
    ///
    /// - Parameter episode: the `Episode`.
    func cancelDownload(_ episode: Episode) {
        guard let streamUrl = URL(string: episode.mediaUrl),
            let downloadEpisode = activeDownloads[streamUrl] else { return }

        downloadEpisode.task?.cancel()
        activeDownloads[streamUrl] = nil
    }

    /// Pause the episode download.
    ///
    /// - Parameter episode: the `Episode`.
    func pauseDownload(_ episode: Episode) {
        guard let streamUrl = URL(string: episode.mediaUrl),
            let downloadEpisode = activeDownloads[streamUrl],
            downloadEpisode.isDownloading else { return }

        downloadEpisode.task?.cancel(byProducingResumeData: { (data) in
            downloadEpisode.resumeData = data
        })

        downloadEpisode.isDownloading = false
    }

    /// Resumes the episode download.
    ///
    /// - Parameter episode: the `Episode`.
    func resumeDownload(_ episode: Episode) {
        guard let streamUrl = URL(string: episode.mediaUrl),
            let downloadEpisode = activeDownloads[streamUrl],
            !downloadEpisode.isDownloading else { return }
        if let resumeData = downloadEpisode.resumeData {
            downloadEpisode.task = downloadClient.download(
                withResumeData: resumeData,
                progressCompletion: progressCompletionHandler(),
                downloadFinishedCompletion: downloadFinishedCompletionHandler())
        } else {
            downloadEpisode.task = downloadClient.download(
                with: streamUrl,
                progressCompletion: progressCompletionHandler(),
                downloadFinishedCompletion: downloadFinishedCompletionHandler())
        }
        downloadEpisode.isDownloading = true
    }

    /// Dowloads the episode and update
    ///
    /// - Parameters:
    ///   - episode: the Episode
    ///   - progressCompletion: the `ProgressCompletionHandlerType`.
    ///   - downloadFinishedCompletion: the completion handler.
    /// - Throws: the EpisodeDownloadError.
    func download(_ episode: Episode,
                  _ progressCompletion: ProgressCompletionHandlerType? = nil,
                  _ downloadFinishedCompletion: (() -> Void)? = nil ) throws {
        guard let streamUrl = URL(string: episode.mediaUrl) else {
            print("Invalid URL: EpisodeDownloadManager: episode.mediaUrl")
            throw EpisodeDownloadError.invalidUrl
        }

        guard activeDownloads[streamUrl] == nil else {
            throw EpisodeDownloadError.downloadInProgress
        }

        let episodeDownload = EpisodeDownload(episode)
        episodeDownload.task = downloadClient.download(
            with: streamUrl,
            progressCompletion: progressCompletionHandler(completion: progressCompletion),
            downloadFinishedCompletion: downloadFinishedCompletionHandler(completion: downloadFinishedCompletion))

        episodeDownload.isDownloading = true
        activeDownloads[streamUrl] = episodeDownload
    }

    private func progressCompletionHandler(completion: ProgressCompletionHandlerType? = nil)
        -> ProgressCompletionHandlerType {
        return { (url, progress, fileTotalSize) in
            print("progress:", progress, "; url:", url, "; fileSize:", fileTotalSize)
            let info: [String: Any] = ["id": url.absoluteString, "progress": progress, "totalSize": fileTotalSize]
            NotificationCenter.default.post(name: .episodeDownloadProgress,
                                            object: nil,
                                            userInfo: info)

            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                completion?(url, progress, fileTotalSize)
            }
        }
    }

    private func downloadFinishedCompletionHandler(completion: (() -> Void)? = nil ) -> DownloadFinishedHandlerType {
        return { [weak self] (sourceURL, location) in
            self?.activeDownloads[sourceURL] = nil
            guard let destinationURL = LocalFileRepository.localFilePath(for: sourceURL) else {
                print("destinationURL is nil")
                return
            }
            print(destinationURL)
            LocalFileRepository.copyItem(at: location, to: destinationURL)
            self?.updateEpisode(sourceURL, destinationURL)

            NotificationCenter.default.post(name: .episodeDownloadComplete,
                                            object: nil,
                                            userInfo: ["episodeId": sourceURL.absoluteString])

            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                completion?()
            }
        }
    }

    private func updateEpisode(_ streamUrl: URL, _ destinationURL: URL) {
        if let episode = self.episodesRepository.object(by: streamUrl.absoluteString) {
            episode.setFileUrl(url: destinationURL)
            self.episodesRepository.save(episode)
        }
    }
}
