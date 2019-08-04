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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
