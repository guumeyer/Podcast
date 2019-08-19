//
//  DownloadController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-12.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

final class DownloadController: UITableViewController {
    private lazy var episodesRepository: DownloadEpisodesRepository = LocalDownloadEpisodesRepository { [weak self] insertedIndexPaths, deletedIndexPaths, updatedIndexPaths in
        guard let strongSelf = self else { return }
    
        strongSelf.tableView.performBatchUpdates({() -> Void in
            insertedIndexPaths?.forEach { strongSelf.tableView.insertRows(at: [$0], with: .fade) }
            deletedIndexPaths?.forEach { strongSelf.tableView.deleteRows(at: [$0], with: .fade) }
            updatedIndexPaths?.forEach { strongSelf.tableView.reloadRows(at: [$0], with: .fade) }
        }, completion: nil)
    }
    private var mainController: MainTabController? {
        return UIApplication.shared.keyWindow?.rootViewController as? MainTabController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing:EpisodeCell.self), bundle: nil),
                           forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITAbleView
extension DownloadController {
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let donwloadAction = UITableViewRowAction(style: .destructive, title: "Remove") { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            print("Remove")
            strongSelf.episodesRepository.remove(at: indexPath)
        }
        return [donwloadAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let episode = episodesRepository.object(at: indexPath)
        mainController?.maximizePlayerViewAnimation(episode: episode)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return episodesRepository.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodesRepository.numberOfObjects(by: section)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let episodeCell = cell as? EpisodeCell {
            let episode = episodesRepository.object(at: indexPath)
            episodeCell.episode = episode
            episodeCell.episodeImageUrl = episode.imageUrl
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier, for: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
