//
//  UIImageView+Placeholder.swift
//  CineListUIKit
//
//  Created by breno.farias on 15/09/26.
//

import UIKit

extension UIImageView {
    func setFilmPlaceholder() {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 30,
            weight: .regular
        )
        
        image = UIImage(
            systemName: "film.stack",
            withConfiguration: configuration
        )
        
        tintColor = .secondaryLabel
        backgroundColor = .secondarySystemBackground
        contentMode = .scaleAspectFit
    }
    
    func setBackdropPlaceholder() {
        image = UIImage(systemName: "photo")
        tintColor = .secondaryLabel
        backgroundColor = .secondarySystemBackground
        contentMode = .scaleAspectFit
    }
}
