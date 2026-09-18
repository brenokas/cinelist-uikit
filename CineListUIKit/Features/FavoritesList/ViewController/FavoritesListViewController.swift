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
        
        let favorites = favoriteStore.favorites
        contentView.render(isEmpty: favorites.isEmpty)
        contentView.filmList.reloadData()
    }
}
