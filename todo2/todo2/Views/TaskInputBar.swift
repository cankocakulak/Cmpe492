import SwiftUI

struct TaskInputBar: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    let placeholder: String
    let onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .submitLabel(.done)
                .focused($isFocused)
                .onSubmit {
                    onSubmit()
                }

            Button(action: onSubmit) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
            }
            .accessibilityLabel("Add task")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}
