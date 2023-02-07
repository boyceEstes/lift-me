//
//  DispatchQueueMainDecorator+RoutineRepository.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 12/1/22.
//

import RoutineRepository


extension DispatchQueueMainDecorator: RoutineStore where T == RoutineStore {
    

    

    // MARK: Routine
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion) {
        
        decoratee.createUniqueRoutine(routine) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
    
    
    func readRoutines(with name: String, or exercises: [Exercise], completion: @escaping ReadRoutinesCompletion) {
        // TODO: Doesn't matter because its not used
    }
    
    
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion) {
        decoratee.readAllRoutines { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
    
    
    // MARK: Routine Record
    func createRoutineRecord(completion: @escaping CreateRoutineRecordCompletion) {
        print("")
    }
    
    func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
        print("")
    }
    
    
    func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion) {
        print("")
    }
    
    
    func updateRoutineRecord(id: UUID, with updatedCompletionDate: Date?, and updatedExerciseRecords: [RoutineRepository.ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion) {
        
        print("")
    }
    
    func deleteRoutineRecord(routineRecord: RoutineRepository.RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("")
    }
    
    
    // MARK: Exercises
    func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        decoratee.readAllExercises { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
    
    
    func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        decoratee.createExercise(exercise) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
}

