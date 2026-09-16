//
//  Movie.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation

struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let backdropPath: String?
    let title: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
