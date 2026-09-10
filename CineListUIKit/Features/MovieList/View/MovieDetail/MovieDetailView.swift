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
    
    private func setupLabel(label: UILabel, fontSize: CGFloat) -> UILabel {
        let label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return setupLabel(label: label, fontSize: 24)
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        return setupLabel(label: label, fontSize: 18)
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        return setupLabel(label: label, fontSize: 18)
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            releaseDateLabel,
            ratingLabel
        ])
        
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var filmDataStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionStackView
        ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "\(formatDate(date: movie.releaseDate))"
        ratingLabel.text = String(format: "Avaliação: %.1f", movie.rating)
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubview(filmDataStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmDataStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20),
            filmDataStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 18),
            filmDataStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -18),
        ])
    }
}
