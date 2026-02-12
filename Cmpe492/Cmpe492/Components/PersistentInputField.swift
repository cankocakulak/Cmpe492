//
//  PersistentInputField.swift
//  Cmpe492
//
//  Created for Story 1.5 - persistent task capture input
//

import SwiftUI

struct PersistentInputField: View {
    @Binding var text: String
    let onSubmit: () -> Void
    var focusTrigger: AnyHashable? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("What needs to be done?", text: $text)
            .font(.body)
            .textFieldStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .focused($isFocused)
            .onAppear {
                DispatchQueue.main.async {
                    isFocused = true
                }
            }
            .onTapGesture {
                isFocused = true
            }
            .onSubmit {
                onSubmit()
                isFocused = true
            }
            .onChange(of: focusTrigger) { _ in
                isFocused = true
            }
            .submitLabel(.done)
    }
}

#Preview {
    PersistentInputField(text: .constant("")) { }
        .padding()
}
