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
    
    init(movie: Movie) {
        self.movie = movie
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
    }
}


