//
//  MovieListViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import FirebaseAuth
import UIKit

@MainActor
class MovieListViewController: UIViewController {
    let contentView = MovieListView()
    let viewModel: MovieListViewModel
    let favoriteStore : FavoriteMovieStoring
    
    var searchTask: Task<Void, Never>?
    private let onLogout: () -> Void

    init(
        viewModel: MovieListViewModel,
        favoriteStore: FavoriteMovieStoring,
        onLogout: @escaping () -> Void) {
        self.viewModel = viewModel
        self.favoriteStore = favoriteStore
        self.onLogout = onLogout
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(onLogout: @escaping () -> Void) {
        self.init(
            viewModel: MovieListViewModel(),
            favoriteStore: UserDefaultsFavoriteMovieStore(),
            onLogout: onLogout
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
            await viewModel.loadMovies()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "CineList"
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapFavorites)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
    }
    
    @objc private func didTapLogout() {
        let alert = UIAlertController(
            title: "Deseja sair?",
            message: "Você será desconectado da sua conta.",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(title: "Cancelar", style: .cancel)
        )
        
        alert.addAction(
            UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
                self?.logout()
            }
        )
        present(alert, animated: true)
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            onLogout()
        
        } catch {
            let alert = UIAlertController(
                title: "Erro ao sair",
                message: "Não foi possível sair da conta. Tente novamente.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc
    private func didTapFavorites() {
        let favoritesList = FavoritesListViewController(favoriteStore: favoriteStore)
        navigationController?.pushViewController(
            favoritesList,
            animated: true
        )
    }
}
