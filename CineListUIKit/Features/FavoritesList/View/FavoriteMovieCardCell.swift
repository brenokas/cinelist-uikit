//
//  FavoriteMovieCardCell.swift
//  CineListUIKit
//
//  Created by breno.farias on 17/09/26.
//

import UIKit

final class FavoriteMovieCardCell: UICollectionViewCell {
    static let identifier = "FavoriteMovieCardCell"

    private var imageTask: Task<Void, Never>?
    private var representedMovieID: Int?
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setFilmPlaceholder()
        return imageView
    }()

    private let posterGradientView = GradientView(
        colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.85)],
        locations: [0.45, 1]
    )

    private lazy var filmNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var filmRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private lazy var ratingStackView: UIStackView = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.beginFromCurrentState, .curveEaseOut]
            ) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.96, y: 0.96)
                    : .identity
            }
        }
    }

    func setMovie(movie: Movie) {
        representedMovieID = movie.id
        imageTask?.cancel()

        filmNameLabel.text = movie.title
        filmRatingLabel.text = movie.voteAverage?.formatRating() ?? "Sem avaliação"
        posterImageView.setFilmPlaceholder()

        guard let posterURL = movie.posterURL(size: "w500") else {
            return
        }

        imageTask = Task { [weak self] in
            guard let image = await ImageLoader.shared.image(from: posterURL),
                  !Task.isCancelled,
                  self?.representedMovieID == movie.id else {
                return
            }

            self?.posterImageView.backgroundColor = .clear
            self?.posterImageView.contentMode = .scaleAspectFill
            self?.posterImageView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageTask?.cancel()
        imageTask = nil
        representedMovieID = nil
        filmNameLabel.text = nil
        filmRatingLabel.text = nil
        posterImageView.setFilmPlaceholder()
    }

    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true

        contentView.addSubview(posterImageView)
        contentView.addSubview(posterGradientView)
        contentView.addSubview(filmNameLabel)
        contentView.addSubview(ratingStackView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            posterGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterGradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            ratingStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ratingStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            filmNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            filmNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            filmNameLabel.bottomAnchor.constraint(equalTo: ratingStackView.topAnchor, constant: -4),

            ratingImageView.widthAnchor.constraint(equalToConstant: 16),
            ratingImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}

private final class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    init(colors: [UIColor], locations: [NSNumber]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(gradientLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
