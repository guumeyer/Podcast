//
//  HTTPClient.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/20/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

/// The HTTP client result to represent the HTTP Result in enum.
///
/// - success: The sucess HTTP
/// - failure: The failure HTTP
public enum HTTPClientResult {
    /// The sucess HTTP
    case success(Data, HTTPURLResponse)
    /// The failure HTTP
    case failure(Error)
}

public enum HTTPClientError: LocalizedError {
    case connectivity
    case httpError(Error)
    case invalidData
    case invalidUrl

    public var errorDescription: String? {
        switch self {
        case .connectivity:
            return "HTTPClientError.connectivity".localized()

        case .invalidUrl:
            return "HTTPClientError.invalidUrl".localized()

        case .httpError(let error) :
            return error.localizedDescription

        case .invalidData:
            return "HTTPClientError.invalidData".localized()
        }
    }
}

/// A protocol to make HTTP Request
protocol HTTPClient {
    /// Makes a HTTP GET request
    ///
    /// - Parameters:
    ///   - urlResquest: The `URL`
    ///   - completion: The completion handler to retrive the HTTP response
    /// - Returns: the `URLSessionDataTask`.
    @discardableResult
    func makeRequest(from urlResquest: URLRequest, completion: @escaping (HTTPClientResult) -> Void)
        -> URLSessionDataTask
}
