//
//  MainTabBarController.swift
//  CineListUIKit
//
//  Created by breno.farias on 22/09/26.
//

import UIKit

@MainActor
class MainTabBarController: UITabBarController {
    init(onLogout: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)

        let favoriteStore = FirestoreFavoriteMovieStore()

        let movieListViewController = MovieListViewController(
            viewModel: MovieListViewModel(),
            favoriteStore: favoriteStore
        )

        let settingsViewController = SettingsViewController(onLogout: onLogout)

        let favoritesListViewController = FavoritesListViewController(favoriteStore: favoriteStore)

        let moviesNavigationController = UINavigationController(rootViewController: movieListViewController)

        let favoritesNavigationController = UINavigationController(rootViewController: favoritesListViewController)

        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)

        moviesNavigationController.tabBarItem = UITabBarItem(
            title: "Início",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        settingsNavigationController.tabBarItem = UITabBarItem(
            title: "Configurações",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        viewControllers = [
            favoritesNavigationController,
            moviesNavigationController,
            settingsNavigationController,
        ]

        selectedIndex = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
