//
//  MoieListViewController+SearchBar.swift
//  CineListUIKit
//
//  Created by breno.farias on 11/09/26.
//

import UIKit

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String) {
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

            searchTask?.cancel()

            guard !query.isEmpty else {
                Task {
                    await viewModel.loadMovies()
                }
                return
            }

            guard query.count >= 3 else { return }

            searchTask = Task { [weak self] in
                do {
                    // Aguardar 0.5 segundos antes de realizar a pesquisa para evitar chamadas excessivas à API enquanto o usuário digita

                    try await Task.sleep(for: .milliseconds(500))
                    guard !Task.isCancelled else { return }

                    await self?.viewModel.searchMovies(movieName: query)
                } catch {
                    // a tarefa foi cancelada porque o usuário continuou digitando
                }
            }
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTask?.cancel()

        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()

        Task {
            await viewModel.loadMovies()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // tira o foco da barra de busca e fecha o teclado
        contentView.filmList.keyboardDismissMode = .onDrag
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

