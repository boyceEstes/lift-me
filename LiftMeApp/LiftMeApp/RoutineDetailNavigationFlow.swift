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
        case exerciseDetail(Exercise)
        case workout(Routine)
        
        var id: String {
            switch self {
            case .addExercise:
                return "AddExercise"
            case let .exerciseDetail(exercise):
                return "ExerciseDetail - \(exercise.id.uuidString)"
            case let .workout(routine):
                return "Workout - \(routine.id.uuidString)"
            }
        }
    }
}
