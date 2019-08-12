//
//  EpisodesFeedXMLParser.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/15/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

typealias EpisodesFeedHandler = (Result<[Episode], Error>) -> Void

final class EpisodesFeedXMLParser: NSObject, XMLParserDelegate {
    private var episodes: [Episode] = []
    private var currentElement = ""

    private var currentAuthor: String = "" {
        didSet {
            currentAuthor = currentAuthor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentSummary: String = "" {
        didSet {
            currentSummary = currentSummary.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentImage: String = "" {
        didSet {
            currentImage = currentImage.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentMediaUrl: String = "" {
        didSet {
            currentMediaUrl = currentMediaUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: EpisodesFeedHandler?

    init(completionHandler: EpisodesFeedHandler?) {
        parserCompletionHandler = completionHandler
    }

    // MARK: - XML Parser Delegate
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentMediaUrl = ""
            currentSummary = ""
            currentImage = ""
        }
        
        switch elementName {
        case "enclosure" :
            if attributeDict["type"] == "audio/mpeg", let mediaUrl = attributeDict["url"] {
                currentMediaUrl = mediaUrl
            } else if let mediaUrl = attributeDict["url"] {
                currentMediaUrl = mediaUrl
            }
        case "itunes:image" :
            if let imageUrl = attributeDict["href"] {
                currentImage = imageUrl
            }
        default: break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String)   {
        switch currentElement {
        case "itunes:author": currentAuthor += string
        case "title": currentTitle += string
        case "itunes:summary" : currentSummary += string
        case "description" : currentDescription += string
        case "pubDate" : currentPubDate += string
        case "enclosure" : currentPubDate += string
        default: break
        }
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = Episode(id: UUID().uuidString,
                                  author: currentAuthor,
                                  title: currentTitle,
                                  summary: currentSummary,
                                  description: currentDescription,
                                  pubDate: currentPubDate,
                                  mediaUrl: currentMediaUrl,
                                  image: currentImage.isEmpty ? nil : currentImage
            )
            episodes.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(.success(episodes))
    }

    func parse(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parserCompletionHandler?(.failure(parseError))
    }
    
}
