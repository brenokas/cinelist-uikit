//
//  FilmListViewCell.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import UIKit

class FilmListViewCell: UITableViewCell {
    static let identifier = "FilmListViewCell"
    
    private func setLabel(fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return label
    }
    
    private lazy var filmNameLabel: UILabel = {
        let label = setLabel(fontSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var filmRatingLabel: UILabel = {
        return setLabel(fontSize: 14, weight: .regular)
    }()
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var filmRatingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ratingImageView,
            filmRatingLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "moviePlaceholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var infosStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            filmNameLabel,
            filmRatingStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    func setMovie(movie: Movie) {
        filmNameLabel.text = movie.title
        filmRatingLabel.text = movie.rating.formatRating()
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(infosStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8),
            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16),
            posterImageView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            
            infosStackView.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 16),
            infosStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor,
                constant: -16),
            infosStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            ratingImageView.widthAnchor.constraint(equalToConstant: 18),
            ratingImageView.heightAnchor.constraint(equalToConstant: 18)
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
