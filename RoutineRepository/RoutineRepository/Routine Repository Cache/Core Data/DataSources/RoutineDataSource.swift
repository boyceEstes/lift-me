//
//  RoutineDataSource.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 3/2/23.
//

import CoreData
import Combine


public protocol RoutineDataSource {
    
//    var routines: CurrentValueSubject<[Routine], Error> { get }
    var routines: AnyPublisher<[Routine], Error> { get}
    
//    func refreshRoutines()
}


public class FRCRoutineDataSourceAdapter: NSObject, RoutineDataSource {
    
    private let frc: NSFetchedResultsController<ManagedRoutine>
    public var routinesSubject = CurrentValueSubject<[Routine], Error>([])
    public var routines: AnyPublisher<[Routine], Error>
    
    
    public init(frc: NSFetchedResultsController<ManagedRoutine>) {
        
        self.frc = frc
        self.routines = routinesSubject.eraseToAnyPublisher()
        
        super.init()
        
        setupFRC()
    }
    
    
    private func setupFRC() {
        
        frc.delegate = self
        
        performFetch()
        // In progress:
//        routinesSubject.sink { error in
//
//        } receiveValue: { routines in
//            <#code#>
//        }

    }
    
    
    private func performFetch() {
        
        do {
            try frc.performFetch()
            
            let managedRoutines = frc.fetchedObjects ?? []
            routinesSubject.send(managedRoutines.toModel())
//            routines.value = managedRoutines.toModel()
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
//        self.routines.value = managedRoutines.toModel()
        self.routinesSubject.send(managedRoutines.toModel())
    }
}
