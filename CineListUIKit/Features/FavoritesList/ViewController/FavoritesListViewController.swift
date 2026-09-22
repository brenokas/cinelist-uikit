//
//  FavoritesListViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 17/09/26.
//

import UIKit

@MainActor
class FavoritesListViewController: UIViewController {
    private let contentView = FavoritesListView()
    let favoriteStore: FavoriteMovieStoring
    
    init(favoriteStore: FavoriteMovieStoring) {
        self.favoriteStore = favoriteStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favoritos"
        contentView.filmList.dataSource = self
        contentView.filmList.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            do {
                try await favoriteStore.load()
                let favorites = favoriteStore.favorites
                contentView.render(isEmpty: favorites.isEmpty)
                contentView.filmList.reloadData()
            } catch {
                showLoadError(error)
            }
        }
    }
    
    private func showLoadError(_ error: Error) {
        let alert = UIAlertController(
            title: "Erro",
            message: "Falha ao carregar os filmes favoritos. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
