//
//  ImageCacheService.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/15/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

struct ImageCache: Hashable {
    let url: String
    let image: UIImage
}

enum ImageCacheServiceError: LocalizedError {
    case httpError(Error)
    case invalidData(Int)
}

final class ImageCacheService {
    static let shared = ImageCacheService()

    private var cache: URLCache {
        return URLCache.shared
    }

    private var httpClient: HTTPClient = URLSessionHTTPClient()

    private init() {}

    func load(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = self.cache.cachedResponse(for: request)?.data,
                let imageFromCache = UIImage(data: data)  else {
                    print("Image from web")
                    self.downloadImage(request, completion)
                    return
            }
            print("Image from cache")
            completion(.success(imageFromCache))
        }
    }

    private func downloadImage(_ request: URLRequest,
                               _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        httpClient.makeRequest(from: request) { (result) in
            switch result {
            case .failure(let error):
                 completion(.failure(ImageCacheServiceError.httpError(error)))

            case let .success( data, response):
                if  (200 ..< 300).contains(response.statusCode), let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedData, for: request)
                    completion(.success(image))
                } else {
                    completion(.failure(ImageCacheServiceError.invalidData(response.statusCode)))
                }
            }
        }
    }
}
