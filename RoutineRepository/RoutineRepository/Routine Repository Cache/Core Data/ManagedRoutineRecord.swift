//
//  ManagedRoutineRecord+CoreDataClass.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/13/22.
//
//

import Foundation
import CoreData

@objc(ManagedRoutineRecord)
public class ManagedRoutineRecord: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var creationDate: Date
    @NSManaged public var completionDate: Date?
    @NSManaged public var routine: ManagedRoutine?
}


extension ManagedRoutineRecord {
    
    static var fetchRequest: NSFetchRequest<ManagedRoutineRecord> {
        
        return NSFetchRequest<ManagedRoutineRecord>(entityName: ManagedRoutine.entity().name ?? "ManagedRoutineRecord")
    }
}


extension ManagedRoutineRecord: Identifiable {}


// TODO: add exercise records to routine record
extension ManagedRoutineRecord {
    
    public static func create(_ routineRecord: RoutineRecord, in context: NSManagedObjectContext) {
        
        let managedRoutineRecord = ManagedRoutineRecord(context: context)
        managedRoutineRecord.id = routineRecord.id
        managedRoutineRecord.creationDate = routineRecord.creationDate
        managedRoutineRecord.completionDate = routineRecord.completionDate
        managedRoutineRecord.routine = nil
    }
}
