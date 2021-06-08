//
//  TasksView.swift
//  Tasks
//
//  Created by Adam Lingham on 05/06/2021.
//

import SwiftUI
import CoreData

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    @EnvironmentObject var networkMonitor: NetworkMonitor

    var body: some View {
        NavigationView {
            VStack {
                if networkMonitor.status == .disconnected {
                    OfflineBanner()
                }

                List(viewModel.dataSource, rowContent: TaskCell.init)
                    .listStyle(PlainListStyle())

                FilterView(filterOptions: $viewModel.filterOptions)
            }
            .navigationBarTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onReceive(networkMonitor.$status) { _ in
            viewModel.loadTasks()
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(
            ColorScheme.allCases,
            id: \.self,
            content: TasksView()
                .environmentObject(NetworkMonitor())
                .preferredColorScheme
        )
    }
}
