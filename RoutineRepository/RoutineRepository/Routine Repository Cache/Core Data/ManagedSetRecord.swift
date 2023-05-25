//
//  ManagedSetRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import CoreData

@objc(ManagedSetRecord)
public class ManagedSetRecord: NSManagedObject {
    
    @nonobjc public static var fetchRequest: NSFetchRequest<ManagedSetRecord> {
        NSFetchRequest<ManagedSetRecord>(entityName: "ManagedSetRecord")
    }
    
    @NSManaged public var id: UUID // non-optional in cd
    
    // We can only represent scalars in Swift as optional by using something like NSNumber or Decimal
    // So for now, they will be nonoptional
    
    @NSManaged public var weight: Double // optional in cd
    @NSManaged public var repCount: Double // optional in cd
    
    @NSManaged public var exerciseRecord: ManagedExerciseRecord // non-optional
}


extension ManagedSetRecord: Identifiable { }


extension ManagedSetRecord {
    
    static func createManagedSetRecord(_ setRecord: SetRecord, for managedExerciseRecord: ManagedExerciseRecord, in context: NSManagedObjectContext) {
        
        let managedSetRecord = ManagedSetRecord(context: context)
        managedSetRecord.id = setRecord.id
        managedSetRecord.weight = setRecord.weight
        managedSetRecord.repCount = setRecord.repCount
        managedSetRecord.exerciseRecord = managedExerciseRecord
    }
}


extension Set where Element == ManagedSetRecord {
    
    func toModel() -> [SetRecord] {
        map {
            SetRecord(
                id: $0.id,
                duration: nil,
                repCount: $0.repCount,
                weight: $0.weight,
                difficulty: nil)
            
        }
    }
}
