//
//  TaskCell.swift
//  Tasks
//
//  Created by Adam Lingham on 05/06/2021.
//

import SwiftUI

struct TaskCell: View {
    let viewModel: TaskCellViewModel

    var body: some View {
        HStack(alignment: .top) {
            Image(viewModel.icon)
                .padding([.leading])

            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.medium)

                Text(viewModel.taskDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding([.trailing, .bottom])
        }
    }
}

struct TaskCellViewModel: Identifiable {
    let task: Task

    var id: Int64 { task.id }
    var icon: String { task.type ?? "" }
    var title: String { task.name ?? "" }
    var taskDescription: String { task.taskDescription ?? "" }
}
