//
//  CoreDataRoutineStore+Exercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 1/13/23.
//

import Foundation


extension CoreDataRoutineStore {
    
    
    public func readAllExercises(completion: @escaping ReadExercisesCompletion) {

        let context = context
        context.perform {
//            do {
//                let exercises = try ManagedExercise.findExercises(in: context)
                completion(.success([]))
//            } catch {
//                completion(.failure(error))
//            }
        }
    }
    
    
    private func createExercises(exercises: [Exercise]) {
        
        let context = context
        context.perform {
            do {
                exercises.forEach { ManagedExercise.create($0, in: context) }
                try context.save()
            } catch {
                fatalError("Some error \(error)")
            }
        }
    }
    

    var seedExercises: [Exercise] {
        return [
            Exercise(id: UUID(), name: "Deadlift", creationDate: Date(), exerciseRecords: [], tags: []),
            Exercise(id: UUID(), name: "Bench Press", creationDate: Date(), exerciseRecords: [], tags: [])
//            Exercise(name: "Deadlift", tags: [.back]),
//            Exercise(name: "Bench press", tags: [.chest]),
//            Exercise(name: "Squat", tags: [.glutes, .quads, .hamstrings]),
//            Exercise(name: "Bicep curl", tags: [.bicep]),
//            Exercise(name: "Tricep extension", tags: [.tricep]),
//            Exercise(name: "Overhead tricep extension", tags: [.tricep]),
//            Exercise(name: "Leg press", tags: [.quads, .glutes]),
//            Exercise(name: "Bicep dumbbell press", tags: [.bicep]),
//            Exercise(name: "Single-leg press", tags: [.quads]),
//            Exercise(name: "Romanian deadlift", tags: [.back, .hamstrings]),
//            Exercise(name: "Single-leg Romanian deadlift", tags: [.hamstrings]),
//            Exercise(name: "Leg curl", tags: [.hamstrings]),
//            Exercise(name: "Lying leg curl", tags: [.hamstrings]),
//            Exercise(name: "Leg extension", tags: [.quads]),
//            Exercise(name: "Cable bicep curl", tags: [.bicep]),
//            Exercise(name: "Cable tricep extension", tags: [.tricep]),
//            Exercise(name: "Tricep extensions", tags: [.tricep]),
//            Exercise(name: "Tricep skullcrushers", tags: [.tricep]),
//            Exercise(name: "Chest fly", tags: [.chest])
        ]
    }
}


private extension ManagedExercise {
    
//    func toModel() -> Exercise {
//        
//        Exercise(
//            id: self.id,
//            name: self.name,
//            creationDate: self.creationDate,
//            exerciseRecords: [],
//            tags: [])
//    }
}


