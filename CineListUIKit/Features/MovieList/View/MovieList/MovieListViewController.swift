//
//  MovieListViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation
import UIKit

class MovieListViewController: UIViewController {
    let contentView = MovieListView()
    
    let movies: [Movie] = [
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
    
    var filteredMovies: [Movie] = []
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredMovies = movies
        setupView()
    }

    private func setupView() {
        contentView.setupFilmList(dataSource: self, delegate: self)
        contentView.setupSearchBar(delegate: self)
        contentView.filmList.keyboardDismissMode = .onDrag
        contentView.filmList.tableFooterView = UIView()
    }
}
