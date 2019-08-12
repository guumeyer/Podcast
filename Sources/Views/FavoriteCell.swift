//
//  FavoriteCell.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-03.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// The podcast's favorite cell
final class FavoriteCell: UICollectionViewCell {
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            nameLabel.text = podcast.name
            authorLabel.text = podcast.author
            if let data = podcast.getImage() {
                imageView.image = UIImage(data: data)
            } else {
                imageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    private let imageView: UIURLImageView = {
        return UIURLImageView(image: UIImage(named: "placeholder"))
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel.text = "Episode name"
        authorLabel.text = "Author name"
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            nameLabel,
            authorLabel
            ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
