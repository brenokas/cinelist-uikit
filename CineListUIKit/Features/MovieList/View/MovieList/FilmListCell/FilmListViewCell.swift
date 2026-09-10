//
//  FilmListViewCell.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import UIKit

class FilmListViewCell: UITableViewCell {
    static let identifier = "FilmListViewCell"
    
    private lazy var filmName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filme"
        return label
    }()
    
    func setMovie(movie: Movie) {
        filmName.text = movie.title
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        contentView.addSubview(filmName)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            filmName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filmName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            filmName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
