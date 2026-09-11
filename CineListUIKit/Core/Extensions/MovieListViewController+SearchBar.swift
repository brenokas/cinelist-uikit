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
            viewModel.filterMovies(by: searchText)
                
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        viewModel.clearSearch()
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

