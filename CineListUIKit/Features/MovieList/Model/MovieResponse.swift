//
//  MovieResponse.swift
//  CineListUIKit
//
//  Created by breno.farias on 11/09/26.
//

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
