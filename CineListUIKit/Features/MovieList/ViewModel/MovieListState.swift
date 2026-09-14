//
//  MovieListState.swift
//  CineListUIKit
//
//  Created by breno.farias on 14/09/26.
//

import Foundation

enum MovieListState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
