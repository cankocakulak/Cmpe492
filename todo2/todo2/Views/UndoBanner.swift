import SwiftUI

struct UndoBanner: View {
    @EnvironmentObject private var store: TaskStore

    var body: some View {
        if let undo = store.undoAction {
            HStack(spacing: 12) {
                Text(undo.label)
                    .font(.subheadline)
                Spacer()
                Button("Undo") {
                    store.performUndo()
                }
                .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
