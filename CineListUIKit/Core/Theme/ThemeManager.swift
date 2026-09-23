//
//  ThemeManager.swift
//  CineListUIKit
//
//  Created by breno.farias on 23/09/26.
//

import UIKit

enum AppTheme: Int {
    case system = 0
    case light = 1
    case dark = 2
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class ThemeManager {
    static let shared = ThemeManager()
    
    private let themeKey = "appTheme"
    
    private init() {}
    
    var currentTheme: AppTheme {
        let savedValue = UserDefaults.standard.object(forKey: themeKey) as? Int
        return AppTheme(rawValue: savedValue ?? AppTheme.system.rawValue) ?? .system
    }
    
    func setTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        apply(theme)
    }
    
    func applySavedTheme() {
        apply(currentTheme)
    }
    
    private func apply(_ theme: AppTheme) {
        let scenes = UIApplication.shared.connectedScenes
        scenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .forEach { window in
                window.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
    }
}
