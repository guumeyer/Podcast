//
//  ApiLoaderFactory.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/14/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class ApiService {
    /// The ApiMediaLoader interactes with the API's
    public let apiMediaLoader: ApiMediaLoader = ItunesApiService(httpClient: URLSessionHTTPClient())
    /// A shared instance of ApiService.
    public static let shared = ApiService()
}
