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
    @NSManaged public var routineRecords: Set<ManagedRoutineRecord>
}


extension ManagedRoutine {
    
    public static func findRoutines(in context: NSManagedObjectContext) throws -> [ManagedRoutine] {
        
        let request = ManagedRoutine.fetchRequest
        request.returnsObjectsAsFaults = false
        
        return try context.fetch(request)
    }
    
    
    public static func create(_ routine: LocalRoutine, in context: NSManagedObjectContext) {
        
        let managedRoutine = ManagedRoutine(context: context)
        managedRoutine.id = routine.id
        managedRoutine.name = routine.name
        managedRoutine.creationDate = routine.creationDate
        managedRoutine.routineRecords = routine.routineRecords.toManaged(for: managedRoutine, in: context)
    }
}


extension ManagedRoutine {
    static var fetchRequest: NSFetchRequest<ManagedRoutine> {
        NSFetchRequest<ManagedRoutine>(entityName: ManagedRoutine.entity().name ?? "ManagedRoutine")
    }
}


extension ManagedRoutine: Identifiable {}



private extension Array where Element == LocalRoutineRecord {

    func toManaged(for routine: ManagedRoutine, in context: NSManagedObjectContext) -> Set<ManagedRoutineRecord> {
        
        Set(map {
            let managedRoutineRecord = ManagedRoutineRecord(context: context)
            
            managedRoutineRecord.id = $0.id
            managedRoutineRecord.creationDate = $0.creationDate
            managedRoutineRecord.completionDate = $0.completionDate
            managedRoutineRecord.routine = routine
            
            return managedRoutineRecord
        })
    }
}
