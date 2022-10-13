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
    
    static func findRoutines(in context: NSManagedObjectContext) throws -> [ManagedRoutine] {
        
        let request = ManagedRoutine.fetchRequest
        request.returnsObjectsAsFaults = false
        
        return try context.fetch(request)
    }
}


extension ManagedRoutine {
    static var fetchRequest: NSFetchRequest<ManagedRoutine> {
        NSFetchRequest<ManagedRoutine>(entityName: ManagedRoutine.entity().name ?? "ManagedRoutine")
    }
}


extension ManagedRoutine: Identifiable {}

