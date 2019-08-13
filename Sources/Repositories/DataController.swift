//
//  DataController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-11.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation
import CoreData

/// The `DataController` handles the `NSPersistentContainer`.
final class DataController {
    let persistentContainer:NSPersistentContainer
    
    /// Returns the viewContext from `NSPersistentContainer`.
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    /// Constructs the `DataController` instance.
    ///
    /// - Parameter modelName: the model name.
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    /// Load stores
    ///
    /// - Parameter completion: the completion handler.
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { [weak self] storeDescription, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            strongSelf.autoSaveViewContext()
            strongSelf.setupContexts()
            completion?()
        }
    }
    
    /// Persist data context
    ///
    /// - Throws: <#throws value description#>
    func saveContext() throws {
        viewContext.performAndWait() { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.viewContext.hasChanges {
                do {
                    try strongSelf.viewContext.save()
                } catch {
                    print("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                strongSelf.backgroundContext.perform() {
                    do {
                        try strongSelf.backgroundContext.save()
                    } catch {
                        print("Error while saving persisting context: \(error)")
                    }
                }
            }
        }
    }
    
    /// Persist data context based on the `interval` parameter
    ///
    /// - Parameter interval: the interval, default is 30 s
    private func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.autoSaveViewContext(interval: interval)
        }
    }
    
    /// Setups the contexts
    private func setupContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
}
