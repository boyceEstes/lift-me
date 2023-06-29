//
//  RoutineNavigationViewModel.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 11/24/22.
//

import SwiftUI
import NavigationFlow
import LiftMeRoutinesiOS
import RoutineRepository


class HomeNavigationFlow: SheetyStackNavigationFlow {
    
    
    let homeUIComposer: HomeUIComposer
    let workoutUIComposer: WorkoutUIComposer
    let createRoutineUIComposer: CreateRoutineUIComposer
    let addExerciseUIComposer: AddExerciseUIComposer
    
    
    init(homeUIComposer: HomeUIComposer,
         workoutUIComposer: WorkoutUIComposer,
         createRoutineUIComposer: CreateRoutineUIComposer,
         addExerciseUIComposer: AddExerciseUIComposer
    ) {
        
        self.homeUIComposer = homeUIComposer
        self.workoutUIComposer = workoutUIComposer
        self.createRoutineUIComposer = createRoutineUIComposer
        self.addExerciseUIComposer = addExerciseUIComposer
    }
    
    
    
    // MARK: - Stack
    @Published var path = [StackIdentifier]()
    
    
    enum StackIdentifier: Hashable {
        
        case routineDetail(routine: Routine)
    }
    
    
    @ViewBuilder
    func pushToStack(_ identifier: StackIdentifier) -> some View {

        switch identifier {
        case let .routineDetail(routine: routine):
            homeUIComposer.makeRoutineDetailView(routine: routine)
        }
    }
    
    
    // MARK: - Sheet
    enum SheetyIdentifier: Identifiable, Hashable {
        
        var id: Int { UUID().hashValue }

        case createRoutine
        case workout(Routine?)
        case addExercise(
            addExerciseCompletion: ([Exercise]) -> Void,
            dismiss: () -> Void
        )
        
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case .addExercise:
                hasher.combine(0)
            case .workout:
                hasher.combine(1)
            case .createRoutine:
                hasher.combine(2)
            }
        }
        
        
        static func == (lhs: HomeNavigationFlow.SheetyIdentifier, rhs: HomeNavigationFlow.SheetyIdentifier) -> Bool {
            
            switch (lhs, rhs) {
            case (.addExercise, .addExercise): return true
            case (.createRoutine, .createRoutine): return true
            case (.workout, .workout): return true
            default: return false
            }
        }
    }
    
    
    @Published var modallyDisplayedView: SheetyIdentifier? = nil {
        didSet {
            print("Home Navigation Flow - \(modallyDisplayedView.debugDescription)")
        }
    }
    
    
    @ViewBuilder
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        switch identifier {
            
        case .createRoutine:
            createRoutineUIComposer.makeCreateRoutineViewWithNavigation(
                routineRecord: nil,
                superDismiss: self.dismiss
            )
            
        case let .workout(routine):
            workoutUIComposer.makeWorkoutViewWithNavigation(routine: routine, dismiss: self.dismiss)
            
        case let .addExercise(addExerciseCompletion, dismiss):
            addExerciseUIComposer.makeAddExerciseViewWithNavigation(
                addExerciseCompletion: addExerciseCompletion,
                dismiss: dismiss
            )
        }
    }
}
