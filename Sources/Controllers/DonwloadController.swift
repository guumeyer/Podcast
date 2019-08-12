//
//  DonwloadController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-12.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

final class DonwloadController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing:EpisodeCell.self), bundle: nil),
                           forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITAbleView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let episodeCell = cell as? EpisodeCell {
//            let episode = episodes[indexPath.row]
//            episodeCell.episode = episode
//            episodeCell.episodeImageUrl = episode.image ?? podcast.artworkUrl
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
}
