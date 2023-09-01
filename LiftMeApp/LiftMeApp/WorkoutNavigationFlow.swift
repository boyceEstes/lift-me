//
//  WorkoutNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import SwiftUI
import RoutineRepository


class WorkoutNavigationFlow: NewSheetyNavigationFlow, NewStackNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    @Published var displayedSheet: SheetyIdentifier?
    
    enum StackIdentifier: Hashable {
        
        case exerciseDetails(Exercise)
    }
    
    
    // MARK: Sheety Destinations
    enum SheetyIdentifier: Identifiable, Hashable {
        
        case addExercise(
            addExercisesCompletion: ([Exercise]) -> Void
        )
        
        
        case createRoutine(
            routineRecord: RoutineRecord
        )
        
        
        // Conformance to protocols
        
        var id: Int { self.hashValue }
        
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case .addExercise:
                hasher.combine(0)
            case .createRoutine:
                hasher.combine(1)
            }
        }
        
        
        static func == (lhs: SheetyIdentifier, rhs: SheetyIdentifier) -> Bool {
            
            switch (lhs, rhs) {
            case (.addExercise, .addExercise): return true
            case (.createRoutine, .createRoutine): return true
            default: return false
            }
        }
    }
}
