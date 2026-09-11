//
//  MovieListViewModel.swift
//  CineListUIKit
//
//  Created by breno.farias on 11/09/26.
//

import Foundation

@MainActor
class MovieListViewModel {
    private let service: MovieListServicing
    
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    
    var onMoviesChanged: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(service: MovieListServicing = MovieListService()) {
        self.service = service
    }
    
    var numberOfMovies: Int {
        filteredMovies.count
    }
    
    func movie(at index: Int) -> Movie {
        filteredMovies[index]
    }
    
    func loadMovies() async {
        do {
            let response = try await service.getMovies(
                page: 1, language: "pt-BR")
            
            movies = response.results
            filteredMovies = movies
            onMoviesChanged?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    func filterMovies(by searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            filteredMovies = movies
            onMoviesChanged?()
            return
        }
        
        filteredMovies = movies.filter { movie in
            movie.title.range(
                of: query,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil
        }
        onMoviesChanged?()
    }
    
    func clearSearch() {
        filteredMovies = movies
        onMoviesChanged?()
    }
}

