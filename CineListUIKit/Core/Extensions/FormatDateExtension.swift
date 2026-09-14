//
//  FormatDateExtension.swift
//  CineListUIKit
//
//  Created by breno.farias on 14/09/26.
//

import Foundation

extension String {
    func formatDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: self) else { return self }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        return outputFormatter.string(from: date)
    }
}
