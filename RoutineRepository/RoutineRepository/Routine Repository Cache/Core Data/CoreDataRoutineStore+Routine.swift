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
    
    
    // Any and all functions that you want
    func readAllRoutines(completion: @escaping RoutineStore.ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(in: context).toModel()
                completion(.success(routines))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func createUniqueRoutine(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        readRoutines(with: routine.name, or: []) { [weak self] result in
            switch result {
            case let .success(routines):
                
                if !routines.isEmpty {
                    completion(Error.routineWithNameAlreadyExists)
                    return
                }
                
                self?.create(routine) { error in
                    // if it is successful, deliver nil - otherwise deliver error
                    completion(error)
                    return
                }
                
            case let .failure(error):
                completion(error)
                return
            }
        }
    }
    
    
    func readRoutine(with id: UUID, completion: @escaping ReadRoutineCompletion) {
        
        let context = context
        context.perform {
            
            do {
                let routine = try ManagedRoutine.findRoutine(withID: id, in: context).toModel()
                
                completion(.success(routine))
            } catch {
                
                completion(.failure(error))
            }
        }
    }
    
    
    /// updatedRoutine's `id` and `creationDate` properties will not be updated in CoreData - If a usecase appears, this can be changed
    func updateRoutine(with id: UUID, updatedRoutine: Routine, completion: @escaping UpdateRoutineCompletion) {
        
        let context = context
        context.perform {

            do {
                let routine = try ManagedRoutine.findRoutine(withID: id, in: context)
//                routine.id = updatedRoutine.id
                routine.name = updatedRoutine.name
//                routine.creationDate = updatedRoutine.creationDate
                routine.exercises = Set(try updatedRoutine.exercises.toManaged(in: context))
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    private func readRoutines(with name: String, or exercises: [Exercise], completion: @escaping ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(with: name, or: exercises, in: context).toModel()
                completion(.success(routines))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    private func create(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        let context = context
        context.perform {
            do {
                try ManagedRoutine.create(routine, in: context)
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }
}
