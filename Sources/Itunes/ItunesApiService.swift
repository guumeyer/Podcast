//
//  ItunesApiService.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/14/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

final class ItunesApiService: ApiMediaLoader {
    private let baseUrl = "https://itunes.apple.com"
    private var featchMediasDataTask: URLSessionDataTask?
    private var httpClient: HTTPClient?

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func featchMedias(searchText: String, completion: @escaping (Result<[Podcast], HTTPClientError>) -> Void ) {
        featchMediasDataTask?.cancel()
        let term = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URL(string: "\(baseUrl)/search?term=\(term)&media=podcast")!

        let urlRequest = URLRequest(url: url)
        featchMediasDataTask = httpClient?.makeRequest(from: urlRequest) { (result) in
            switch result {
            case .success(let data, _):
                if let searchRResults = try? JSONDecoder().decode(ItunesSearchResults.self, from: data) {
                    
                    completion(.success(searchRResults.results.filter({
                        guard let feedUrl = $0.feedUrl else { return false }
                        return !feedUrl.isEmpty
                    })))
                }
                print("featchMedias: success")
            case .failure(let error):
                print("featchMedias: ", error.localizedDescription)
            }
        }
    }

    func featchEpisodes(for podcast: Podcast, completion: @escaping EpisodesFeedHandler) {
        guard let urlString = podcast.feedUrl else {
            //TODO add completion .failure
            return
        }
        //.toSecureHTTPS()
        guard let url = URL(string: urlString) else {
            //TODO add completion .failure
            return
        }
        
        httpClient?.makeRequest(from: URLRequest(url: url)) { (result) in
            switch result {
            case .success(let data, _):
                let episodeParser = FeedEpisodesXmlParser()
                episodeParser.parse(data: data, completionHandler: completion)
                //TODO add completion .failure
                print("featchMedias: success")
            case .failure(let error):
                print("featchMedias: ", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
