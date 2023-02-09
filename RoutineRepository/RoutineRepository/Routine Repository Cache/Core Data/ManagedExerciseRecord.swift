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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedExerciseRecord> {
        return NSFetchRequest<ManagedExerciseRecord>(entityName: "ManagedExerciseRecord")
    }

    @NSManaged public var id: UUID // Non-optional
    
    @NSManaged public var exercise: ManagedExercise // Non-optional
    @NSManaged public var routineRecord: ManagedRoutineRecord // Non-optional
}


// MARK: - Core Data Helpers

// TODO: Test that this will give the correct error if managed exercise cannot be found
extension ManagedExerciseRecord {

    static func createManagedExerciseRecord(_ exerciseRecord: ExerciseRecord, for managedRoutineRecord: ManagedRoutineRecord, in context: NSManagedObjectContext) throws {

        let managedExerciseRecord = ManagedExerciseRecord(context: context)
        managedExerciseRecord.id = exerciseRecord.id
        managedExerciseRecord.routineRecord = managedRoutineRecord
        managedExerciseRecord.exercise = try ManagedExercise.findExercise(with: exerciseRecord.exercise.id, in: context)
    }
}


extension Set where Element == ManagedExerciseRecord {

    func toModel() -> [ExerciseRecord] {

        let managedExerciseRecordArray = Array(self)

        return managedExerciseRecordArray.map {
            ExerciseRecord(
                id: $0.id,
                setRecords: [],
                exercise: $0.exercise.toModel()
            )
        }
    }
}
