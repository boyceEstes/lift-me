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
    
    
    init(homeUIComposer: HomeUIComposer,
         workoutUIComposer: WorkoutUIComposer,
         createRoutineUIComposer: CreateRoutineUIComposer
    ) {
        
        self.homeUIComposer = homeUIComposer
        self.workoutUIComposer = workoutUIComposer
        self.createRoutineUIComposer = createRoutineUIComposer
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
    enum SheetyIdentifier: Identifiable, Equatable {
        
        var id: Int { UUID().hashValue }

        case createRoutine
        case workout(Routine?)
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
        }
    }
}
