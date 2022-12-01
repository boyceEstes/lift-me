//
//  DispatchQueueMainDecorator+RoutineRepository.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 12/1/22.
//

import RoutineRepository


extension DispatchQueueMainDecorator: RoutineRepository where T == RoutineRepository {
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {
        
        decoratee.save(routine: routine) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
    
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        
        decoratee.loadAllRoutines { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

