//
//  CoreDataRoutineStore+Exercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 1/13/23.
//

import CoreData


extension CoreDataRoutineStore {
    
    
    public func createExercise(_ exercise: Exercise, completion: @escaping CreateExerciseCompletion) {

        let context = context
        context.perform {
            do {
                try ManagedExercise.create(exercise, in: context)
                try context.save()
                completion(nil)
            } catch {
                
                completion(error)
            }
        }
    }
    
    
    public func readAllExercises(completion: @escaping ReadExercisesCompletion) {

        let context = context
        context.perform {
            do {
                let exercises = try ManagedExercise.findExercises(in: context).toModel()
                completion(.success(exercises))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    public func exerciseDataSource() -> ExerciseDataSource {
        
        let frc = NSFetchedResultsController(
            fetchRequest: ManagedExercise.findExercisesRequest(),
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return FRCExerciseDataSourceAdapter(frc: frc)
    }
    
    
    public func deleteExercise(by exerciseID: UUID, completion: @escaping DeleteExerciseCompletion) {
        
        let context = context
        context.perform {
            do {
                let managedExerciseToDelete = try ManagedExercise.findExercise(with: exerciseID, in: context)
                context.delete(managedExerciseToDelete)
                
                // TODO: Make sure that the changes here cascade so that if you delete the exercise, it will properly be modified in any routine/routine record
                try context.save()
                completion(nil)
                
            } catch {
                    
                completion(error)
            }
        }
    }
    

    var seedExercises: [Exercise] {
        return [
            Exercise(id: UUID(), name: "Deadlift", creationDate: Date(), tags: []),
            Exercise(id: UUID(), name: "Bench Press", creationDate: Date(), tags: [])
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
