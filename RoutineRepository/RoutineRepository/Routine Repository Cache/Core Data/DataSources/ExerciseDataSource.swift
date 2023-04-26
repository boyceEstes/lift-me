//
//  ExerciseDataSource.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 4/20/23.
//

import CoreData
import Combine


public protocol ExerciseDataSource {
    
    var exercises: AnyPublisher<[Exercise], Error> { get }
}


public class FRCExerciseDataSourceAdapter: NSObject, ExerciseDataSource {

    // exercises is AnyPublisher to give more control in modifying it before getting to the client (like setting in main queue)
    private let frc: NSFetchedResultsController<ManagedExercise>
    public var exercisesSubject = CurrentValueSubject<[Exercise], Error>([])
    public var exercises: AnyPublisher<[Exercise], Error>
    
    
    public init(frc: NSFetchedResultsController<ManagedExercise>) {
        
        self.frc = frc
        self.exercises = exercisesSubject.eraseToAnyPublisher()
        
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
            
            updateExercisesWithLatestValues()
        } catch {
            let nsError = error as NSError
            fatalError("Unresoled error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func updateExercisesWithLatestValues() {
        
        let managedExercises = frc.fetchedObjects ?? []
        exercisesSubject.send(managedExercises.toModel())
    }
}


extension FRCExerciseDataSourceAdapter: NSFetchedResultsControllerDelegate {
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        updateExercisesWithLatestValues()
    }
}
