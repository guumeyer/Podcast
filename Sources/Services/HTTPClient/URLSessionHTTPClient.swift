//
//  URLSessionHTTPClient.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/20/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private struct UnexpectedRepresentation: Error {}

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    func makeRequest(from urlResquest: URLRequest, completion: @escaping (HTTPClientResult) -> Void)
        -> URLSessionDataTask {
        let dataTask = session.dataTask(with: urlResquest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedRepresentation()))
            }
        }
        dataTask.resume()
        return dataTask
    }
}
