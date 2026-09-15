//
//  Movie+ImageUrl.swift
//  CineListUIKit
//
//  Created by breno.farias on 15/09/26.
//

import Foundation

extension Movie {
    func posterURL(size: String = "w500") -> URL? {
        guard let posterPath = poster_path else { return nil }
        
        return URL(string: "https://image.tmdb.org/t/p/\(size)\(posterPath)")
    }
    
    func backdropURL(size: String = "w780") -> URL? {
        guard let backdropPath = backdrop_path else { return nil }

        return URL(string: "https://image.tmdb.org/t/p/\(size)\(backdropPath)")
    }
}
