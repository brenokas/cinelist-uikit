//
//  FavoriteMovieStore.swift
//  CineListUIKit
//
//  Created by breno.farias on 17/09/26.
//

import Foundation

@MainActor
protocol FavoriteMovieStoring: AnyObject {
    var favorites: [Movie] { get }
    func isFavorite(_ movie: Movie) -> Bool
    func toggle(_ movie: Movie)
}

@MainActor
class UserDefaultsFavoriteMovieStore: FavoriteMovieStoring {
    private let key = "favorite_movies"
    private let userDefaults: UserDefaults
    
    private(set) var favorites: [Movie] = []
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFavorites()
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(where: { $0.id == movie.id })
    }
    
    func toggle(_ movie: Movie) {
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(movie)
        }
        saveFavorites()
    }
    
    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: key),
              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
            favorites = []
            return
        }
        
        favorites = movies
    }
    
    private func saveFavorites() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        userDefaults.set(data, forKey: key)
    }
}
