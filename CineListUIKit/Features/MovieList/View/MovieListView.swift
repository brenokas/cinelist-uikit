//
//  MovieListView.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation
import UIKit

class MovieListView: UIView {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar filme"
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let filmList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            FilmListViewCell.self,
            forCellReuseIdentifier: FilmListViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 136
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var stateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            stateImageView,
            stateLabel,
            retryButton
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.isHidden = true
        
        return stackView
    }()
    
    private lazy var stateImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 42,
            weight: .regular,
        )
        
        return imageView
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Tentar novamente"
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    var onRetryTapped: (() -> Void)?
    
    func setupSearchBar(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func setupFilmList(
        dataSource: UITableViewDataSource,
        delegate: UITableViewDelegate
    ) {
        filmList.dataSource = dataSource
        filmList.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Atualiza o tamanho do header view para corresponder à largura da tabela
        if let headerView = filmList.tableHeaderView {
            let width = filmList.bounds.width
            let height = headerView.bounds.height
            headerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            filmList.tableHeaderView = headerView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSearchBar() {
        let headerHeight: CGFloat = 56
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: headerHeight))
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
        ])
        
        filmList.tableHeaderView = headerContainer
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        setHierarchy()
        setConstraints()
        setSearchBar()
                
        retryButton.addTarget(
            self,
            action: #selector(didTapRetryButton),
            for: .touchUpInside)
    }
    
    private func setHierarchy() {
        addSubview(filmList)
        addSubview(loadingIndicator)
        addSubview(stateStackView)
    }
    
    func render(state: MovieListState) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            stateStackView.isHidden = true
            filmList.isHidden = false
        case .loading:
            filmList.isHidden = true
            stateStackView.isHidden = true
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
            stateStackView.isHidden = true
            filmList.isHidden = false
        case .empty:
            loadingIndicator.stopAnimating()
            filmList.isHidden = true
            stateImageView.image = UIImage(systemName: "film.stack")
            stateLabel.text = "Nenhum filme encontrado"
            retryButton.isHidden = true
            stateStackView.isHidden = false
        case .error(let message):
            loadingIndicator.stopAnimating()
            filmList.isHidden = true
            stateImageView.image = UIImage(systemName: "exclamationmark.triangle")
            stateLabel.text = """
                Não foi possível carregar os filmes:
                \(message)
            """
            retryButton.isHidden = false
            stateStackView.isHidden = false
        }
    }
    
    @objc
    private func didTapRetryButton() {
        onRetryTapped?()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmList.topAnchor.constraint(equalTo: topAnchor),
            filmList.leadingAnchor.constraint(
                equalTo: leadingAnchor),
            filmList.trailingAnchor.constraint(
                equalTo: trailingAnchor),
            filmList.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: filmList.centerYAnchor),
            
            stateStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stateStackView.centerYAnchor.constraint(equalTo: filmList.centerYAnchor),
            stateStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: 24),
            stateStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -24),
            
            stateImageView.widthAnchor.constraint(equalToConstant: 48),
            stateImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
