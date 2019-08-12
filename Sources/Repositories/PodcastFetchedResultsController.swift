//
//  PodcastFetchedResultsController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-11.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation
import CoreData

final class PodcastFetchedResultsController: NSObject {
    
    private var insertedIndexPaths: [IndexPath]!
    private var deletedIndexPaths: [IndexPath]!
    private var updatedIndexPaths: [IndexPath]!
    
    lazy var fetchedResultsController: NSFetchedResultsController<PodcastEntity> = {
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
    
    var changeContentCompletionHandler: ((
    _ insertItems: [IndexPath]?,
    _ deleteItems: [IndexPath]?,
    _ reloadItems: [IndexPath]? ) -> Void)!
    
    init(_ changeContentCompletion: @escaping (
        _ insertItems: [IndexPath]?,
        _ deleteItems: [IndexPath]?,
        _ reloadItems: [IndexPath]? ) -> Void) {
        changeContentCompletionHandler = changeContentCompletion
    }
}

extension PodcastFetchedResultsController: NSFetchedResultsControllerDelegate {
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
