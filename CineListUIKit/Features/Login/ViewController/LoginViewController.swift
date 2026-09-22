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
    private let contentView = LoginView()
    private let onAuthenticated: () -> Void
    
    init(onAuthenticated: @escaping () -> Void) {
        self.onAuthenticated = onAuthenticated
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        contentView.onLoginButtonTapped = { [weak self] email, password in
            self?.didTapLogin(email: email, password: password)
        }
        
        contentView.onSignUpTapped = { [weak self] in
            let signUpViewController = SignUpViewController()
            self?.navigationController?.pushViewController(
                signUpViewController,
                animated: true)
        }
    }

    private func didTapLogin(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            present(
                ShowAlert.make(
                    title: "Erro",
                    message: "Por favor, preencha todos os campos."
                ),
                animated: true
            )
            return
        }

        contentView.setLoading(true)

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self else { return }

                self.contentView.setLoading(false)

                if let error {
                    self.showAuthenticationError(error)
                    return
                }

                guard result?.user != nil else {
                    present(
                        ShowAlert.make(
                            title: "Erro ao entrar",
                            message: "Não foi possível autenticar. Tente novamente."
                        ),
                        animated: true
                    )
                    return
                }

                self.onAuthenticated()
            }
        }
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

        let alert = ShowAlert.make(
            title: "Erro ao entrar",
            message: message
        )

        present(alert, animated: true)
    }
}
