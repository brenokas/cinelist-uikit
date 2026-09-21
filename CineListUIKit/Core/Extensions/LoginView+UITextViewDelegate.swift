//
//  LoginView+UiTextViewDelegate.swift
//  CineListUIKit
//
//  Created by breno.farias on 21/09/26.
//
import UIKit

extension LoginView: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,) -> Bool {
            if URL.scheme == "signup" {
                onSignUpTapped?()
            }
            
        return false
    }
}
