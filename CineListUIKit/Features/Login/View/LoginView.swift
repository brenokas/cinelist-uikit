//
//  LoginView.swift
//  CineListUIKit
//
//  Created by breno.farias on 18/09/26.
//

import UIKit

class LoginView: UIView {
    var onLoginButtonTapped: ((String, String) -> Void)?
    var onSignUpTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var appTitle: UILabel = {
        let label = UILabel()
        label.text = "CineList"
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private lazy var signUpTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        let fullText = "Não possui uma conta? Cadastre-se"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: fullText.utf16.count))
        
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 14),
            range: NSRange(location: 0, length: fullText.count))
        
        let linkRange = (fullText as NSString).range(of: "Cadastre-se")
        attributedString.addAttribute(
            .link,
            value: "signup://",
            range: linkRange)
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.systemBlue,
            range: linkRange)
        
        textView.attributedText = attributedString
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
            emailTextField,
            passwordTextField,
            loginButton,
            loadingIndicator,
            signUpTextView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    func setLoading(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading

        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }

    private func setupView() {
        backgroundColor = .systemBackground
        contentStackView.setCustomSpacing(24, after: appTitle)

        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        addSubview(contentStackView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor,
                constant: 24),
            contentStackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor,
                constant: -24),

            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    @objc
    private func didTapLogin() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        onLoginButtonTapped?(email, password)
    }
    
    @objc
    private func didTapSignIn() {
        onSignUpTapped?()
    }
}
