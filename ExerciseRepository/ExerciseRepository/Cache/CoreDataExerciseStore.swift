//
//  CoreDataExerciseStore.swift
//  ExerciseRepository
//
//  Created by Boyce Estes on 5/24/22.
//

import Foundation
import CoreData


public class CoreDataExerciseStore: ExerciseStore {
    
    public enum Error: Swift.Error {
        case recordNotFound(LocalExercise)
        case cannotUpdateDuplicate(LocalExercise)
    }
    
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
            
            ManagedExercise.newExercise(from: exercise, in: context)
            
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
                let exercises = try ManagedExercise.findExercises(in: context).toLocal()
                completion(.success(exercises))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    public func update(exercise: LocalExercise, with updatedExercise: LocalExercise, completion: @escaping UpdateExerciseCompletion) {

        guard exercise != updatedExercise else {
            completion(Error.cannotUpdateDuplicate(exercise))
            return
        }
        
        let context = context
        context.perform {
            do {
                guard let exercise = try ManagedExercise.find(exercise: exercise, in: context) else {
                    completion(Error.recordNotFound(exercise))
                    return
                }
                
                exercise.id = exercise.id
                exercise.name = exercise.name
                exercise.dateCreated = exercise.dateCreated
                exercise.desc = exercise.desc
                
                try context.save()
                completion(nil)
                
            } catch {
                completion(error)
            }
        }
    }

    
    public func delete(exercise: LocalExercise, completion: @escaping DeleteExerciseCompletion) {
        
        let context = context
        context.perform {
            do {
                guard let exercise = try ManagedExercise.find(exercise: exercise, in: context) else {
                    completion(Error.recordNotFound(exercise))
                    return
                }
                    
                context.delete(exercise)
                
                try context.save()
                completion(nil)
                
            } catch {
                completion(error)
            }
        }
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
    
    
    @discardableResult
    static func newExercise(from exercise: LocalExercise, in context: NSManagedObjectContext) -> ManagedExercise {
        
        let managedExercise = ManagedExercise(context: context)
        managedExercise.id = exercise.id
        managedExercise.name = exercise.name
        managedExercise.dateCreated = exercise.dateCreated
        managedExercise.desc = exercise.desc
        return managedExercise
    }
    
    
    static func findExercises(in context: NSManagedObjectContext) throws -> [ManagedExercise] {
        
        let request = ManagedExercise.fetchRequest
        request.returnsObjectsAsFaults = false
        
        return try context.fetch(request)
    }
    
    
    static func find(exercise: LocalExercise, in context: NSManagedObjectContext) throws -> ManagedExercise? {
        
        let request = ManagedExercise.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", "id", exercise.id as CVarArg)
        request.returnsObjectsAsFaults = false
        
        return try context.fetch(request).first
    }
    
    
    var local: LocalExercise {
        LocalExercise(id: self.id, name: self.name, dateCreated: self.dateCreated, desc: self.desc, exerciseRecords: [])
    }
    
    
    static var fetchRequest: NSFetchRequest<ManagedExercise> {
        NSFetchRequest<ManagedExercise>(entityName: ManagedExercise.entity().name!)
    }
}


extension Array where Element == ManagedExercise {
    func toLocal() -> [LocalExercise] {
        self.map { $0.local }
    }
}
