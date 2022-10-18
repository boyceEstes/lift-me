//
//  CoreDataRoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/14/22.
//

import CoreData


public class CoreDataRoutineStore: RoutineStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(name: "RoutineStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    // Any and all functions that you want
    public func readAllRoutines(completion: @escaping RoutineStore.ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(in: context).toLocal()
                completion(.success(routines))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    public func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(with: name, or: exercises, in: context).toLocal()
                completion(.success(routines))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    public func create(_ routine: LocalRoutine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
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
    func toLocal() -> [LocalRoutine] {
        map { $0.toLocal() }
    }
}


private extension ManagedRoutine {
    
    func toLocal() -> LocalRoutine {
        LocalRoutine(
            id: self.id,
            name: self.name,
            creationDate: self.creationDate,
            exercises: [],
            routineRecords: self.routineRecords.toLocal())
    }
}


private extension Set where Element == ManagedRoutineRecord {
    func toLocal() -> [LocalRoutineRecord] {
        map {
            LocalRoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: [])
        }
    }
}

