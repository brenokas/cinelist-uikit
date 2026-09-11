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
        Movie(
            title: "Inception",
            releaseDate: Date(),
            rating: 8.8,
            overview: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O."),
        Movie(
            title: "The Dark Knight",
            releaseDate: Date(),
            rating: 9.0,
            overview: "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham."),
        Movie(
            title: "Interstellar",
            releaseDate: Date(),
            rating: 8.6,
            overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival."),
        Movie(
            title: "The Matrix",
            releaseDate: Date(),
            rating: 8.7,
            overview: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers."),
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
