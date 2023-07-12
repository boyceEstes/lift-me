//
//  RootView+HomeComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS



extension RootView {
    
    @ViewBuilder
    func makeHomeViewWithStackSheetNavigation() -> some View {
        
        makeHomeViewWithSheetNavigation()
            .flowNavigationDestination(flowPath: $homeNavigationFlowPath) { identifier in
                switch identifier {
                    
                case let .routineDetail(routine: routine):
                    routineDetailViewWithSheetNavigation(routine: routine)
                    
                case let .exerciseDetail(exercise: exercise):
                    exerciseDetailView(exercise: exercise)
                }
            }
    }
    
    
    @ViewBuilder
    private func makeHomeViewWithSheetNavigation() -> some View {
        
        makeHomeView()
        .sheet(item: $homeNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
                
            case let .workout(routine):
                workoutViewWithNavigation(routine: routine)

            case .createRoutine:
                // Only have routine record and super dismiss when it is coming from `WorkoutNavigationFlow`
                createRoutineViewWithNavigation(routineRecord: nil, superDismiss: nil)
            }
        }
    }
    
    
    @ViewBuilder
    private func makeHomeView() -> HomeView {
        
        HomeView(
            routineListView: makeRoutineListView(
                routineStore: routineStore,
                goToCreateRoutine: goToCreateRoutine,
                goToRoutineDetail: goToRoutineDetail
            ),
            goToWorkoutViewWithNoRoutine: goToWorkoutWithNoRoutine
        )
    }
    
    
    // MARK: - Navigation
    func goToCreateRoutine() {
        homeNavigationFlowDisplayedSheet = .createRoutine
    }
    
    
    func goToRoutineDetail(routine: Routine) {
        homeNavigationFlowPath.append(.routineDetail(routine: routine))
    }
    
    
    func goToWorkoutWithNoRoutine() {
        homeNavigationFlowDisplayedSheet = .workout(nil)
    }
}
