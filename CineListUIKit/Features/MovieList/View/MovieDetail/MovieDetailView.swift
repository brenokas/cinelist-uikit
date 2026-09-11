//
//  MovieDetailView.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import UIKit

class MovieDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func setupLabel(fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return label
    }
    
    private lazy var titleLabel: UILabel = {
        let label = setupLabel(fontSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        return setupLabel(fontSize: 18)
    }()
    
    private lazy var ratingLabel: UILabel = {
        return setupLabel(fontSize: 18)
    }()

    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ratingImageView,
            ratingLabel
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
    
    private lazy var filmDataStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            releaseDateLabel,
            ratingStackView
        ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var filmStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            posterImageView,
            filmDataStackView
        ])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "\(formatDate(date: movie.releaseDate))"
        ratingLabel.text = "\(movie.rating.formatRating())"
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubview(filmStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            filmStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20),
            filmStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 18),
            filmStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -18),
            filmStackView.bottomAnchor.constraint(
                lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -20),
            
            ratingImageView.widthAnchor.constraint(equalToConstant: 18),
            ratingImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
