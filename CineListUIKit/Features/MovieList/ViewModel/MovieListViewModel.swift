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
    
    var state: MovieListState = .idle {
        didSet {
            onStateChanged?(state)
        }
    }
    
    // propriedades que guardam funcoes
    // o viewmodel apenas declara os espacoes onde essas funcoes serao guardadas
    var onMoviesChanged: (() -> Void)?
    var onStateChanged: ((MovieListState) -> Void)?
    
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
        state = .loading
        do {
            let response = try await service.getMovies(
                page: 1, language: "pt-BR")
            
            movies = response.results
            
            state = movies.isEmpty ? .empty : .loaded
            
            filteredMovies = movies
            onMoviesChanged?()
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func filterMovies(by searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            filteredMovies = movies
            state = .loaded
            onMoviesChanged?()
            return
        }
        
        filteredMovies = movies.filter { movie in
            movie.title.range(
                of: query,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil
        }
        
        state = filteredMovies.isEmpty ? .empty : .loaded
        onMoviesChanged?()
    }
    
    func clearSearch() {
        filteredMovies = movies
        state = .loaded
        onMoviesChanged?()
    }
}

