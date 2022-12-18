//
//  DispatchQueueMainDecorator+RoutineRepository.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 12/1/22.
//

import RoutineRepository


extension DispatchQueueMainDecorator: RoutineStore where T == RoutineStore {

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
}

