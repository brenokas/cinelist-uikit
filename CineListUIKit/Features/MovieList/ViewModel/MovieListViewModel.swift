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
    
    init(service: MovieListServicing? = nil) {
        self.service = service ?? MovieListService()
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
    
    func searchMovies(movieName: String) async {
        state = .loading
        do {
            let response = try await service.searchMovies(movieName: movieName)

            guard !Task.isCancelled else { return }

            movies = response.results
            state = movies.isEmpty ? .empty : .loaded
            filteredMovies = movies
            onMoviesChanged?()
        } catch is CancellationError {
            // não há erro para mostrar pois a busca foi substituida
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func clearSearch() {
        filteredMovies = movies
        state = .loaded
        onMoviesChanged?()
    }
}

