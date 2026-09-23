//
//  MovieListViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import UIKit

@MainActor
class MovieListViewController: UIViewController {
    let contentView = MovieListView()
    let viewModel: MovieListViewModel
    let favoriteStore: FavoriteMovieStoring

    var searchTask: Task<Void, Never>?

    init(
        viewModel: MovieListViewModel,
        favoriteStore: FavoriteMovieStoring
    ) {
        self.viewModel = viewModel
        self.favoriteStore = favoriteStore
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(
            viewModel: MovieListViewModel(),
            favoriteStore: FirestoreFavoriteMovieStore()
        )
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
        bindViewModel()
        
        Task {
            do {
                async let favoritesLoad: Void = favoriteStore.load()
                async let moviesLoad: Void = viewModel.loadMovies()
                
                _ = try await favoritesLoad
                await moviesLoad
                
                contentView.filmList.reloadData()
            } catch {
                print("Erro ao carregar favoritos: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "CineList"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindViewModel() {
        viewModel.onMoviesChanged = { [weak self] in
            self?.contentView.filmList.reloadData()
        }
        
        viewModel.onStateChanged = { [weak self] state in
            self?.contentView.render(state: state)
        }
        
        contentView.onRetryTapped = { [weak self] in
            guard let self else { return }
            
            Task {
                await self.viewModel.loadMovies()
            }
        }
    }

    private func setupView() {
        contentView.setupFilmList(dataSource: self, delegate: self)
        contentView.setupSearchBar(delegate: self)
        contentView.filmList.keyboardDismissMode = .onDrag
        contentView.filmList.tableFooterView = UIView()
    }
}
