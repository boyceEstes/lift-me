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


class CreateRoutineNavigationFlow: SheetyStackNavigationFlow {
    
    let addExerciseUIComposer: AddExerciseUIComposer
        
    init(addExerciseUIComposer: AddExerciseUIComposer) {
        
        self.addExerciseUIComposer = addExerciseUIComposer
    }
    
    
    // MARK: - Stack
    @Published var path = [StackIdentifier]()
    
    enum StackIdentifier: Hashable {}
    
    func pushToStack(_ identifier: StackIdentifier) -> some View { EmptyView() }
    
    
    // MARK: - Sheet
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
    
    @Published var modallyDisplayedView: SheetyIdentifier? = nil
    
    
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
