//
//  WorkoutNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import NavigationFlow
import SwiftUI
import RoutineRepository


class WorkoutNavigationFlow: NewSheetyNavigationFlow {
    
    // MARK: Properties
    @Published var displayedSheet: SheetyIdentifier?
    
    // MARK: Sheety Destinations
    enum SheetyIdentifier: Identifiable, Hashable {
        
        case addExercise(
            addExercisesCompletion: ([Exercise]) -> Void,
            dismiss: () -> Void
        )
        
        case createRoutineView(
            routineRecord: RoutineRecord,
            superDismiss: () -> Void
        )
        
        
        // Conformance to protocols
        
        var id: Int { self.hashValue }
        
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case .addExercise:
                hasher.combine(0)
            case .createRoutineView:
                hasher.combine(1)
            }
        }
        
        
        static func == (lhs: SheetyIdentifier, rhs: SheetyIdentifier) -> Bool {
            
            switch (lhs, rhs) {
            case (.addExercise, .addExercise): return true
            case (.createRoutineView, .createRoutineView): return true
            default: return false
            }
        }
    }
}
