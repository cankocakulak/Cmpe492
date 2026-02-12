//
//  UndoToast.swift
//  Cmpe492
//
//  Created for Story 3.11 - undo toast presentation
//

import SwiftUI

struct UndoToast: View {
    let message: String
    let onUndo: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.primary)
                .lineLimit(2)

            Spacer(minLength: 0)

            Button("Undo") {
                onUndo()
            }
            .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    UndoToast(message: "Moved to Today") { }
        .padding()
        .previewLayout(.sizeThatFits)
}
