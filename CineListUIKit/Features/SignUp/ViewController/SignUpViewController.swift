//
//  SignUpViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 21/09/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

@MainActor
class SignUpViewController: UIViewController {
    private let contentView = SignUpView()
    private let db = Firestore.firestore()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        contentView.onSignUpButtonTapped = { [weak self] name, email, password, confirmPassword in
            self?.didTapSignUp(name, email, password, confirmPassword)
        }
    }

    private func didTapSignUp(
        _ name: String,
        _ email: String,
        _ password: String,
        _ confirmPassword: String
    ) {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            present(
                ShowAlert.make(
                    title: "Erro",
                    message: "Todos os campos devem ser preenchidos."),
                animated: true
            )
            return
        }

        guard password == confirmPassword else {
            present(
                ShowAlert.make(
                    title: "Erro",
                    message: "As senhas não coincidem."
                ),
                animated: true
            )
            return
        }

        guard password.count >= 6 else {
            present(
                ShowAlert.make(
                    title: "Erro",
                    message: "A senha deve ter pelo menos 6 caracteres."
                ),
                animated: true
            )
            return
        }

        contentView.setLoading(true)

        Auth
            .auth()
            .createUser(
                withEmail: email,
                password: password
            ) { [weak self] authResult, error in
                Task { @MainActor [weak self] in
                    guard let self else { return }

                    self.contentView.setLoading(false)

                    if let error {
                        self.showSignUpError(error)
                        return
                    }

                    guard let user = authResult?.user else {
                        self.present(
                            ShowAlert.make(
                                title: "Erro ao cadastrar",
                                message: "Não foi possível criar sua conta. Tente novamente."
                            ),
                            animated: true
                        )
                        return
                    }

                    let profileChangeRequest = user.createProfileChangeRequest()
                    profileChangeRequest.displayName = name

                    do {
                        try await profileChangeRequest.commitChanges()

                        try await db
                            .collection("users")
                            .document(user.uid)
                            .setData([
                                "uid": user.uid,
                                "name": name,
                                "email": email,
                                "createdAt": FieldValue.serverTimestamp()
                            ])

                        self.showSuccessAlert()
                    } catch {
                        self.present(
                            ShowAlert.make(
                                title: "Erro ao cadastrar",
                                message: "Sua conta foi criada, mas não foi possível salvar todos os dados."
                            ),
                            animated: true
                        )
                    }
                }
            }
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Cadastro realizado",
            message: "Sua conta foi criada com sucesso.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
        )

        present(alert, animated: true)
    }

    private func showSignUpError(_ error: Error) {
        let authError = error as NSError
        let code = AuthErrorCode(rawValue: authError.code)

        let message: String

        switch code {
        case .emailAlreadyInUse:
            message = "Este e-mail já está em uso. Por favor, use outro e-mail."
        case .invalidEmail:
            message = "O e-mail fornecido é inválido."
        case .weakPassword:
            message = "A senha é muito fraca."
        case .networkError:
            message = "Verifique sua conexão com a internet e tente novamente."
        case .operationNotAllowed:
            message = "O cadastro de usuários não está habilitado no momento."
        default:
            message = "Ocorreu um erro ao criar sua conta. Tente novamente."
        }

        present(
            ShowAlert.make(
                title: "Erro ao cadastrar",
                message: message
            ),
            animated: true
        )
    }
}
