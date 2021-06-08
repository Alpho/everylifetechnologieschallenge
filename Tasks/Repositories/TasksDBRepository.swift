//
//  TasksDBRepository.swift
//  Tasks
//
//  Created by Adam Lingham on 06/06/2021.
//

import Foundation
import Combine
import CoreData

extension CodingUserInfoKey {
    static let managedObjectContext = Self(rawValue: "managedObjectContext")!
}

protocol TasksDBRepositoryType {
    func decodeAndSave(data: Data) -> Future<[Task], TasksError>
    func fetch(filter: FilterOptions) -> Future<[Task], TasksError>
}

final class TasksDBRepository: TasksDBRepositoryType {
    let tasksContext: NSManagedObjectContext

    init(persistentContainer: NSPersistentContainer = PersistenceController.shared.container) {
        tasksContext = persistentContainer.newBackgroundContext()
        tasksContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = tasksContext
        return decoder
    }()

    func decodeAndSave(data: Data) -> Future<[Task], TasksError> {
        .init { [weak self] promise in
            guard let self = self else { return }
            self.tasksContext.perform {
                do {
                    let tasks = try self.decoder.decode([Task].self, from: data)
                    try self.tasksContext.save()
                    promise(.success(tasks))
                } catch {
                    promise(.failure(.decodingFailure))
                }
            }
        }
    }

    func fetch(filter: FilterOptions = []) -> Future<[Task], TasksError> {
        .init { [weak self] promise in
            guard let self = self else { return }
            self.tasksContext.perform {
                let request: NSFetchRequest<Task> = Task.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.id, ascending: true)]

                var predicates = [NSPredicate]()
                if filter.contains(.general) {
                    predicates.append(NSPredicate(format: "type = %@", "general"))
                }
                if filter.contains(.medication) {
                    predicates.append(NSPredicate(format: "type = %@", "medication"))
                }
                if filter.contains(.hydration) {
                    predicates.append(NSPredicate(format: "type = %@", "hydration"))
                }
                if filter.contains(.nutrition) {
                    predicates.append(NSPredicate(format: "type = %@", "nutrition"))
                }
                if !predicates.isEmpty {
                    request.predicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
                }

                do {
                    promise(.success(try self.tasksContext.fetch(request)))
                } catch {
                    promise(.failure(.fetchFailure))
                }
            }
        }
    }
}
