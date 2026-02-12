//
//  DatePickerSheet.swift
//  Cmpe492
//
//  Created for Story 3.6 - choose specific future date
//

import SwiftUI

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let minimumDate: Date
    let onDone: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: minimumDate...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()

                Spacer()
            }
            .navigationTitle("Choose Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { onDone() }
                }
            }
        }
    }
}

#Preview {
    DatePickerSheet(
        selectedDate: .constant(Date()),
        minimumDate: Date(),
        onDone: {},
        onCancel: {}
    )
}
