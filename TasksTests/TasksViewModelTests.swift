//
//  TasksViewModelTests.swift
//  TasksTests
//
//  Created by Adam Lingham on 05/06/2021.
//

import XCTest
@testable import Tasks
import Combine

final class MockTasksService: TasksServiceType {
    let subject = PassthroughSubject<[Task], TasksError>()

    func loadTasks(filter: FilterOptions) -> AnyPublisher<[Task], TasksError> {
        subject.eraseToAnyPublisher()
    }
}

class TasksViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    override func tearDownWithError() throws {
        subscriptions = []
    }

    func testLoadTasks() throws {
        let tasksService = MockTasksService()
        let tasksViewModel = TasksViewModel(tasksService: tasksService)
        let id = 6
        let name = "Eyelid hygiene"
        let description = "The eyelids should be washed with a cotton bud dipped into a mixture of 1 part baby shampoo and 4 parts water. Linda is going to ensure that the cotton buds and baby shampoo are available. The care worker should wipe the outside of the eyelids with the cotton bud."
        let type = "general"
        let expectation = expectation(description: "testLoadTasks")

        tasksViewModel.loadTasks()
        tasksViewModel.$dataSource.sink {
            guard $0.count == 1,
                  $0[0].id == id,
                  $0[0].title == name,
                  $0[0].icon == type,
                  $0[0].taskDescription == description
            else { return }
            expectation.fulfill()
        }
        .store(in: &subscriptions)

        let json = """
            {
                "id": \(id),
                "name": "\(name)",
                "description": "\(description)",
                "type": "\(type)"
            }
            """
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = PersistenceController(inMemory: true)
            .container
            .viewContext
        let task = try decoder.decode(Task.self, from: json.data(using: .utf8)!)

        tasksService.subject.send([task])

        wait(for: [expectation], timeout: 1)
    }
}
