//
//  ApiLoaderFactory.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/14/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class ApiService {
    public let apiMediaLoader: ApiMediaLoader = ItunesApiService(httpClient: URLSessionHTTPClient())
    public static let shared = ApiService()
}
