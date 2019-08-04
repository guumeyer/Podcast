//
//  FavoritesController.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-03.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit

/// The user's favorite list
final class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    private let numberOfColumns = 2
    private let space: CGFloat = 16
    /// The cell will be calculated on the `setupCollectionView()` method based on the `numberOfColumns` parameter
    private var cellSize = CGSize(width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellId)
        
        let cellWidth = calculateCellWidth(
            Float(view.frame.width),
            space: Float(space),
            numberOfColumns: numberOfColumns)
        
        cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    private func calculateCellWidth(_ viewWidth: Float, space: Float, numberOfColumns: Int) -> CGFloat {
        let amountSpaces = Float(2 + (numberOfColumns - 1))
        let spaces = amountSpaces * space
        return CGFloat((viewWidth - spaces) / Float(numberOfColumns))
    }
}
