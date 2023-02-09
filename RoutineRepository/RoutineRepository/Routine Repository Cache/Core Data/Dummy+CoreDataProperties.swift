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

    @nonobjc public var fetchRequest: NSFetchRequest<ManagedRoutineRecord> {
        return NSFetchRequest<ManagedRoutineRecord>(entityName: "ManagedRoutineRecord")
    }

    @NSManaged public var completionDate: Date?
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var routine: ManagedRoutine?

}

extension ManagedRoutineRecord : Identifiable {}

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
