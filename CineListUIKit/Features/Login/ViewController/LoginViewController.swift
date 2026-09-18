//
//  LoginViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 18/09/26.
//

import UIKit
import FirebaseAuth

@MainActor
class LoginViewController: UIViewController {
    let contentView = LoginView()
    private let onAuthenticated: () -> Void
    
    init(onAuthenticated: @escaping () -> Void) {
        self.onAuthenticated = onAuthenticated
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapLogin() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(
                title: "Erro",
                message: "Por favor, preencha todos os campos.")
            return
        }
        
        setLoading(true)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                self.setLoading(false)
                
                if let error {
                    self.showAuthenticationError(error)
                    return
                }
                
                guard result?.user != nil else {
                    self.showAlert(
                        title: "Erro ao entrar",
                        message: "Não foi possível autenticar. Tente novamente.")
                    return
                }
                
                self.onAuthenticated()
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    private func showAuthenticationError(_ error: Error) {
        let code = AuthErrorCode(rawValue: (error as NSError).code)
        let message: String
        
        switch code {
        case .invalidEmail:
            message = "O e-mail fornecido é inválido."
        case .userNotFound, .wrongPassword, .invalidCredential:
            message = "E-mail ou senha incorretos."
        case .networkError:
            message = "Verifique sua conexão com a internet e tente novamente"
        case .tooManyRequests:
            message = "Muitas tentativas. Aguarde alguns minutos e tente novamente."
        default:
            message = "Ocorreu um erro desconhecido. Tente novamente."
        }
        
        showAlert(
            title: "Erro ao entrar",
            message: message
        )
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        present(alert, animated: true)
    }
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .username
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Entrar"
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
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
            emailTextField,
            passwordTextField,
            loginButton,
            loadingIndicator
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = "Entrar"
        view.backgroundColor = .systemBackground
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        view.addSubview(contentStackView)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor,
                constant: 24),
            contentStackView.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor,
                constant: -24),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
