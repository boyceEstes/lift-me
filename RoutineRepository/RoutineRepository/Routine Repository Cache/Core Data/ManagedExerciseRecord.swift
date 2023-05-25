//
//  ManagedExerciseRecord+CoreDataProperties.swift
//  
//
//  Created by Boyce Estes on 1/13/23.
//
//

import Foundation
import CoreData


@objc(ManagedExerciseRecord)
public class ManagedExerciseRecord: NSManagedObject {

    @nonobjc public var fetchRequest: NSFetchRequest<ManagedExerciseRecord> {
        return NSFetchRequest<ManagedExerciseRecord>(entityName: "ManagedExerciseRecord")
    }

    @NSManaged public var id: UUID // Non-optional
    
    @NSManaged public var exercise: ManagedExercise // Non-optional
    @NSManaged public var routineRecord: ManagedRoutineRecord // Non-optional
    @NSManaged public var setRecords: Set<ManagedSetRecord>? // Non-optional in cd
}


// MARK: - Core Data Helpers

// TODO: Test that this will give the correct error if managed exercise cannot be found
extension ManagedExerciseRecord {

    static func createManagedExerciseRecord(_ exerciseRecord: ExerciseRecord, for managedRoutineRecord: ManagedRoutineRecord, in context: NSManagedObjectContext) throws {
        
        guard !exerciseRecord.setRecords.isEmpty else {
            throw CoreDataRoutineStore.Error.cannotCreateRoutineRecordWithNoSetRecords
        }

        let managedExerciseRecord = ManagedExerciseRecord(context: context)
        managedExerciseRecord.id = exerciseRecord.id
        managedExerciseRecord.routineRecord = managedRoutineRecord
        managedExerciseRecord.exercise = try ManagedExercise.findExercise(with: exerciseRecord.exercise.id, in: context)
        
        // Create a managed exercise record with this record
        exerciseRecord.setRecords.forEach { setRecord in
            
            ManagedSetRecord.createManagedSetRecord(setRecord, for: managedExerciseRecord, in: context)
        }
    }
}


extension Set where Element == ManagedExerciseRecord {

    func toModel() -> [ExerciseRecord] {

        map {
            ExerciseRecord(
                id: $0.id,
                setRecords: $0.setRecords?.toModel() ?? [],
                exercise: $0.exercise.toModel()
            )
        }
    }
}


extension Array where Element == ManagedExerciseRecord {

    func toModel() -> [ExerciseRecord] {
        map {
            ExerciseRecord(
                id: $0.id,
                setRecords: $0.setRecords?.toModel() ?? [],
                exercise: $0.exercise.toModel()
            )
        }
    }
}


