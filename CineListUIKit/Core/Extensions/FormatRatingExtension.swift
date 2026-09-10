//
//  FormatRatingExtension.swift
//  CineListUIKit
//
//  Created by breno.farias on 10/09/26.
//

import Foundation

extension Double {
    func formatRating() -> String {
        return String(format: "%.1f", self)
    }
}
