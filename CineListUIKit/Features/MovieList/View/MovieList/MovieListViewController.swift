//
//  MovieListViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation
import UIKit

class MovieListViewController: UIViewController {
    private let contentView = MovieListView()
    
    private let movies: [Movie] = [
        Movie(title: "Inception", releaseDate: Date(), rating: 8.8),
        Movie(title: "The Dark Knight", releaseDate: Date(), rating: 9.0),
        Movie(title: "Interstellar", releaseDate: Date(), rating: 8.6),
        Movie(title: "The Matrix", releaseDate: Date(), rating: 8.7),
    ]
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupFilmList()
    }
    
    private func setupFilmList() {
        contentView.setupFilmList(dataSource: self, delegate: self)
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilmListViewCell.identifier,
            for: indexPath
        ) as? FilmListViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.setMovie(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(
            at: indexPath,
            animated: true)
        
        let movie = movies[indexPath.row]
        let movieDetail = MovieDetailViewController(movie: movie)
        
        navigationController?.pushViewController(
            movieDetail,
            animated: true)
    }
}
