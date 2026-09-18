//
//  FavoritesListView.swift
//  CineListUIKit
//
//  Created by breno.farias on 17/09/26.
//

import UIKit

class FavoritesListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let filmList: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeGridLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            FavoriteMovieCardCell.self,
            forCellWithReuseIdentifier: FavoriteMovieCardCell.identifier
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private static func makeGridLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let horizontalInset: CGFloat = 16
            let itemSpacing: CGFloat = 3
            let cardWidth: CGFloat = 180
            let cardHeight: CGFloat = 300
            let availableWidth = layoutEnvironment.container.effectiveContentSize.width - (horizontalInset * 2)
            let columns = max(1, Int((availableWidth + itemSpacing) / (cardWidth + itemSpacing)))
            let groupWidth = min(
                (CGFloat(columns) * cardWidth) + (CGFloat(columns - 1) * itemSpacing),
                availableWidth
            )

            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(cardWidth),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(groupWidth),
                    heightDimension: .absolute(cardHeight)
                ),
                repeatingSubitem: item,
                count: columns
            )
            group.interItemSpacing = .fixed(itemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = itemSpacing
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 12,
                leading: horizontalInset,
                bottom: 12,
                trailing: horizontalInset
            )
            return section
        }
    }
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nenhum filme favorito encontrado."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.isHidden = true
        return label
        
    }()
    
    func render(isEmpty: Bool) {
        filmList.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        addSubview(filmList)
        addSubview(emptyLabel)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            filmList.topAnchor.constraint(equalTo: topAnchor),
            filmList.leadingAnchor.constraint(equalTo: leadingAnchor),
            filmList.trailingAnchor.constraint(equalTo: trailingAnchor),
            filmList.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
}
