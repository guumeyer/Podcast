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
        setupObverservers()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing:EpisodeCell.self), bundle: nil),
                           forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func setupObverservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEpisodeDownloadProgress(notification:)), name: .episodeDownloadProgress, object: nil)
    }
    
    @objc private func handleEpisodeDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let id = userInfo["id"] as? String,
            let progress = userInfo["progress"] as? Float,
            let totalSize = userInfo["totalSize"] as? String else { return }
     
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            guard let index = strongSelf.episodesRepository.objectIndex(by: id),
                let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
            cell.progressLabel.text = "\(Int(progress * 100))% of \(totalSize)"
        }
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
        if episode.getFileUrl() != nil {
            mainController?.maximizePlayerViewAnimation(episode: episode)
        } else {
            let alertController = UIAlertController(title: "File not found", message: "Can not find the local file.", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Play by stream URL", style: .default, handler: { (_) in
                self.mainController?.maximizePlayerViewAnimation(episode: episode)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
        }
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
