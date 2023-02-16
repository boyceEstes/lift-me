//
//  CreateRoutineNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/13/23.
//

import Foundation
import NavigationFlow
import SwiftUI
import RoutineRepository


class CreateRoutineNavigationFlow: SheetyNavigationFlow {
    
    
    enum SheetyIdentifier: Identifiable, Hashable {
        
        var id: UUID { UUID() }
        
        case addExercise(
            addExercisesCompletion: ([Exercise]) -> Void,
            dismiss: () -> Void
        )
        
        case testing
        
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case .addExercise:
                hasher.combine(0)
            case .testing:
                hasher.combine(1)
            }
        }
        
        
        static func == (lhs: CreateRoutineNavigationFlow.SheetyIdentifier, rhs: CreateRoutineNavigationFlow.SheetyIdentifier) -> Bool {
            
            switch (lhs, rhs) {
            case (.addExercise, .addExercise): return true
            case (.testing, .testing): return true
            default: return false
            }
        }
    }
    
    
    let createRoutineUIComposer: CreateRoutineUIComposer
    
    init(createRoutineUIComposer: CreateRoutineUIComposer) {
        
        self.createRoutineUIComposer = createRoutineUIComposer
    }
    
    @Published var modallyDisplayedView: SheetyIdentifier? = nil
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        return Group {
            switch identifier {
            case let .addExercise(addExerciseCompletion, dismiss):
                
                 createRoutineUIComposer.makeAddExerciseView(
                    addExerciseCompletion: addExerciseCompletion,
                    dismiss: dismiss
                )
                
            case .testing:
                Text("Hello world")
            }
        }

    }
}
