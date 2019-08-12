//
//  LocalPodcastRepository.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-11.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation
import CoreData

// TODO: Add protocol
final class LocalPodcastRepository: NSObject, PodcastRepository {
    private var insertedIndexPaths: [IndexPath]!
    private var deletedIndexPaths: [IndexPath]!
    private var updatedIndexPaths: [IndexPath]!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<PodcastEntity> = {
        let fetchRequest:NSFetchRequest<PodcastEntity> = PodcastEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
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
    
    var changeContentCompletionHandler: PodcastChangeContentResultType?
    
    init(_ changeContentCompletion: PodcastChangeContentResultType?) {
        changeContentCompletionHandler = changeContentCompletion
    }
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfObjects(by section: Int) -> Int {
        if let sectionInfo = fetchedResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func object(at indexPath: IndexPath) -> Podcast {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func remove(at indexPath: IndexPath) {
        let podcast = fetchedResultsController.object(at: indexPath)
        PodcastDataManager.default.controller.viewContext.delete(podcast)
        try? PodcastDataManager.default.saveViewContext()
    }
    
    func findByTitleAndFeedUrl(title: String, feedUrl: String? = nil) -> Podcast? {
        let request:NSFetchRequest<PodcastEntity> = PodcastEntity.fetchRequest()
        if let feed = feedUrl {
            request.predicate = NSPredicate(format: "title = %@, feedUrl = %@", title, feed)
        } else {
            request.predicate = NSPredicate(format: "title = %@", title)
        }
        
        do {
            let result = try PodcastDataManager.default.controller.viewContext.fetch(request)
            return result.first
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func save(_ podcast: Podcast) {
        if findByTitleAndFeedUrl(title: podcast.name) == nil {
            let favoritePodcast = PodcastEntity(context: PodcastDataManager.default.controller.viewContext)
            favoritePodcast.authorName = podcast.author
            favoritePodcast.title = podcast.name
            favoritePodcast.artworkUrl = podcast.artworkUrl
            favoritePodcast.feedUrl = podcast.feedUrl
            favoritePodcast.episodes = Int32(podcast.audioCount)
            favoritePodcast.image = podcast.getImage()
            
            try? PodcastDataManager.default.saveViewContext()
        }
    }
}

extension LocalPodcastRepository: NSFetchedResultsControllerDelegate {
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
