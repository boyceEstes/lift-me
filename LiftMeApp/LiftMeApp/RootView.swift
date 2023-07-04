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
    @StateObject var homeNavigationFlow = HomeNavigationFlow()
    @StateObject var workoutNavigationFlow = WorkoutNavigationFlow()
    @StateObject var exerciseListNavigationFlow = ExerciseListNavigationFlow()
    @StateObject var historyNavigationFlow = HistoryNavigationFlow()
    
    
    init(routineStore: RoutineStore) {
        // new navigation
        self.routineStore = routineStore
    }
    
    
    var body: some View {
        TabView {
            HomeUIComposer.makeHomeView(
                routineStore: routineStore,
                goToCreateRoutine: goToCreateRoutine,
                goToRoutineDetail: goToRoutineDetail,
                goToWorkoutWithNoRoutine: goToWorkoutWithNoRoutine)
            
            .flowNavigationDestination(flowPath: $homeNavigationFlow.path) { identifier in
                switch identifier {
                case let .routineDetail(routine: routine):
                    let viewModel = RoutineDetailViewModel(routine: routine)
                    RoutineDetailView(
                        viewModel: viewModel,
                        goToAddExercise: { }
                    )
                }
            }
            .sheet(item: $homeNavigationFlow.displayedSheet) { identifier in
                switch identifier {
                    
                case let .workout(routine):
                    workoutViewWithNavigation(routine: routine)

                case .createRoutine:
                    // Only have routine record and super dismiss when it is coming from `WorkoutNavigationFlow`
                    createRoutineViewWithNavigation(routineRecord: nil, superDismiss: nil)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
//            exerciseUIComposer.makeExercisesViewWithSheetyStackNavigation()
            ExerciseListUIComposer.makeExerciseList(
                routineStore: routineStore,
                goToCreateExercise: goToCreateExercise,
                goToExerciseDetail: goToExerciseDetail
            )
            .flowNavigationDestination(flowPath: $exerciseListNavigationFlow.path) { identifier in
                switch identifier {
                case let .exerciseDetail(exercise):
                    let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
                    ExerciseDetailView(viewModel: viewModel)
                }
            }
            .sheet(item: $exerciseListNavigationFlow.displayedSheet) { identifier in
                switch identifier {
                case .createExercise:
                    let viewModel = CreateExerciseViewModel(routineStore: routineStore, dismiss: { _ in })
                    NavigationStack {
                        CreateExerciseView(viewModel: viewModel)
                    }
                }
            }
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }
            
//            historyUIComposer.makeHistoryViewWithStackNavigation()
            HistoryUIComposer.makeHistoryView(
                routineStore: routineStore,
                goToRoutineRecordDetail: goToRoutineRecordDetail
            )
            .flowNavigationDestination(flowPath: $historyNavigationFlow.path) { identifier in
                switch identifier {
                case let .routineRecordDetail(routineRecord):
                    let viewModel = RoutineRecordDetailViewModel(routineRecord: routineRecord)
                    RoutineRecordDetailView(viewModel: viewModel)
                }
            }
            .tabItem {
                Label("History", systemImage: "book.closed")
            }
        }
//        .toolbarColorScheme(.light, for: .tabBar)
//        .toolbarColorScheme(Color.universeRed, for: .tabBar)
    }
    
    // MARK: Home Navigation Flow
    func goToCreateRoutine() {
        homeNavigationFlow.displayedSheet = .createRoutine
    }
    
    
    func goToRoutineDetail(routine: Routine) {
        homeNavigationFlow.push(.routineDetail(routine: routine))
    }
    
    
    func goToWorkoutWithNoRoutine() {
        homeNavigationFlow.displayedSheet = .workout(nil)
    }

    // MARK: Workout Navigation Flow
    func workoutViewWithNavigation(routine: Routine?) -> some View {
        
        NavigationStack {
            WorkoutUIComposer.makeWorkoutView(
                routineStore: routineStore,
                routine: routine,
                goToCreateRoutine: goToCreateRoutine,
                goToAddExercise: goToAddExercise
            )
        }
        .sheet(item: $workoutNavigationFlow.displayedSheet) { identifier in
            switch identifier {
            case let .addExercise(addExercisesCompletion):
                let viewModel = AddExerciseViewModel(
                    routineStore: routineStore,
                    addExerciseCompletion: addExercisesCompletion,
                    goToCreateExercise: { _ in })
                AddExerciseView(viewModel: viewModel)
                
            case let .createRoutineView(routineRecord):
                CreateRoutineUIComposer.makeCreateRoutineView(
                    routineStore: routineStore,
                    routineRecord: routineRecord,
                    superDismiss: nil,
                    goToAddExercise: { }
                )
            }
        }
    }
    
    
    func goToCreateRoutine(with routineRecord: RoutineRecord) {
        workoutNavigationFlow.displayedSheet = .createRoutineView(routineRecord: routineRecord)
    }
    
    
    func goToAddExercise(addExercisesCompletion: @escaping AddExercisesCompletion) {
        workoutNavigationFlow.displayedSheet = .addExercise(addExercisesCompletion: addExercisesCompletion)
    }
    
    
    // MARK: Create Routine Flow
    func createRoutineViewWithNavigation(
        routineRecord: RoutineRecord?,
        superDismiss: (() -> Void)?
    ) -> some View {
        
        NavigationStack {
            CreateRoutineUIComposer.makeCreateRoutineView(
                routineStore: routineStore,
                routineRecord: routineRecord,
                superDismiss: superDismiss,
                goToAddExercise: { }
            )
        }
    }
    
    
    // MARK: Add Exercise Flow
//    func goToCreateExerciseFromAddExercise(createExerciseCompletion: (Exercise) -> Void) {
//        addExerciseFlow.displayedSheet =
//    }
    
    
    // MARK: Exercise List Navigation Flow
    func goToExerciseDetail(exercise: Exercise) {
        exerciseListNavigationFlow.push(.exerciseDetail(exercise))
    }
    
    
    func goToCreateExercise() {
        exerciseListNavigationFlow.displayedSheet = .createExercise
    }
    
    
    // MARK: History Navigation Flow
    func goToRoutineRecordDetail(routineRecord: RoutineRecord) {
        historyNavigationFlow.push(.routineRecordDetail(routineRecord))
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            routineStore: RoutineStorePreview()
        )
    }
}
