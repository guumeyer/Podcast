//
//  LocalFileRepository.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class LocalFileRepository: FileRepository {
    static func localFilePath(for url: URL) -> URL? {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(url.lastPathComponent)
    }

    static func copyItem(at location: URL, to destinationURL: URL) {
        removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
        } catch {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }

    static func removeItem(at destinationURL: URL) {
        do {
            try FileManager.default.removeItem(at: destinationURL)
        } catch {
            print("Could not remove file to disk: \(error.localizedDescription)")
        }
    }
}
