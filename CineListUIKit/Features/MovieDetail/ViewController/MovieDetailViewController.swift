//
//  MovieDetailViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private let movie: Movie
    private let contentView = MovieDetailView()
    private let favoriteStore: FavoriteMovieStoring
    
    init(movie: Movie, favoriteStore: FavoriteMovieStoring) {
        self.movie = movie
        self.favoriteStore = favoriteStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupView() {
        contentView.configure(with: movie)
        configureFavoriteButton()
    }
    
    private func configureFavoriteButton() {
        let imageName = favoriteStore.isFavorite(movie) ? "heart.fill" : "heart"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(didTapFavoriteButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor =
        favoriteStore.isFavorite(movie) ? .systemRed : .white
    }
    
    @objc
    private func didTapFavoriteButton() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await favoriteStore.toggle(movie)
                configureFavoriteButton()
            } catch {
                present(
                    ShowAlert.make(title: "Erro", message: "Não foi possível atualizar o favorito. Tente novamente."),
                    animated: true
                )
            }
        }
    }
}


