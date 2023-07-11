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
        
        // Routines
        case routineWithNameAlreadyExists
        case cannotFindRoutineWithID
        
        // Routine Records
        case cannotUpdateRoutineRecordThatDoesNotExist
        case cannotCreateRoutineRecordWithNoExerciseRecords
        case cannotCreateRoutineRecordWithNoSetRecords
        
        // Exercises
        case cannotFindExercise
        case exerciseWithNameAlreadyExists
        
        // Exercise Records
        case cannotFindExerciseRoutinesForExerciseThatDoesNotExist
        
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

