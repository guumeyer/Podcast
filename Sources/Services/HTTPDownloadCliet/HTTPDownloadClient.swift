//
//  HTTPDownloadClient.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-17.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// The progress completion handler type
///
/// - Parameters:
///   - url: the download url.
///   - progress: The fractional progress of the download, expressed as a float between 0.0 and 1.0.
///   - totalSize: The file's total size.
///
typealias ProgressCompletionHandlerType = (_ url: URL, _ progress: Float, _ totalSize: String) -> Void

/// The download finished handler type
///
/// - Parameters:
///   - sourceUrl: The download source url
///   - location: The temporary download location
typealias DownloadFinishedHandlerType = (_ sourceUrl: URL, _ location: URL) -> Void

protocol HTTPDownloadClient {
    /// Downloads the url.
    ///
    /// - Parameters:
    ///   - url: the download URL.
    ///   - progressCompletion: the `ProgressCompletionHandlerType`.
    ///   - downloadFinishedCompletion: the `DownloadFinishedHandlerType`.
    /// - Returns: an `URLSessionDownloadTask`.
    @discardableResult
    func download(with url: URL,
                  progressCompletion: ProgressCompletionHandlerType?,
                  downloadFinishedCompletion: DownloadFinishedHandlerType?) -> URLSessionDownloadTask

    /// Continues the donwload.
    ///
    /// - Parameters:
    ///   - withResumeData: the data from previews download.
    ///   - progressCompletion: the `ProgressCompletionHandlerType`.
    ///   - downloadFinishedCompletion: the `DownloadFinishedHandlerType`.
    /// - Returns: an `URLSessionDownloadTask`.
    @discardableResult
    func download(withResumeData: Data,
                  progressCompletion: ProgressCompletionHandlerType?,
                  downloadFinishedCompletion: DownloadFinishedHandlerType?) -> URLSessionDownloadTask
}
