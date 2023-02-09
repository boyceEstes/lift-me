//
//  Dummy+CoreDataProperties.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/8/23.
//
//

import Foundation
import CoreData


@objc(ManagedRoutineRecord)
public class ManagedRoutineRecord: NSManagedObject {

    @nonobjc public static var fetchRequest: NSFetchRequest<ManagedRoutineRecord> {
        return NSFetchRequest<ManagedRoutineRecord>(entityName: "ManagedRoutineRecord")
    }

    @NSManaged public var completionDate: Date?
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var routine: ManagedRoutine?

}

extension ManagedRoutineRecord : Identifiable {}


// MARK: - Core Data Helpers

extension ManagedRoutineRecord {
    
    
    static func createRoutineRecord(_ routineRecord: RoutineRecord, in context: NSManagedObjectContext) {
        
        let managedRoutineRecord = ManagedRoutineRecord(context: context)
        managedRoutineRecord.id = routineRecord.id
        managedRoutineRecord.creationDate = routineRecord.creationDate
        managedRoutineRecord.completionDate = routineRecord.completionDate
        managedRoutineRecord.routine = nil
    }
    
    
    static func findAllRoutineRecords(in context: NSManagedObjectContext) throws -> [ManagedRoutineRecord] {
        
        let request = ManagedRoutineRecord.fetchRequest
        request.returnsObjectsAsFaults = false

        let records = try context.fetch(request)
        return records
    }
    

    // TODO: Test this by rewriting with TDD
    static func findIncompleteRoutineRecords(in context: NSManagedObjectContext) throws -> [ManagedRoutineRecord] {

        let request = ManagedRoutineRecord.fetchRequest
        request.predicate = NSPredicate(format: "%K == NIL", "completionDate")
        request.returnsObjectsAsFaults = false

        let records = try context.fetch(request)
        return records
    }
    
    
    // TODO: Test this by rewriting with TDD
    static func updateIncompleteRoutineRecordsWithCurrentDate(in context: NSManagedObjectContext) throws {
        
        let incompleteRecords = try ManagedRoutineRecord.findIncompleteRoutineRecords(in: context)
        
        if incompleteRecords.count > 0 {
            
            for incompleteRecord in incompleteRecords {
                incompleteRecord.completionDate = Date()
            }
        }
    }
}


// MARK: -  Mapping


extension Array where Element == ManagedRoutineRecord {
    
    func toModel() -> [RoutineRecord] {
        map {
            RoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: [])
        }
    }
}


extension Set where Element == ManagedRoutineRecord {
    
    func toModel() -> [RoutineRecord] {
        map {
            RoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: []
            )
        }
    }
}
