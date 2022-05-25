//
//  CoreDataExerciseStore.swift
//  ExerciseRepository
//
//  Created by Boyce Estes on 5/24/22.
//

import Foundation
import CoreData


public class CoreDataExerciseStore: ExerciseStore {
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
        
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        
        container = try NSPersistentContainer.load("ExerciseStore", at: storeURL, from: bundle)
        context = container.newBackgroundContext()
    }

    
    // Exercise Use Cases
    public func insert(exercise: LocalExercise, completion: @escaping InsertExerciseCompletion) {
        
        let context = context
        context.perform {
            
            let managedExercise = ManagedExercise(context: context)
            managedExercise.id = exercise.id
            managedExercise.name = exercise.name
            managedExercise.dateCreated = exercise.dateCreated
            managedExercise.desc = exercise.desc
            
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    public func retrieveAll(completion: @escaping RetrieveAllExercisesCompletion) {
        
        let context = context
        context.perform {
            
            do {
                let request = NSFetchRequest<ManagedExercise>(entityName: ManagedExercise.entity().name!)
                request.returnsObjectsAsFaults = false
                
                let exercises = try context.fetch(request).toLocal()
                
                completion(.success(exercises))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    public func update(exercise: LocalExercise, completion: @escaping UpdateExerciseCompletion) {
    }
    
    
    public func delete(exercise: LocalExercise, completion: @escaping DeleteExerciseCompletion) {
    }
    
    
    // Exercise Record Use Case
    public func insert(exerciseRecord: LocalExerciseRecord, completion: @escaping InsertExerciseRecordCompletion) {
    }
    
    
    public func retrieveAllExerciseRecords(completion: @escaping RetrieveAllExerciseRecordsCompletion) {
    }
    
    
    public func delete(exerciseRecord: LocalExerciseRecord, completion: @escaping DeleteExerciseRecordCompletion) {
    }
    
    
    // Set Record Use Case
    public func insert(setRecord: LocalSetRecord, completion: @escaping InsertSetRecordCompletion) {
    }

    
    public func update(setRecord: LocalSetRecord, completion: @escaping UpdateSetRecordCompletion) {
    }
    
    
    public func delete(setRecord: LocalSetRecord, completion: @escaping DeleteSetRecordCompletion) {
    }
}


extension NSPersistentContainer {
    
    enum LoadingError: Error {
        case modelNotFound
        case failureLoadingPersistentStores(Error)
    }
    
    static func load(_ name: String, at storeURL: URL, from bundle: Bundle) throws -> NSPersistentContainer {
        
        guard let managedModel = NSManagedObjectModel.with(name, from: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: name, managedObjectModel: managedModel)
        
        let description = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [description]
        
        var loadingError: Error?
        container.loadPersistentStores { loadingError = $1 }
        try loadingError.map { throw LoadingError.failureLoadingPersistentStores($0) }
        
        return container
    }
}


extension NSManagedObjectModel {
    
    static func with(_ name: String, from bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}


@objc(ManagedExercise)
class ManagedExercise: NSManagedObject {
    
    @NSManaged var id: UUID
    @NSManaged var desc: String?
    @NSManaged var name: String
    @NSManaged var dateCreated: Date
    
    var local: LocalExercise {
        LocalExercise(id: self.id, name: self.name, dateCreated: self.dateCreated, desc: self.desc, exerciseRecords: [])
    }
}


extension Array where Element == ManagedExercise {
    func toLocal() -> [LocalExercise] {
        self.map { $0.local }
    }
}
