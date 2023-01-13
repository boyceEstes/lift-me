//
//  CoreDataRoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/14/22.
//

import CoreData


public class CoreDataRoutineStore: RoutineStore {
    
    public func updateRoutineRecord(newRoutineRecord: RoutineRecord, completion: @escaping UpdateRoutineRecordCompletion) {
        print("Update routine record with some new routine record")
    }
    
    public func deleteRoutineRecord(routineRecord: RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("delete routine record (maybe for the ")
    }
    
    public func createRoutineRecord(completion: @escaping CreateRoutineRecordCompletion) {
        print("Create routine record")
    }
    
    public func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        print("Read all exercises")
    }
    
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(name: "RoutineStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    
    public enum Error: Swift.Error {
        case routineWithNameAlreadyExists
    }
    
    
    // Any and all functions that you want
    public func readAllRoutines(completion: @escaping RoutineStore.ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(in: context).toModel()
                completion(.success(routines))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    private func readRoutines(with name: String, or exercises: [Exercise], completion: @escaping ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(with: name, or: exercises, in: context).toModel()
                completion(.success(routines))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    private func create(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        let context = context
        context.perform {
            do {
                ManagedRoutine.create(routine, in: context)
                try context.save()
                completion(nil)
            } catch {
                
                completion(error)
            }
        }
    }
    
    
    public func createUniqueRoutine(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        readRoutines(with: routine.name, or: []) { [weak self] result in
            switch result {
            case let .success(routines):
                
                if !routines.isEmpty {
                    completion(Error.routineWithNameAlreadyExists)
                    return
                }
                
                self?.create(routine) { error in
                    // if it is successful, deliver nil - otherwise deliver error
                    completion(error)
                    return
                }
                
            case let .failure(error):
                completion(error)
                return
            }
        }
    }
}


private extension NSPersistentContainer {
    
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    
    static func load(name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        
        let description = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [description]
        
        var loadingError: Error?
        container.loadPersistentStores { loadingError = $1 }
        try loadingError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
        return container
    }
}


private extension NSManagedObjectModel {
    
    // Necessary for in-memory caching so that we can avoid ambiguous NSEntityDescription warning during testing
    private static var _model: NSManagedObjectModel?
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        
        if _model == nil {
            _model = bundle
               .url(forResource: name, withExtension: "momd")
               .flatMap { url in
                   NSManagedObjectModel(contentsOf: url)
               }
        }
        
        return _model
    }
}


private extension Array where Element == ManagedRoutine {
    func toModel() -> [Routine] {
        map { $0.toModel() }
    }
}


private extension ManagedRoutine {
    
    func toModel() -> Routine {
        Routine(
            id: self.id,
            name: self.name,
            creationDate: self.creationDate,
            exercises: [],
            routineRecords: self.routineRecords.toModel())
    }
}


private extension Set where Element == ManagedRoutineRecord {
    func toModel() -> [RoutineRecord] {
        map {
            RoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: [])
        }
    }
}

