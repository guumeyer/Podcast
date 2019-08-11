//
//  PodcastDataManager.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-11.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

/// The Podcast data manager
final class PodcastDataManager {
    
    /// The default data controller based on the PodcastModel
    static var `default` = PodcastDataManager(modelName: "PodcastModel")
    var controller: DataController!
    
    /// Constructs the NSPersistentContainer based on the model name.
    ///
    /// - Parameter modelName: The model name
    init(modelName: String) {
        controller = DataController(modelName: modelName)
    }
    
    /// Persists the data context pending changes
    ///
    func saveViewContext() throws {
        try PodcastDataManager.default.controller.viewContext.save()
    }
    
    /// Loads the model definition in the data context
    func load() {
        PodcastDataManager.default.controller.load()
    }
}
