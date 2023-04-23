//
//  DispatchQueueMainDecorator+RoutineRepository.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 12/1/22.
//

import RoutineRepository
import Combine


extension DispatchQueueMainDecorator: RoutineDataSource where T == RoutineDataSource {
    
    var routines: AnyPublisher<[Routine], Error> {
        decoratee.routines
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


extension DispatchQueueMainDecorator: ExerciseDataSource where T == ExerciseDataSource {
    
    var exercises: AnyPublisher<[Exercise], Error> {
        decoratee.exercises
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


extension DispatchQueueMainDecorator: RoutineStore where T == RoutineStore {

    // MARK: Routine
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion) {
        
        decoratee.createUniqueRoutine(routine) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
    
    
    func routineDataSource() -> RoutineRepository.RoutineDataSource {
        
        let unsafeRoutineDataSource = decoratee.routineDataSource()
        return DispatchQueueMainDecorator<RoutineDataSource>(decoratee: unsafeRoutineDataSource)
    }
    
    
//    func readRoutines(with name: String, or exercises: [Exercise], completion: @escaping ReadRoutinesCompletion) {
//    }
    
    
    // MARK: Routine Record
    func createRoutineRecord(_ routineRecord: RoutineRepository.RoutineRecord, routine: RoutineRepository.Routine?, completion: @escaping CreateRoutineRecordCompletion) {
        decoratee.createRoutineRecord(routineRecord, routine: routine) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
    
    
    func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
        print("")
    }
    
    
    func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion) {

        decoratee.readAllRoutineRecords { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
    
    
    func updateRoutineRecord(id: UUID, updatedCompletionDate: Date?, updatedExerciseRecords: [RoutineRepository.ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion) {
        
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
    
    
    func exerciseDataSource() -> ExerciseDataSource {
        
        let unsafeExerciseDataSource = decoratee.exerciseDataSource()
        return DispatchQueueMainDecorator<ExerciseDataSource>(decoratee: unsafeExerciseDataSource)
    }
    
    
    func deleteExercise(by exerciseID: UUID, completion: @escaping DeleteExerciseCompletion) {
        
        decoratee.deleteExercise(by: exerciseID) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
    
    
    // MARK: - Exercise Records
    func readExerciseRecords(for exercise: RoutineRepository.Exercise, completion: @escaping ReadExerciseRecordsCompletion) {
        decoratee.readExerciseRecords(for: exercise) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
    
}

