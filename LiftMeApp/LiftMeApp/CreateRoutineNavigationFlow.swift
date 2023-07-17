//
//  CreateRoutineNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/13/23.
//

import SwiftUI
import RoutineRepository


class CreateRoutineNavigationFlow: NewSheetyNavigationFlow {
    
    @Published var displayedSheet: SheetyIdentifier?
    
    
    // MARK: - Stack
    enum StackIdentifier: Hashable {
        
        case exerciseDetail(Exercise)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .exerciseDetail(exercise):
                hasher.combine("exercise detail - \(exercise.id.uuidString)")
            }
        }
    }
    

    // MARK: - Sheet
    enum SheetyIdentifier: Identifiable, Hashable {

        var id: Int { self.hashValue }
        
        case addExercise(addExercisesCompletion: ([Exercise]) -> Void)

        
        static func == (lhs: CreateRoutineNavigationFlow.SheetyIdentifier, rhs: CreateRoutineNavigationFlow.SheetyIdentifier) -> Bool {
            lhs.id == rhs.id
        }
        
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .addExercise:
                hasher.combine("add exercise")
            }
        }
    }
}
