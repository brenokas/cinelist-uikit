//
//  MovieListView.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation
import UIKit

class MovieListView: UIView {
    
    private lazy var filmListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lista de filmes"
        return label
    }()
    
    let filmList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            FilmListViewCell.self,
            forCellReuseIdentifier: FilmListViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 136
        return tableView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar filme"
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubview(filmListLabel)
        addSubview(searchBar)
        addSubview(filmList)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmListLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 16),
            filmListLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16),
            filmListLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16),
            
            filmList.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 16),
            filmList.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16),
            filmList.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16),
            filmList.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchBar.topAnchor.constraint(
               equalTo: filmListLabel.bottomAnchor,
               constant: 18),
           searchBar.leadingAnchor.constraint(
               equalTo: leadingAnchor,
               constant: 8),
           searchBar.trailingAnchor.constraint(
               equalTo: trailingAnchor,
               constant: -8),
        ])
    }
}
