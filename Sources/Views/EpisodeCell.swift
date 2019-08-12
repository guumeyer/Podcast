//
//  EpisodeCell.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/16/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

final class EpisodeCell: UITableViewCell {

    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }

    @IBOutlet weak var episodeImageView: UIURLImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.backgroundColor = .lightGray
        }
    }

    static let identifier = "EpisodeCell"

    var episode: Episode? {
        didSet {
            pubDateLabel.text = episode?.pubDate
            titleLabel.text = episode?.title
            descriptionLabel.text = episode?.summary
            
        }
    }

    var episodeImageUrl: String? {
        didSet {
            episodeImageView.image = nil
            guard let urlString = episodeImageUrl else {
                return
            }
            episodeImageView.load(url: urlString)
        }
    }

}
