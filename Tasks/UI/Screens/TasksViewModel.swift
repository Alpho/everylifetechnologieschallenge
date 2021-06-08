//
//  TasksViewModel.swift
//  Tasks
//
//  Created by Adam Lingham on 05/06/2021.
//

import Foundation
import Combine

final class TasksViewModel: ObservableObject {
    let tasksService: TasksServiceType

    @Published var filterOptions: FilterOptions = []
    @Published private(set) var dataSource = [TaskCellViewModel]()

    private var subscriptions = Set<AnyCancellable>()

    init(tasksService: TasksServiceType = TasksService()) {
        self.tasksService = tasksService

        $filterOptions
            .dropFirst()
            .sink { [weak self] in self?.loadTasks(filter: $0) }
            .store(in: &subscriptions)
    }

    func loadTasks(filter: FilterOptions = []) {
        tasksService.loadTasks(filter: filter)
            .map { $0.map(TaskCellViewModel.init) }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$dataSource)
    }
}
