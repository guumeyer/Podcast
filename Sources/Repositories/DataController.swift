//
//  DataController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-11.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation
import CoreData

final class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

// MARK: - Autosaving
extension DataController {
    
    /// Persist data context
    ///
    /// - Throws: <#throws value description#>
    func saveContext() throws {
        viewContext.performAndWait() {
            
            if self.viewContext.hasChanges {
                do {
                    try self.viewContext.save()
                } catch {
                    print("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                self.backgroundContext.perform() {
                    do {
                        try self.backgroundContext.save()
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
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
