//
//  TasksWebRepository.swift
//  Tasks
//
//  Created by Adam Lingham on 06/06/2021.
//

import Foundation
import Combine

protocol TasksWebRepositoryType {
    func loadTasks() -> AnyPublisher<Data, TasksError>
}

struct TasksWebRepository: TasksWebRepositoryType {
    private var tasksURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "adam-deleteme.s3.amazonaws.com"
        components.path = "/tasks.json"
        return components.url
    }

    func loadTasks() -> AnyPublisher<Data, TasksError> {
        guard let url = tasksURL else {
            return Fail<Data, TasksError>(error: .badURL)
                .eraseToAnyPublisher()
        }

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
            .dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { _ in TasksError.networkFailure }
            .eraseToAnyPublisher()
    }
}
