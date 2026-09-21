//
//  AppScreenTitle.swift
//  CineListUIKit
//
//  Created by breno.farias on 21/09/26.
//

import UIKit

class AppScreenTitle: UILabel {
    init (text: String) {
        super.init(frame: .zero)
        self.text = text
        self.font = .boldSystemFont(ofSize: 30)
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
