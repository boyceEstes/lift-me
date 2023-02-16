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


class HomeNavigationFlow: SheetyNavigationFlow {
    
    enum SheetyIdentifier: Identifiable {
        
        var id: Int { UUID().hashValue }

        case createRoutine
        case workout(Routine?)
    }
    
    
    let homeUIComposer: HomeUIComposer
    let workoutUIComposer: WorkoutUIComposer
    let createRoutineUIComposer: CreateRoutineUIComposer
    
    
    init(homeUIComposer: HomeUIComposer,
         workoutUIComposer: WorkoutUIComposer,
         createRoutineUIComposer: CreateRoutineUIComposer
    ) {
        
        self.homeUIComposer = homeUIComposer
        self.workoutUIComposer = workoutUIComposer
        self.createRoutineUIComposer = createRoutineUIComposer
    }
    
    
    @Published var modallyDisplayedView: SheetyIdentifier? = nil {
        willSet {
            print("current: \(modallyDisplayedView), new: \(newValue)")
        }
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        Group {
            switch identifier {
                
            case .createRoutine:
                createRoutineUIComposer.makeCreateRoutineViewWithSheetyNavigation(
                    routineRecord: nil,
                    superDismiss: self.dismiss
                )
                
            case let .workout(routine):
                workoutUIComposer.makeWorkoutViewWithSheetyNavigation(
                    routine: routine,
                    dismiss: {
                    print("HomeNavigationFlow is called")
                    self.dismiss()
                })
            }
        }
    }
}
