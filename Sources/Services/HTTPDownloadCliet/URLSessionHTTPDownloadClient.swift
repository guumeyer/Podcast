//
//  URLSessionHTTPDownloadClient.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-17.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation
import UIKit

final class URLSessionHTTPDownloadClient: NSObject, HTTPDownloadClient {
    private var progressCompletion: ProgressCompletionHandlerType?
    private var downloadFinishedCompletion: DownloadFinishedHandlerType?
    private static let identifier: String = "com.meyer.ios.Podcast.backgrondSession"
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: URLSessionHTTPDownloadClient.identifier)
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    func download(with url: URL,
                  progressCompletion: ProgressCompletionHandlerType?,
                  downloadFinishedCompletion: DownloadFinishedHandlerType?) -> URLSessionDownloadTask {
        self.progressCompletion = progressCompletion
        self.downloadFinishedCompletion = downloadFinishedCompletion
        
        let task = session.downloadTask(with: url)
        task.resume()
        
        return task
    }
}

// MARK: - URL Session Delegate
extension URLSessionHTTPDownloadClient: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

// MARK: - URL Session Download Delegate
extension URLSessionHTTPDownloadClient: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        
        self.downloadFinishedCompletion?(sourceURL, location)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

        self.progressCompletion?(url, progress, totalSize)
    }
}

