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

    @NSManaged public var id: UUID?
    @NSManaged public var exercise: ManagedExercise?
}
