//
//  MovieListViewController+TableView.swift
//  CineListUIKit
//
//  Created by breno.farias on 11/09/26.
//

import UIKit

extension MovieListViewController:
    UITableViewDataSource,
    UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            viewModel.numberOfMovies
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilmListViewCell.identifier,
            for: indexPath
        ) as? FilmListViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.movie(at: indexPath.row)
        cell.setMovie(movie: movie)
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = viewModel.movie(at: indexPath.row)
        let movieDetail = MovieDetailViewController(movie: movie)
        
        navigationController?.pushViewController(
            movieDetail,
            animated: true)
        
    }
    
}
