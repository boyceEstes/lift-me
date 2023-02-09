//
//  CoreDataRoutineStore+RoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/6/23.
//

import CoreData


extension CoreDataRoutineStore {
    
    // We pass in a creation date for when newly creating routine
    // (assuming there are no incomplete found)
//    public func getIncompleteRoutineRecord(
//        creationDate: @escaping () -> Date = Date.init,
//        completion: @escaping GetIncompleteRoutineRecordCompletion) {
//
//        print("get incomplete routine record or create a new one")
//
//        let context = context
//        context.perform {
//            do {
////                let newIncompleteRoutineRecord = RoutineRecord(
////                    id: UUID(),
////                    creationDate: creationDate(),
////                    completionDate: nil,
////                    exerciseRecords: [])
////
////                ManagedRoutineRecord.create(newIncompleteRoutineRecord, in: context)
//
//                try context.save()
//
//                let managedRoutineRecord = ManagedRoutineRecord(context: context)
//                managedRoutineRecord.id = UUID()
//                managedRoutineRecord.creationDate = creationDate()
//                managedRoutineRecord.completionDate = nil
//                managedRoutineRecord.routine = nil
//
//                try context.save()
//                // This isn't technically what is saved but it should be the same properties and saves an extra fetch
//                completion(.success(managedRoutineRecord.toModel()))
//
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
    

    
    public func createRoutineRecord(_ routineRecord: RoutineRecord, completion: @escaping CreateRoutineRecordCompletion) {
        print("Create routine record")
        
        let context = context
        
        context.perform {
            do {
                
                try ManagedRoutineRecord.updateIncompleteRoutineRecordsWithCurrentDate(in: context)
                
                try ManagedRoutineRecord.createRoutineRecord(routineRecord, in: context)

                try context.save()
                
                completion(nil)
                
            } catch {
                completion(error)
            }
        }
    }
    
    
    public func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion) {
        
        let context = context
        context.perform {
            do {
                let managedRoutineRecords = try ManagedRoutineRecord.findAllRoutineRecords(in: context)

                completion(.success(managedRoutineRecords.toModel()))
//
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    // TODO: Make sure that we can update routine record exercises
    public func updateRoutineRecord(
        id: UUID,
        updatedCompletionDate: Date?,
        updatedExerciseRecords: [ExerciseRecord],
        completion: @escaping UpdateRoutineRecordCompletion) {
            
        print("Update routine record with some new routine record")
        
        let context = context
        context.perform {
            do {
                guard let managedRoutineRecord = try ManagedRoutineRecord.findRoutineRecord(with: id, in: context) else {
                    
                    throw Error.cannotUpdateRoutineRecordThatDoesNotExist
                }
                
                managedRoutineRecord.completionDate = updatedCompletionDate
                
                // Remove current associated exercise records
                managedRoutineRecord.exerciseRecords?.forEach {
                    context.delete($0)
                }

                // Replace with new associated exercise records
                try updatedExerciseRecords.enumerated().forEach({ (index, exerciseRecord) in
                    
                    // TODO: Create some way to sort the exercise records by passing the index to the object
                    try ManagedExerciseRecord.createManagedExerciseRecord(
                        exerciseRecord,
                        for: managedRoutineRecord,
                        in: context
                    )
                })
                
                try context.save()
                completion(nil)
                
            } catch {
                completion(error)
            }
        }
    }
    
    
    public func deleteRoutineRecord(routineRecord: RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("delete routine record (maybe for the ")
    }
    
//
//    public func createExerciseRecord(_ exerciseRecord: ExerciseRecord, routineRecord: RoutineRecord, completion: @escaping (Swift.Error?) -> Void) {
//
//        let context = context
//        do {
//            let managedRoutineRecord = ManagedRecord(context: context)
//            managedRoutineRecord.id = routineRecord.id
//            managedRoutineRecord.creationDate = routineRecord.creationDate
//            managedRoutineRecord.completionDate = routineRecord.completionDate
//
//            try ManagedExerciseRecord.createManagedExerciseRecord(exerciseRecord, for: managedRoutineRecord, in: context)
//
//            try context.save()
//            completion(nil)
//        } catch {
//            completion(error)
//        }
//    }
    
    
//    public func readAllExerciseRecords(completion: @escaping (Result<[ExerciseRecord], Swift.Error>) -> Void) {
//
//        let context = context
//        do {
//            let request: NSFetchRequest<ManagedExerciseRecord> = ManagedExerciseRecord.fetchRequest()
//            request.returnsObjectsAsFaults = false
//
//            let managedExerciseRecords = try context.fetch(request)
//            let exerciseRecords = managedExerciseRecords.map { ExerciseRecord(id: $0.id, setRecords: [], exercise: Exercise(id: UUID(), name: "blah", creationDate: Date(), tags: [])) }
//
//            completion(.success(exerciseRecords))
//        } catch {
//            completion(.failure(error))
//        }
//    }
}
