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


class WorkoutNavigationFlow: SheetyNavigationFlow {
    
    
    enum SheetyIdentifier: Identifiable, Hashable {
        
        var id: Int { self.hashValue }
        
        case addExercise(
            addExercisesCompletion: ([Exercise]) -> Void,
            dismiss: () -> Void
        )
        
        case createRoutineView(
            routineRecord: RoutineRecord,
            superDismiss: () -> Void
        )
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case .addExercise:
                hasher.combine(0)
            case .createRoutineView:
                hasher.combine(1)
            }
        }
        
        
        static func == (lhs: WorkoutNavigationFlow.SheetyIdentifier, rhs: WorkoutNavigationFlow.SheetyIdentifier) -> Bool {
            
            switch (lhs, rhs) {
            case (.addExercise, .addExercise): return true
            case (.createRoutineView, .createRoutineView): return true
            default: return false
            }
        }
    }
    
    
    let workoutUIComposer: WorkoutUIComposer
    let createRoutineUIComposer: CreateRoutineUIComposer // go to create routine from workout
    let addExerciseUIComposer: AddExerciseUIComposer
    let exerciseUIComposer: ExerciseUIComposer // Go to create exercise, go to exercise details from workout
    
    init(workoutUIComposer: WorkoutUIComposer,
         createRoutineUIComposer: CreateRoutineUIComposer,
         addExerciseUIComposer: AddExerciseUIComposer,
         exerciseUIComposer: ExerciseUIComposer
    ) {
        
        self.workoutUIComposer = workoutUIComposer
        self.createRoutineUIComposer = createRoutineUIComposer
        self.addExerciseUIComposer = addExerciseUIComposer
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    // TODO: Make the SheetyIdentifier a CurrentValueSubject to be more resilient to coding errors
    @Published var modallyDisplayedView: SheetyIdentifier? = nil {
        didSet {
            print("Workout Navigation Flow - \(modallyDisplayedView.debugDescription)")
        }
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        return Group {
            switch identifier {
                
            case let .addExercise(addExerciseCompletion, dismiss):
                addExerciseUIComposer.makeAddExerciseViewWithNavigation(addExerciseCompletion: addExerciseCompletion, dismiss: dismiss)

            case let .createRoutineView(routineRecord, superDismiss):
                
                createRoutineUIComposer.makeCreateRoutineViewWithSheetyNavigation(
                    routineRecord: routineRecord,
                    superDismiss: superDismiss
                )
            }
        }
    }
}
