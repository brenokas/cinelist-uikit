//
//  AppTextField.swift
//  CineListUIKit
//
//  Created by breno.farias on 21/09/26.
//

import UIKit

class AppTextField: UITextField {
    private var eyeButton: UIButton?
    
    init(
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        secureTextEntry: Bool = false
    ) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isSecureTextEntry = secureTextEntry
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.borderStyle = .roundedRect
        self.returnKeyType = .done
        self.addTarget(
            self,
            action: #selector(dismissKeyboard),
            for: .editingDidEndOnExit
        )
        self.translatesAutoresizingMaskIntoConstraints = false
            
        if secureTextEntry {
            setupPasswordButton()
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func dismissKeyboard() {
        resignFirstResponder()
    }
    
    private func setupPasswordButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "eye.slash")
        configuration.baseForegroundColor = .secondaryLabel
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 8
        )
        
        let button = UIButton(configuration: configuration)
        
        button.accessibilityLabel = "Mostrar senha"
        button.addTarget(
            self,
            action: #selector(togglePasswordVisibility),
            for: .touchUpInside
        )
        
        rightView = button
        rightViewMode = .always
        eyeButton = button
    }
    
    @objc
    private func togglePasswordVisibility(){
        isSecureTextEntry.toggle()
        
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton?.setImage(UIImage(systemName: imageName), for: .normal)
        eyeButton?.accessibilityLabel = isSecureTextEntry ? "Mostrar senha" : "Ocultar senha"

    }
}
