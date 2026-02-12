//
//  KeyboardDismiss.swift
//  Cmpe492
//
//  Shared keyboard dismissal helpers for list-heavy screens.
//

import SwiftUI
import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.dismissKeyboard()
            }
        )
    }
}
