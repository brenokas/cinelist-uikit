//
//  FavoritesListViewController+CollectionView.swift
//  CineListUIKit
//
//  Created by breno.farias on 17/09/26.
//

import UIKit

extension FavoritesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        favoriteStore.favorites.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteMovieCardCell.identifier,
            for: indexPath
        ) as? FavoriteMovieCardCell else {
            return UICollectionViewCell()
        }

        let movie = favoriteStore.favorites[indexPath.item]
        cell.setMovie(movie: movie)

        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let movie = favoriteStore.favorites[indexPath.item]
        
        let detailViewController = MovieDetailViewController(
            movie: movie,
            favoriteStore: favoriteStore
        )
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}
