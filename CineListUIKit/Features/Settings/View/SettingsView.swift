//
//  SettingsView.swift
//  CineListUIKit
//
//  Created by breno.farias on 22/09/26.
//

import UIKit

class SettingsView: UIView {
    var onExitTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var exitButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var title = AttributedString("Sair")
        title.font = .systemFont(ofSize: 16, weight: .bold)
        configuration.attributedTitle = title
        configuration.image = UIImage(
            systemName: "rectangle.portrait.and.arrow.right",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 12,
                weight: .bold)
        )
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .systemRed

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapExit), for: .touchUpInside)
        return button
    }()

    @objc
    private func didTapExit() {
        onExitTapped?()
    }

    private func setupView() {
        backgroundColor = .systemBackground

        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        addSubview(exitButton)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            exitButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            exitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            exitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
