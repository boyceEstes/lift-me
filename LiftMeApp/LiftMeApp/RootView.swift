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
    
//    let homeUIComposer: HomeUIComposer
    let workoutUIComposer: WorkoutUIComposer
    let addExerciseUIComposer: AddExerciseUIComposer
    let exerciseUIComposer: ExerciseUIComposer
    let historyUIComposer: HistoryUIComposer
    let createRoutineUIComposer: CreateRoutineUIComposer
    
    // new navigation
    let routineStore: RoutineStore
    @StateObject var homeNavigationFlow = HomeNavigationFlow()
    @StateObject var exerciseListNavigationFlow = ExerciseListNavigationFlow()
    @StateObject var historyNavigationFlow = HistoryNavigationFlow()
    
    
    
    init(routineStore: RoutineStore) {
        // Initialize ExercisesNavigationFlow with a weak reference to the composer
        
        self.exerciseUIComposer = ExerciseUIComposer(routineStore: routineStore)
        self.addExerciseUIComposer = AddExerciseUIComposer(
            routineStore: routineStore,
            exerciseUIComposer: exerciseUIComposer
        )

        self.createRoutineUIComposer = CreateRoutineUIComposer(
            routineStore: routineStore,
            addExerciseUIComposer: addExerciseUIComposer
        )
        
        self.workoutUIComposer = WorkoutUIComposer(
            routineStore: routineStore,
            createRoutineUIComposer: createRoutineUIComposer,
            addExerciseUIComposer: addExerciseUIComposer,
            exerciseUIComposer: exerciseUIComposer
        )
        
//        self.homeUIComposer = HomeUIComposer(
//            routineStore: routineStore,
//            workoutUIComposer: workoutUIComposer,
//            createRoutineUIComposer: createRoutineUIComposer,
//            addExerciseUIComposer: addExerciseUIComposer
//        )

        self.historyUIComposer = HistoryUIComposer(routineStore: routineStore)
        
        // new navigation
        self.routineStore = routineStore
    }
    
    
    var body: some View {
        TabView {
//            homeUIComposer.makeHomeViewWithNavigation()
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
                    let viewModel = WorkoutViewModel(
                        routineStore: routineStore,
                        goToCreateRoutineView: { _ in },
                        dismiss: { }
                    )
                    
                    WorkoutView(viewModel: viewModel, goToAddExercise: { })
                    
                case .createRoutine:
                    let viewModel = CreateRoutineViewModel(routineStore: routineStore, dismiss: { })
                    CreateRoutineView(viewModel: viewModel, goToAddExerciseView: { })
                    
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
//    goToCreateRoutine: goToCreateRoutine,
//    goToRoutineDetail: goToRoutineDetail,
//    goToWorkoutWithNoRoutine: goToWorkoutWithNoRoutine)
    
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
