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
    
    
    public static func findRoutineRecord(withID id: UUID, in context: NSManagedObjectContext) throws -> ManagedRoutineRecord? {
        
        let request = ManagedRoutineRecord.fetchRequest
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(
            format: "%K == %@",
            "id",
            id as CVarArg
        )
        
        request.predicate = predicate
        
        return try context.fetch(request).first
    }
    
    
    public static func findAllRoutineRecords(in context: NSManagedObjectContext) throws -> [ManagedRoutineRecord] {
        
        let request = ManagedRoutineRecord.fetchRequest
        request.returnsObjectsAsFaults = false

        return try context.fetch(request)
    }
}


public extension Array where Element == ManagedRoutineRecord {

    func toModel() -> [RoutineRecord] {
        self.map {
            RoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: []
            )
        }
    }
}


public extension ManagedRoutineRecord {
    
    func toModel() -> RoutineRecord {
        RoutineRecord(id: self.id, creationDate: self.creationDate, completionDate: self.completionDate, exerciseRecords: [])
    }
}
