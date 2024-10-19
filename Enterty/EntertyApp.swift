//
//  EntertyApp.swift
//  Enterty
//
//  Created by PandaSan on 10/19/24.
//

import SwiftUI

@main
struct EntertyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
