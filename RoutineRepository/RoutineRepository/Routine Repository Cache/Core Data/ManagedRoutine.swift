//
//  ManagedRoutine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/13/22.
//
//

import Foundation
import CoreData

@objc(ManagedRoutine)
public class ManagedRoutine: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var creationDate: Date
    @NSManaged public var routineRecords: Set<ManagedRoutineRecord>?
    @NSManaged public var exercises: Set<ManagedExercise>?
}


extension ManagedRoutine {
    
    
    public static func findRoutine(withID id: UUID, in context: NSManagedObjectContext) throws -> ManagedRoutine {
        
        let request = ManagedRoutine.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        request.returnsObjectsAsFaults = false
        
        guard let routine = try context.fetch(request).first else {
            
            throw CoreDataRoutineStore.Error.cannotFindRoutineWithID
        }
        
        return routine
    }
    
    
    public static func findRoutinesRequest() -> NSFetchRequest<ManagedRoutine> {
        
        let request = ManagedRoutine.fetchRequest
        request.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(keyPath: \ManagedRoutine.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    
    public static func findRoutines(in context: NSManagedObjectContext) throws -> [ManagedRoutine] {
        
        let request = findRoutinesRequest()
        
        return try context.fetch(request)
    }
    
    
    public static func findRoutines(with name: String, or exercises: [Exercise], in context: NSManagedObjectContext) throws ->  [ManagedRoutine] {
        
        let request = ManagedRoutine.fetchRequest
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedRoutine.name), name)
        request.predicate = predicate
        
        return try context.fetch(request)
    }
    
    
    public static func create(_ routine: Routine, in context: NSManagedObjectContext) throws {
        
        let managedRoutine = ManagedRoutine(context: context)
        managedRoutine.id = routine.id
        managedRoutine.name = routine.name
        managedRoutine.creationDate = routine.creationDate
        
        managedRoutine.exercises = Set(routine.exercises.toManaged(in: context))
        // sets up routine record entries
//        managedRoutine.routineRecords = try routine.routineRecords.toManaged(for: managedRoutine, in: context)
        
        // figure out exercises and save routine records
        try routine.routineRecords.toManaged2(for: managedRoutine, in: context)
    }
    
    
//    public static func createRoutineAndRoutineRecord(routine: Routine, in context: NSManagedObjectContext) throws {
//
//        let managedRoutine = ManagedRoutine(context: context)
//        managedRoutine.id = routine.id
//        managedRoutine.name = routine.name
//        managedRoutine.creationDate = routine.creationDate
//
//        let managedExercises = try routineRecord.exerciseRecords.map {
//            try ManagedExercise.findExercise(with: $0.exercise.id, in: context)
//        }
//
//        managedRoutine.exercises = Set(managedExercises.map { $0 })
//
//        try ManagedRoutineRecord.createRoutineRecord(routineRecord, managedRoutine: managedRoutine, in: context)
//    }
}


extension ManagedRoutine {
    static var fetchRequest: NSFetchRequest<ManagedRoutine> {
        NSFetchRequest<ManagedRoutine>(entityName: ManagedRoutine.entity().name ?? "ManagedRoutine")
    }
}


extension ManagedRoutine: Identifiable {}


extension Array where Element == ManagedRoutine {
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


private extension Array where Element == RoutineRecord {

    func toManaged(for routine: ManagedRoutine, in context: NSManagedObjectContext) throws -> Set<ManagedRoutineRecord> {
        
        Set(try map {
            let managedRoutineRecord = ManagedRoutineRecord(context: context)
            
            managedRoutineRecord.id = $0.id
            managedRoutineRecord.creationDate = $0.creationDate
            managedRoutineRecord.completionDate = $0.completionDate
            managedRoutineRecord.routine = routine
            
            try $0.exerciseRecords.forEach {
                try ManagedExerciseRecord.createManagedExerciseRecord($0, for: managedRoutineRecord, in: context)
            }
//            managedRoutineRecord.exerciseRecords = $0.exerciseRecords.toManaged(for: routine, in: context)
            
            return managedRoutineRecord
        })
    }
    
    
    
    func toManaged2(for managedRoutine: ManagedRoutine, in context: NSManagedObjectContext) throws {
        
        try forEach {
            let managedRoutineRecord = ManagedRoutineRecord(context: context)
            
            managedRoutineRecord.id = $0.id
            managedRoutineRecord.creationDate = $0.creationDate
            managedRoutineRecord.completionDate = $0.completionDate
            managedRoutineRecord.routine = managedRoutine
            
            // Sets up exercise records and set records
            try $0.exerciseRecords.forEach { exerciseRecord in
                try ManagedExerciseRecord.createManagedExerciseRecord(exerciseRecord, for: managedRoutineRecord, in: context)
                
                let exercise = try ManagedExercise.findExercise(with: exerciseRecord.exercise.id, in: context)
                managedRoutine.exercises?.insert(exercise)
            }
//            managedRoutineRecord.exerciseRecords = $0.exerciseRecords.toManaged(for: routine, in: context)
            
        }
    }
}
