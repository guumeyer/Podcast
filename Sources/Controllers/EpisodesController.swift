//
//  EpisodesController.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/16/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

final class EpisodesController: UITableViewController {
    
    private lazy var podcastRepository: FavoritePodcastsRepository = LocalFavoritePodcastsRepository(nil)
    private lazy var episodesRepository: DownloadEpisodesRepository = LocalDownloadEpisodesRepository(nil)
    
    private var episodes = [Episode]()
    
    var podcast: Podcast! {
        didSet {
            navigationItem.title = podcast.name
            featchEpisodes()
        }
    }
    
    var displayAddFavorite = false {
        didSet {
            if displayAddFavorite {
                setupNavigationBarButtons()
            } else {
                navigationItem.rightBarButtonItems = []
            }
        }
    }

    private var mainController: MainTabController? {
        return UIApplication.shared.keyWindow?.rootViewController as? MainTabController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func featchEpisodes() {
        episodes = []
        tableView.reloadData()
        ApiService.shared.apiMediaLoader.featchEpisodes(for: podcast) { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let episodesResult):
                strongSelf.episodes = episodesResult
                OperationQueue.main.addOperation {
                    strongSelf.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                }
            }
        }
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Add Favorite",
                            style: .plain,
                            target: self,
                            action: #selector(handleSaveFavorites))
        ]
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing:EpisodeCell.self), bundle: nil),
                           forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    @objc private func handleSaveFavorites() {
        podcastRepository.save(podcast)
    }
}

extension EpisodesController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainController?.maximizePlayerViewAnimation(episode: episodes[indexPath.row],
                                                    playList: episodes)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let episode = episodes[indexPath.row]
        
        
        let donwloadAction = UITableViewRowAction(style: .normal, title: "Donwload") { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            
            if EpisodeDownloadManager.shared.isDonwloadInProgress(episode) {
                strongSelf.showAlert(message: "Download in progress" )
            } else if let episodeFromDatabase = strongSelf.episodesRepository.object(by: episode.id),
                let _ = episodeFromDatabase.getFileUrl() {
                strongSelf.showAlert(message: "Ready to be play")
            } else {
                do {
                    try EpisodeDownloadManager.shared.download(episode)
                    strongSelf.episodesRepository.save(episode)
                } catch {
                    strongSelf.showAlert(message: error.localizedDescription)
                }
            }
        }
        
        return [donwloadAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let episodeCell = cell as? EpisodeCell {
            let episode = episodes[indexPath.row]
            episodeCell.episode = episode
            episodeCell.episodeImageUrl = episode.imageUrl ?? podcast.artworkUrl
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier, for: indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
