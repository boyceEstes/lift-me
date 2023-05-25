//
//  CoreDataRoutineStore+Routine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/12/23.
//

import CoreData


public extension CoreDataRoutineStore {
    
    func routineDataSource() -> RoutineDataSource {
        
        let frc = NSFetchedResultsController(
            fetchRequest: ManagedRoutine.findRoutinesRequest(),
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return FRCRoutineDataSourceAdapter(frc: frc)
    }
}
