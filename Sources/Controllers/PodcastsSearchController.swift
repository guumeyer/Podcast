//
//  PodcastsTableViewController.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/11/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

final class PodcastsSearchController: UITableViewController {

    private var podcasts: [Podcast] = []
    private var apiMediaLoader = ApiService.shared.apiMediaLoader
    private let searchController = UISearchController(searchResultsController: nil)
    private var podcastSearchView = Bundle.main.loadNibNamed("MediaSearchingView", owner: self, options: nil)?.first as? UIView
    private var searchTimer: Timer?

    deinit {
        print("Gonne")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shouldRemoveShadow(true)
    }

    // MARK: - Setup layout
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing:PodcastTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: PodcastTableViewCell.identifier)
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableView Delegate and DataSource
extension PodcastsSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }


    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return podcastSearchView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let episodesController = EpisodesController()
        episodesController.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.identifier, for: indexPath)

        guard let podcastCell = cell as? PodcastTableViewCell else { return cell }

        podcastCell.podcast = podcasts[indexPath.row]
        return podcastCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        podcasts = []
        tableView.reloadData()

        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.apiMediaLoader.featchMedias(searchText: searchText,
                                             completion: self.featchMediasHandler())
        }
    }

    func featchMediasHandler() -> (Result<[Podcast], HTTPClientError>) -> Void {
        return { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .success( let medias):
                strongSelf.podcasts = medias
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
