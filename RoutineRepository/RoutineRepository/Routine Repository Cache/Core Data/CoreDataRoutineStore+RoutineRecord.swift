//
//  CoreDataRoutineStore+RoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/6/23.
//

import Foundation


extension CoreDataRoutineStore {
    
    // We pass in a creation date for when newly created routine if there are no incomplete found
    public func getIncompleteRoutineRecord(creationDate: @escaping () -> Date = Date.init, completion: @escaping GetIncompleteRoutineRecordCompletion) {
        print("get incomplete routine record or create a new one")
        
        let context = context
        context.perform {
            do {
                let newIncompleteRoutineRecord = RoutineRecord(id: UUID(), creationDate: creationDate(), completionDate: nil, exerciseRecords: [])
                ManagedRoutineRecord.create(newIncompleteRoutineRecord, in: context)
                try context.save()
                // This isn't technically what is saved but it should be the same properties and saves an extra fetch
                completion(.success(newIncompleteRoutineRecord))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func updateRoutineRecord(with id: UUID, newRoutineRecord: RoutineRepository.RoutineRecord, completion: @escaping UpdateRoutineRecordCompletion) {
        print("Update routine record with some new routine record")
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
