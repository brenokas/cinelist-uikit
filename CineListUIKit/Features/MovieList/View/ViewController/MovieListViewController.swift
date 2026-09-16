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
    }
}
