//
//  FileRepository.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// Protocol to handles the local file manager
protocol FileRepository {
    static func localFilePath(for url: URL) -> URL?
    static func copyItem(at location: URL, to destinationURL: URL)
}
