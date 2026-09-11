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
    let viewModel = MovieListViewModel()
    
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
    
    private func bindViewModel() {
        viewModel.onMoviesChanged = { [weak self] in
            self?.contentView.filmList.reloadData()
        }
        
        viewModel.onError = { errorMessage in
            print("Erro ao buscar filmes: \(errorMessage)")
        }
    }

    private func setupView() {
        contentView.setupFilmList(dataSource: self, delegate: self)
        contentView.setupSearchBar(delegate: self)
        contentView.filmList.keyboardDismissMode = .onDrag
        contentView.filmList.tableFooterView = UIView()
    }
}
