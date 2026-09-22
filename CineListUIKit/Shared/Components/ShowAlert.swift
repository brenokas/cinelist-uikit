//
//  ShowAlert.swift
//  CineListUIKit
//
//  Created by breno.farias on 22/09/26.
//

import UIKit

enum ShowAlert {
    static func make(
        title: String,
        message: String
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        return alert
    }
}
