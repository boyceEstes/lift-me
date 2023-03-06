//
//  RoutineDataSource.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 3/2/23.
//

import CoreData
import Combine


public protocol RoutineDataSource {
    
    var routines: CurrentValueSubject<[Routine], Error> { get }
    
//    func refreshRoutines()
}


public class FRCRoutineDataSourceAdapter: NSObject, RoutineDataSource {
    
    private let frc: NSFetchedResultsController<ManagedRoutine>
    public var routines = CurrentValueSubject<[Routine], Error>([])
    
    
    public init(frc: NSFetchedResultsController<ManagedRoutine>) {
        
        self.frc = frc
        super.init()
        
        setupFRC()
    }
    
    
    private func setupFRC() {
        
        frc.delegate = self
        
        performFetch()
    }
    
    
    private func performFetch() {
        
        do {
            try frc.performFetch()
            
            let managedRoutines = frc.fetchedObjects ?? []
            routines.value = managedRoutines.toModel()
        } catch {
            let nsError = error as NSError
            fatalError("Unresoled error \(nsError), \(nsError.userInfo)")
        }
    }
}


extension FRCRoutineDataSourceAdapter: NSFetchedResultsControllerDelegate {
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        print("Did change routine core data content")
        
        let managedRoutines = frc.fetchedObjects ?? []
        self.routines.value = managedRoutines.toModel()
    }
}
