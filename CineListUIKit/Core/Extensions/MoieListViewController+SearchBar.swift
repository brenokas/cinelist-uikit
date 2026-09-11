//
//  MoieListViewController+SearchBar.swift
//  CineListUIKit
//
//  Created by breno.farias on 11/09/26.
//

import UIKit

extension MovieListViewController:
    UISearchBarDelegate
{
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { $0.title.range(
                of: query,
                options: [
                    .caseInsensitive,
                    .diacriticInsensitive
                ]
            ) != nil
            }
        }
        contentView.filmList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        filteredMovies = movies
        contentView.filmList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // tira o foco da barra de busca e fecha o teclado
        contentView.filmList.keyboardDismissMode = .onDrag
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

