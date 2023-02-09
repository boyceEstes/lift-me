//
//  ManagedExercise+CoreDataProperties.swift
//  
//
//  Created by Boyce Estes on 1/13/23.
//
//

import Foundation
import CoreData


@objc(ManagedExercise)
public class ManagedExercise: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var desc: String?
    @NSManaged public var creationDate: Date
    
    @NSManaged public var routines: NSSet?
    @NSManaged public var exerciseRecords: NSSet
}


// MARK: Generated accessors for routines
extension ManagedExercise {

    @objc(addRoutinesObject:)
    @NSManaged public func addToRoutines(_ value: ManagedRoutine)

    @objc(removeRoutinesObject:)
    @NSManaged public func removeFromRoutines(_ value: ManagedRoutine)

    @objc(addRoutines:)
    @NSManaged public func addToRoutines(_ values: NSSet)

    @objc(removeRoutines:)
    @NSManaged public func removeFromRoutines(_ values: NSSet)

}

// MARK: Generated accessors for exerciseRecords
extension ManagedExercise {

    @objc(addExerciseRecordsObject:)
    @NSManaged public func addToExerciseRecords(_ value: ManagedExerciseRecord)

    @objc(removeExerciseRecordsObject:)
    @NSManaged public func removeFromExerciseRecords(_ value: ManagedExerciseRecord)

    @objc(addExerciseRecords:)
    @NSManaged public func addToExerciseRecords(_ values: NSSet)

    @objc(removeExerciseRecords:)
    @NSManaged public func removeFromExerciseRecords(_ values: NSSet)
}


extension ManagedExercise {
    
    static var fetchRequest: NSFetchRequest<ManagedExercise> {
        return NSFetchRequest<ManagedExercise>(entityName: "ManagedExercise")
    }
}


// MARK: - Core Data Helpers

extension ManagedExercise {
    
    static func findExercise(with id: UUID, in context: NSManagedObjectContext) throws -> ManagedExercise {
        
        
        let request = ManagedExercise.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        request.returnsObjectsAsFaults = false

        guard let exercise = try context.fetch(request).first else {
            throw CoreDataRoutineStore.Error.cannotFindExercise
        }
        
        return exercise
    }
    
    
    public static func findExercises(in context: NSManagedObjectContext) throws -> [ManagedExercise] {
        
        let request = ManagedExercise.fetchRequest
        request.returnsObjectsAsFaults = false
        
        return try context.fetch(request)
    }
    
    
    public static func create(_ exercise: Exercise, in context: NSManagedObjectContext) {
        
        let managedExercise = ManagedExercise(context: context)
        managedExercise.id = exercise.id
        managedExercise.name = exercise.name
        managedExercise.creationDate = exercise.creationDate
    }
}


// MARK: - Mapping

extension ManagedExercise {
    
    func toModel() -> Exercise {

        Exercise(
            id: self.id,
            name: self.name,
            creationDate: self.creationDate,
            tags: [])
    }
}


extension Array where Element == ManagedExercise {
    
    func toModel() -> [Exercise] {
        map {
            $0.toModel()
        }
    }
}


