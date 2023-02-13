//
//  CoreDataRoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/14/22.
//

import CoreData


public class CoreDataRoutineStore: RoutineStore {
    
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        
        container = try NSPersistentContainer.load(name: "RoutineStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
        
        printCoreDataStoreURLLocation()
        
        exercisesExistInCache { [weak self] exist in
            
            if !exist {
                self?.seedBasicExercises()
            }
        }
    }
    
    
    private func printCoreDataStoreURLLocation() {
        
        guard let sqliteURL = container.persistentStoreCoordinator.persistentStores.first?.url else { return }
        
        print("--> Core Data database location: \(sqliteURL.absoluteString)")
    }
    
    
    private func exercisesExistInCache(completion: @escaping (Bool) -> Void) {

        readAllExercises { result in
            guard let exercises = try? result.get() else {
                completion(false)
                return
            }
            
            if !exercises.isEmpty {
                completion(true)
            }
        }
    }
    
    
    private func seedBasicExercises() {
        seedExercises.forEach { exercise in
            createExercise(exercise) { error in
                if error != nil {
                    fatalError("seeding didn't work \(exercise), \(error!)")
                }
            }
        }
    }
    
    
    public enum Error: Swift.Error {
        case routineWithNameAlreadyExists
        case cannotUpdateRoutineRecordThatDoesNotExist
        case cannotFindExercise
        case cannotCreateRoutineRecordWithNoExerciseRecords
        case cannotCreateRoutineRecordWithNoSetRecords
        case cannotFindExerciseRoutinesForExerciseThatDoesNotExist
        case cannotFindRoutineWithID
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
                try ManagedRoutine.create(routine, in: context)
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
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
            exercises: self.exercises?.toModel() ?? [],
            routineRecords: self.routineRecords?.toModel() ?? [])
    }
}
