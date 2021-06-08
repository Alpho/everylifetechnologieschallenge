//
//  TasksService.swift
//  Tasks
//
//  Created by Adam Lingham on 05/06/2021.
//

import Foundation
import Combine

enum TasksError: Error {
    case networkFailure, decodingFailure, badURL, fetchFailure
}

protocol TasksServiceType {
    func loadTasks(filter: FilterOptions) -> AnyPublisher<[Task], TasksError>
}

final class TasksService: TasksServiceType {
    let webRepository: TasksWebRepositoryType
    let dbRepository: TasksDBRepositoryType

    init(
        webRepository: TasksWebRepositoryType = TasksWebRepository(),
        dbRepository: TasksDBRepositoryType = TasksDBRepository()
    ) {
        self.webRepository = webRepository
        self.dbRepository = dbRepository
    }

    func loadTasks(filter: FilterOptions = []) -> AnyPublisher<[Task], TasksError> {
        webRepository.loadTasks()
            .flatMap { self.dbRepository.decodeAndSave(data: $0) }
            .flatMap { _ in self.dbRepository.fetch(filter: filter) }
            .catch { _ in self.dbRepository.fetch(filter: filter) }
            .eraseToAnyPublisher()
    }
}
