//
//  ContentView.swift
//  Cmpe492
//
//  Created by Murat Can Kocakulak on 12.02.2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TodayView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
