//
//  RootView.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


struct RootView: View {
    
    // new navigation
    let routineStore: RoutineStore
    
    // Home
    @State var homeNavigationFlowPath = [HomeNavigationFlow.StackIdentifier]()
    @State var homeNavigationFlowDisplayedSheet: HomeNavigationFlow.SheetyIdentifier?
    // RoutineDetail
    @State var routineDetailNavigationFlowDisplayedSheet: RoutineDetailNavigationFlow.SheetyIdentifier?
    // Workout
    @State var workoutNavigationFlowDisplayedSheet: WorkoutNavigationFlow.SheetyIdentifier?
    // CreateRoutine
    @State var createRoutineNavigationFlowPath = [CreateRoutineNavigationFlow.StackIdentifier]()
    @State var createRoutineNavigationFlowDisplayedSheet: CreateRoutineNavigationFlow.SheetyIdentifier?
    // Add Exercise
    @State var addExerciseNavigationFlowDisplayedSheet: AddExerciseNavigationFlow.SheetyIdentifier?
    // ExerciseList
    @State var exerciseListNavigationFlowPath = [ExerciseListNavigationFlow.StackIdentifier]()
    @State var exerciseListNavigationFlowDisplayedSheet: ExerciseListNavigationFlow.SheetyIdentifier?
    // History Tab
    @State var historyNavigationFlowPath = [HistoryNavigationFlow.StackIdentifier]()
    
    
    init(routineStore: RoutineStore) {
        // new navigation
        self.routineStore = routineStore
    }
    
    
    var body: some View {
        TabView {
            makeHomeViewWithStackSheetNavigation()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            makeExerciseListViewWithStackSheetNavigation()
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }

            makeHistoryViewWithStackNavigation()
                .tabItem {
                    Label("History", systemImage: "book.closed")
                }
        }
    }
    
    
    // MARK: Exercise Detail View
    
    @ViewBuilder
    func exerciseDetailView(exercise: Exercise) -> some View {
        
        let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
        ExerciseDetailView(viewModel: viewModel)
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            routineStore: RoutineStorePreview()
        )
    }
}
