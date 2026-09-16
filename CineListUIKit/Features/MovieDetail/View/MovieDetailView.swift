//
//  MovieDetailView.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import UIKit

class MovieDetailView: UIView {
    
    private var posterImageTask: Task<Void, Never>?
    private var backdropImageTask: Task<Void, Never>?
    
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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        imageView.setFilmPlaceholder()
        return imageView
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = setupLabel(fontSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
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
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            filmStackView,
            overviewLabel
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    func configure(with movie: Movie) {
        posterImageTask?.cancel()
        backdropImageTask?.cancel()
        
        titleLabel.text = movie.title
        releaseDateLabel.text = "\(movie.releaseDate?.formatDate() ?? "Sem data de lançamento disponível.")"
        ratingLabel.text = "\(movie.voteAverage?.formatRating() ?? "0.0")"
        overviewLabel.text = movie.overview ?? "Esse filme não possui sinopse."
        
        // estado inicial -> fallback do poster
        posterImageView.setFilmPlaceholder()
        
        //estado inicial -> fallback do backdrop
        backdropImageView.setBackdropPlaceholder()
        
        if let posterURL = movie.posterURL(size: "w500") {
            posterImageTask = Task { [weak self] in
                guard let image = await ImageLoader.shared.image(from: posterURL),
                      !Task.isCancelled else {
                    return
                }
                
                self?.posterImageView.contentMode = .scaleAspectFill
                self?.posterImageView.image = image
            }
        }
        
        if let backdropURL = movie.backdropURL(size: "w1280") {
            backdropImageTask = Task { [weak self] in
                guard let image = await ImageLoader.shared.image(from: backdropURL),
                      !Task.isCancelled else {
                    return
                }
                
                self?.backdropImageView.image = image
            }
        }
        
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubview(contentScrollView)
        contentScrollView.addSubview(backdropImageView)
        contentScrollView.addSubview(contentStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            backdropImageView.heightAnchor.constraint(
                equalTo: backdropImageView.widthAnchor,
                multiplier: 9.0/16.0),
            
            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(
                equalTo: backdropImageView.bottomAnchor,
                constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(
                equalTo: contentScrollView.contentLayoutGuide.leadingAnchor,
                constant: 18),
            contentStackView.trailingAnchor.constraint(
                equalTo: contentScrollView.contentLayoutGuide.trailingAnchor,
                constant: -18),
            contentStackView.widthAnchor.constraint(
                equalTo: contentScrollView.frameLayoutGuide.widthAnchor,
                constant: -36),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 180),
            ratingImageView.widthAnchor.constraint(equalToConstant: 18),
            ratingImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
