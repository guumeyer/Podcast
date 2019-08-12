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
    
    private lazy var podCastRepository: PodcastRepository = LocalPodcastRepository { [weak self] insertedIndexPaths, deletedIndexPaths, updatedIndexPaths in
        guard let strongSelf = self else { return }
        
        strongSelf.collectionView.performBatchUpdates({() -> Void in
            insertedIndexPaths?.forEach { strongSelf.collectionView.insertItems(at: [$0]) }
            deletedIndexPaths?.forEach { strongSelf.collectionView.deleteItems(at: [$0]) }
            updatedIndexPaths?.forEach { strongSelf.collectionView.reloadItems(at: [$0]) }
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return podCastRepository.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podCastRepository.numberOfObjects(by: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let favoriteCell = cell as? FavoriteCell else { return }
        favoriteCell.podcast = podCastRepository.object(at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = podCastRepository.object(at: indexPath)
        navigationController?.pushViewController(episodesController, animated: true)
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
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
        
        let cellWidth = calculateCellWidth(
            Float(view.frame.width),
            space: Float(space),
            numberOfColumns: numberOfColumns)
        
        let cellHeight = cellWidth + 46
        
        cellSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self.collectionView)
        guard let selectIndexPath = self.collectionView.indexPathForItem(at: location) else { return }
        
        let alertView = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.podCastRepository.remove(at: selectIndexPath)
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertView, animated: true)
        
    }
    
    private func calculateCellWidth(_ viewWidth: Float, space: Float, numberOfColumns: Int) -> CGFloat {
        let amountSpaces = Float(2 + (numberOfColumns - 1))
        let spaces = amountSpaces * space
        return CGFloat((viewWidth - spaces) / Float(numberOfColumns))
    }
}
