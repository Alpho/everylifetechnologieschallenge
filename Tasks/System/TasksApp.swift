//
//  TasksApp.swift
//  Tasks
//
//  Created by Adam Lingham on 05/06/2021.
//

import SwiftUI

@main
struct TasksApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.isRunningTests {
                Text("Running unit tests...")
            } else {
                TasksView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(NetworkMonitor())
            }
        }
    }
}

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
