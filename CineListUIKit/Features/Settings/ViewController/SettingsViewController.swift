//
//  SettingsViewController.swift
//  CineListUIKit
//
//  Created by breno.farias on 22/09/26.
//

import UIKit
import FirebaseAuth

@MainActor
final class SettingsViewController: UIViewController {
    private let contentView = SettingsView()
    private let onLogout: () -> Void

    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Configurações"
    }

    private func setupView() {
        contentView.selectedThemeIndex = ThemeManager.shared.currentTheme.rawValue
        
        contentView.onExitTapped = { [weak self] in
            self?.didTapExit()
        }
        
        contentView.onChangeTheme = { [weak self] selectedTheme in
            self?.didChangeTheme(selectedTheme)
        }
    }
    
    private func didChangeTheme(_ selectedTheme: Int) {
        guard let theme = AppTheme(rawValue: selectedTheme) else { return }
        
        ThemeManager.shared.setTheme(theme)
    }

    private func didTapExit() {
        let alert = UIAlertController(
            title: "Deseja sair?",
            message: "Você será desconectado da sua conta.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "Cancelar", style: .cancel)
        )

        alert.addAction(
            UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
                self?.logout()
            }
        )
        present(alert, animated: true)
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            onLogout()
        } catch {
            present(
                ShowAlert.make(
                    title: "Erro ao sair",
                    message: "Não foi possível sair da conta. Tente novamente."
                ),
                animated: true
            )
        }
    }
}
