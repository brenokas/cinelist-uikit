//
//  Movie.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation

struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let backdrop_path: String?
    let title: String
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
}
