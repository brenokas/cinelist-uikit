//
//  SignUpView.swift
//  CineListUIKit
//
//  Created by breno.farias on 21/09/26.
//

import UIKit

class SignUpView: UIView {
    var onSignUpButtonTapped: ((String, String, String, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var appTitle: UILabel = {
        AppScreenTitle(text: "Cadastre-se")
    }()
    
    private lazy var nameTextField: UITextField = {
        AppTextField(
            placeholder: "Nome",
            textContentType: .name
        )
    }()
    
    private lazy var emailTextField: UITextField = {
        AppTextField(
            placeholder: "E-mail",
            keyboardType: .emailAddress,
            textContentType: .emailAddress
        )
    }()
    
    private lazy var passwordTextField: UITextField = {
        AppTextField(
            placeholder: "Senha",
            textContentType: .password,
            secureTextEntry: true
        )
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        AppTextField(
            placeholder: "Confirmar senha",
            textContentType: .password,
            secureTextEntry: true
        )
    }()
    
    private lazy var signUpButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Cadastrar"
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            appTitle,
            nameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            signUpButton,
            loadingIndicator
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupView() {
        backgroundColor = .systemBackground

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)

        setHierarchy()
        setConstraints()
    }

    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func setHierarchy(){
        addSubview(contentStackView)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor,
                constant: 16),
            contentStackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor,
                constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    func setLoading(_ isLoading: Bool) {
        nameTextField.isEnabled = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        confirmPasswordTextField.isEnabled = !isLoading
        signUpButton.isEnabled = !isLoading

        if isLoading {
            signUpButton.configuration?.title = "Cadastrando..."
            loadingIndicator.startAnimating()
        } else {
            signUpButton.configuration?.title = "Cadastrar"
            loadingIndicator.stopAnimating()
        }
    }

    @objc
    private func didTapSignUp() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        onSignUpButtonTapped?(name, email, password, confirmPassword)
    }
}
