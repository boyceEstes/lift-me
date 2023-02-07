//
//  CoreDataRoutineStore+RoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/6/23.
//

import Foundation


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
    
    // TODO: Make sure that we can update routine record exercises
    public func updateRoutineRecord(id: UUID, with updatedCompletionDate: Date?, and updatedExerciseRecords: [ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion) {
        print("Update routine record with some new routine record")
        
        let context = context
        context.perform {
            do {
                guard let routineRecordCurrent = try ManagedRoutineRecord.findRoutineRecord(withID: id, in: context) else {
                    
                    throw Error.cannotUpdateRoutineRecordThatDoesNotExist
                }
                
                routineRecordCurrent.completionDate = updatedCompletionDate
                
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
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    
    public func deleteRoutineRecord(routineRecord: RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("delete routine record (maybe for the ")
    }
    
    public func createRoutineRecord(completion: @escaping CreateRoutineRecordCompletion) {
        print("Create routine record")
        
    }
    
    public func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
        print("Read routine record with \(id)")
    }
    
}
