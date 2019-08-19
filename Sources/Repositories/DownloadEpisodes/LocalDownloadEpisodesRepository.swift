//
//  LocalDownloadEpisodesRepository.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-13.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation
import CoreData

final class LocalDownloadEpisodesRepository: NSObject, DownloadEpisodesRepository {
    private var insertedIndexPaths: [IndexPath]!
    private var deletedIndexPaths: [IndexPath]!
    private var updatedIndexPaths: [IndexPath]!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DownloadEpisodes> = {
        let fetchRequest:NSFetchRequest<DownloadEpisodes> = DownloadEpisodes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "episodeTitle", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PodcastDataManager.default.controller.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        return controller
    } ()
    
    var changeContentCompletionHandler: RepositoryFeatchChangeContentResultType?
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    init(_ changeContentCompletion: RepositoryFeatchChangeContentResultType?) {
        changeContentCompletionHandler = changeContentCompletion
    }
    
    func numberOfObjects(by section: Int) -> Int {
        if let sectionInfo = fetchedResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func object(at indexPath: IndexPath) -> Episode {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func objectIndex(by id: String) -> Int? {
        return fetchedResultsController.fetchedObjects?.firstIndex(where: {$0.id == id})
    }
    
    func remove(at indexPath: IndexPath) {
        let podcast = fetchedResultsController.object(at: indexPath)
        PodcastDataManager.default.controller.viewContext.delete(podcast)
        try? PodcastDataManager.default.saveViewContext()
    }
    
    func findByTitleAndAuthor(title: String, author: String? = nil) -> DownloadEpisodes? {
        let request:NSFetchRequest<DownloadEpisodes> = DownloadEpisodes.fetchRequest()
        if let author = author {
            request.predicate = NSPredicate(format: "episodeTitle = %@, episodeAuthor = %@", title, author)
        } else {
            request.predicate = NSPredicate(format: "episodeTitle = %@", title)
        }
        
        do {
            let result = try PodcastDataManager.default.controller.viewContext.fetch(request)
            return result.first
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func findByMediaUrl(_ mediaUrl: String) -> DownloadEpisodes? {
        let request:NSFetchRequest<DownloadEpisodes> = DownloadEpisodes.fetchRequest()
        request.predicate = NSPredicate(format: "episodeMediaUrl = %@", mediaUrl)
        
        do {
            let result = try PodcastDataManager.default.controller.viewContext.fetch(request)
            return result.first
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func save(_ episode: Episode) {
        if let updateDownloadEpisode = findByMediaUrl(episode.mediaUrl) {
            fillUpDownloadEpisode(updateDownloadEpisode, episode: episode)
        } else {
            let downloadEpisode = DownloadEpisodes(context: PodcastDataManager.default.controller.viewContext)
            fillUpDownloadEpisode(downloadEpisode, episode: episode)
        }
        
        try? PodcastDataManager.default.saveViewContext()
    }
    
    private func fillUpDownloadEpisode(_ download: DownloadEpisodes, episode: Episode) {
        download.episodeAuthor = episode.author
        download.episodeDetail = episode.description
        download.episodeImage = episode.getImage()
        download.episodeMediaUrl = episode.mediaUrl
        download.episodeImageUrl = episode.imageUrl
        download.episodePubDate = episode.pubDate
        download.episodeSummary = episode.summary
        download.episodeTitle = episode.title
        download.episodeFileUrl = episode.getFileUrl()
    }
}

extension LocalDownloadEpisodesRepository: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
        case .delete:
            deletedIndexPaths.append(indexPath!)
        case .update:
            updatedIndexPaths.append(indexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changeContentCompletionHandler?(insertedIndexPaths,
                                        deletedIndexPaths,
                                        updatedIndexPaths)
    }
}

