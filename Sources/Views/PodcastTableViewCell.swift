//
//  PodcastTableViewCell.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/15/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

final class PodcastTableViewCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIURLImageView! {
        didSet {
            podcastImageView.layer.cornerRadius = 5
            podcastImageView.clipsToBounds = true
            podcastImageView.backgroundColor = .lightGray
        }
    }
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCount: UILabel!

    static let identifier = "PodcastTableViewCell"

    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.name
            artistNameLabel.text = podcast.author
            episodeCount.text = "\(podcast.audioCount) episodes"
            podcastImageView.image = nil

            guard let urlString = podcast.artworkUrl else {
                podcastImageView.image = nil
                return
            }

            podcastImageView.load(url: urlString) { [weak self] (image) in
                if let data = image?.pngData() {
                    self?.podcast.setImage(data: data)
                }
            }
        }
    }
}
