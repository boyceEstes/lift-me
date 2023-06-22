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

        var id: Int { self.hashValue }
        
        case addExercise(
            addExercisesCompletion: ([Exercise]) -> Void,
            dismiss: () -> Void
        )
        
        
        static func == (lhs: CreateRoutineNavigationFlow.SheetyIdentifier, rhs: CreateRoutineNavigationFlow.SheetyIdentifier) -> Bool {
            lhs.id == rhs.id
        }
        
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(0)
        }
    }
    
    
    let addExerciseUIComposer: AddExerciseUIComposer
        @Published var modallyDisplayedView: SheetyIdentifier? = nil
    
        
    init(addExerciseUIComposer: AddExerciseUIComposer) {
        
        self.addExerciseUIComposer = addExerciseUIComposer
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        return Group {
            switch identifier {
            case let .addExercise(addExerciseCompletion, dismiss):
                
                addExerciseUIComposer.makeAddExerciseViewWithNavigation(
                    addExerciseCompletion: addExerciseCompletion,
                    dismiss: dismiss
                )
            }
        }
    }
}
