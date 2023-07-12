//
//  RoutineDetailNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/11/23.
//

import RoutineRepository


class RoutineDetailNavigationFlow {
    
    enum SheetyIdentifier: Identifiable {
        
        case addExercise(([Exercise]) -> Void)
        case exerciseDetail
        case workout(Routine)
        
        var id: String {
            switch self {
            case .addExercise:
                return "AddExercise"
            case .exerciseDetail:
                return "ExerciseDetail"
            case let .workout(routine):
                return "Workout - \(routine.id.uuidString)"
            }
        }
    }
}
