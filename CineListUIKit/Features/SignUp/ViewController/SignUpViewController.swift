//
//  SignUpViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 21/09/26.
//

import UIKit

class SignUpViewController: UIViewController {
    private let contentView = SignUpView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {}
}
