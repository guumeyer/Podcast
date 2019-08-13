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
    
    func remove(at indexPath: IndexPath) {
        let podcast = fetchedResultsController.object(at: indexPath)
        PodcastDataManager.default.controller.viewContext.delete(podcast)
        try? PodcastDataManager.default.saveViewContext()
    }
    
    func save(_ episode: Episode) {
        let downloadEpisode = DownloadEpisodes(context: PodcastDataManager.default.controller.viewContext)
        downloadEpisode.episodeAuthor = episode.author
        downloadEpisode.episodeDetail = episode.description
        downloadEpisode.episodeImage = episode.getImage()
        downloadEpisode.episodeMediaUrl = episode.mediaUrl
        downloadEpisode.episodeImageUrl = episode.imageUrl
        downloadEpisode.episodePubDate = episode.pubDate
        downloadEpisode.episodeSummary = episode.summary
        downloadEpisode.episodeTitle = episode.title
        
        try? PodcastDataManager.default.saveViewContext()
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

