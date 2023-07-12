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
    @State private var homeNavigationFlowDisplayedSheet: HomeNavigationFlow.SheetyIdentifier?
    @State private var homeNavigationFlowPath = [HomeNavigationFlow.StackIdentifier]()
    // RoutineDetail
    @State private var routineDetailNavigationFlowDisplayedSheet: RoutineDetailNavigationFlow.SheetyIdentifier?
    // Workout
    @State private var workoutNavigationFlowDisplayedSheet: WorkoutNavigationFlow.SheetyIdentifier?
    // CreateRoutine
    @State private var createRoutineNavigationFlowDisplayedSheet: CreateRoutineNavigationFlow.SheetyIdentifier?
    // Add Exercise
    @State private var addExerciseNavigationFlowDisplayedSheet: AddExerciseNavigationFlow.SheetyIdentifier?
    // Exercise Tab
    @State private var exerciseListNavigationFlowPath = [ExerciseListNavigationFlow.StackIdentifier]()
    @State private var exerciseListNavigationFlowDisplayedSheet: ExerciseListNavigationFlow.SheetyIdentifier?
    // History Tab
    @State private var historyNavigationFlowPath = [HistoryNavigationFlow.StackIdentifier]()
    
    
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
            .flowNavigationDestination(flowPath: $homeNavigationFlowPath) { identifier in
                switch identifier {
                case let .routineDetail(routine: routine):
                    routineDetailViewWithNavigation(routine: routine)
                }
            }
            .sheet(item: $homeNavigationFlowDisplayedSheet) { identifier in
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

            ExerciseListUIComposer.makeExerciseList(
                routineStore: routineStore,
                goToCreateExercise: goToCreateExercise,
                goToExerciseDetail: goToExerciseDetail
            )
            .flowNavigationDestination(flowPath: $exerciseListNavigationFlowPath) { identifier in
                switch identifier {
                case let .exerciseDetail(exercise):
                    exerciseDetailView(exercise: exercise)
                }
            }
            .sheet(item: $exerciseListNavigationFlowDisplayedSheet) { identifier in
                switch identifier {
                case .createExercise:
                    // We do not need any completion logic for the exercise list screen because it is going to
                    // update with a exercises data source.
                    createExerciseViewWithNavigation(createExerciseCompletion: { _ in })
                }
            }
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }


            HistoryUIComposer.makeHistoryView(
                routineStore: routineStore,
                goToRoutineRecordDetail: goToRoutineRecordDetail
            )
            .flowNavigationDestination(flowPath: $historyNavigationFlowPath) { identifier in
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
        homeNavigationFlowDisplayedSheet = .createRoutine
    }
    
    
    func goToRoutineDetail(routine: Routine) {
        homeNavigationFlowPath.append(.routineDetail(routine: routine))
    }
    
    
    func goToWorkoutWithNoRoutine() {
        homeNavigationFlowDisplayedSheet = .workout(nil)
    }
    
    
    // MARK: Routine Detail NavigationFlow
    @ViewBuilder
    func routineDetailViewWithNavigation(
        routine: Routine
    ) -> some View {
        
        RoutineDetailView(
            routineStore: routineStore,
            routine: routine,
            goToAddExerciseFromRoutineDetail: goToAddExerciseFromRoutineDetail,
            goToWorkout: goToWorkoutFromRoutineDetail,
            goToExerciseDetail: goToExerciseDetailFromRoutineDetail
        )
        .sheet(item: $routineDetailNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
                
            case let .addExercise(addExerciseCompletion):
                addExerciseViewWithNavigation(addExercisesCompletion: addExerciseCompletion)
                
            case let .exerciseDetail(exercise):
                exerciseDetailViewWithNavigation(exercise: exercise)
                
            case let .workout(routine):
                workoutViewWithNavigation(routine: routine)
            }
        }
    }
    
    
    func goToAddExerciseFromRoutineDetail(addExerciseCompletion: @escaping AddExercisesCompletion) {
        routineDetailNavigationFlowDisplayedSheet = .addExercise(addExerciseCompletion)
    }
    
    
    func goToWorkoutFromRoutineDetail(routine: Routine) {
        routineDetailNavigationFlowDisplayedSheet = .workout(routine)
    }
    
    
    func goToExerciseDetailFromRoutineDetail(exercise: Exercise) {
        print("This has been called to go to exercise detail, \(exercise), from routine detail")
        routineDetailNavigationFlowDisplayedSheet = .exerciseDetail(exercise)
    }
    

    // MARK: Workout Navigation Flow
    func workoutViewWithNavigation(routine: Routine?) -> some View {
        
        NavigationStack {
            WorkoutUIComposer.makeWorkoutView(
                routineStore: routineStore,
                routine: routine,
                goToCreateRoutine: goToCreateRoutine,
                goToAddExercise: goToAddExerciseFromWorkout
            )
        }
        .sheet(item: $workoutNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
            case let .addExercise(addExercisesCompletion):
                addExerciseViewWithNavigation(addExercisesCompletion: addExercisesCompletion)

            case let .createRoutine(routineRecord):
                createRoutineViewWithNavigation(
                    routineRecord: routineRecord,
                    superDismiss: superDismissWorkoutSheetAndHomeSheet
                )
            }
        }
    }
    
    
    func superDismissWorkoutSheetAndHomeSheet() {
        
        workoutNavigationFlowDisplayedSheet = nil
        homeNavigationFlowDisplayedSheet = nil
    }
    
    
    func goToCreateRoutine(with routineRecord: RoutineRecord) {
        workoutNavigationFlowDisplayedSheet = .createRoutine(routineRecord: routineRecord)
    }
    
    
    func goToAddExerciseFromWorkout(addExercisesCompletion: @escaping AddExercisesCompletion) {
        workoutNavigationFlowDisplayedSheet = .addExercise(addExercisesCompletion: addExercisesCompletion)
    }
    
    
    // MARK: Create Routine Flow
    func createRoutineViewWithNavigation(
        routineRecord: RoutineRecord?,
        superDismiss: (() -> Void)?
    ) -> some View {
        
        NavigationStack {
            createRoutineViewWithSheetNavigation(
                routineRecord: routineRecord,
                superDismiss: superDismiss
            )
        }
    }
    
    
    @ViewBuilder
    func createRoutineViewWithSheetNavigation(
        routineRecord: RoutineRecord?,
        superDismiss: (() -> Void)?
    ) -> some View {
        
        CreateRoutineView(
            routineStore: routineStore,
            routineRecord: routineRecord,
            superDismiss: superDismiss,
            goToAddExercise: goToAddExerciseFromCreateRoutine,
            goToExerciseDetail: goToExerciseDetailFromCreateRoutine
        )
        .sheet(item: $createRoutineNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
            case let .addExercise(addExercisesCompletion):
                addExerciseViewWithNavigation(addExercisesCompletion: addExercisesCompletion)
            case let .exerciseDetail(exercise):
                exerciseDetailViewWithNavigation(exercise: exercise)
            }
        }
    }
    
    
    func goToAddExerciseFromCreateRoutine(addExerciseCompletion: @escaping AddExercisesCompletion) {
        createRoutineNavigationFlowDisplayedSheet = .addExercise(addExercisesCompletion: addExerciseCompletion)
    }
    
    
    func goToExerciseDetailFromCreateRoutine(exercise: Exercise) {
        createRoutineNavigationFlowDisplayedSheet = .exerciseDetail(exercise)
    }
    
    
    // MARK: Add Exercise Flow
    func addExerciseViewWithNavigation(
        addExercisesCompletion: @escaping ([Exercise]) -> Void
    ) -> some View {
        
        NavigationStack {
            AddExerciseUIComposer.makeAddExerciseView(
                routineStore: routineStore,
                addExerciseCompletion: addExercisesCompletion,
                goToCreateExercise: goToCreateExerciseFromAddExercise
            )
        }
        .sheet(item: $addExerciseNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
            case let .createExercise(createExerciseCompletion):
                createExerciseViewWithNavigation(createExerciseCompletion: createExerciseCompletion)
            }
        }
    }
    
    
    
    // MARK: Create Exercise Navigation Flow
    func createExerciseViewWithNavigation(createExerciseCompletion: @escaping (Exercise) -> Void) -> some View {
        
        NavigationStack {
            CreateExerciseUIComposer.makeCreateExerciseView(
                routineStore: routineStore,
                createExerciseCompletion: createExerciseCompletion
            )
        }
    }
    
    
    func goToCreateExerciseFromAddExercise(createExerciseCompletion: @escaping (Exercise) -> Void) {
        addExerciseNavigationFlowDisplayedSheet = .createExercise(createExerciseCompletion: createExerciseCompletion)
    }
    
    
    // MARK: Exercise List Navigation Flow
//    @ViewBuilder
//    func exerciseListViewWithNavigation() -> some View {
//        
//    }
    
    
    func goToExerciseDetail(exercise: Exercise) {
        exerciseListNavigationFlowPath.append(.exerciseDetail(exercise))
    }
    
    
    func goToCreateExercise() {
        exerciseListNavigationFlowDisplayedSheet = .createExercise
    }
    
    
    // MARK: Exercise Detail View
    @ViewBuilder
    func exerciseDetailViewWithNavigation(exercise: Exercise) -> some View {
        
        NavigationStack {
            exerciseDetailView(exercise: exercise)
        }
    }
    
    
    @ViewBuilder
    func exerciseDetailView(exercise: Exercise) -> some View {
        
        let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
        ExerciseDetailView(viewModel: viewModel)
    }
    
    
    // MARK: History Navigation Flow
    func goToRoutineRecordDetail(routineRecord: RoutineRecord) {
        historyNavigationFlowPath.append(.routineRecordDetail(routineRecord))
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            routineStore: RoutineStorePreview()
        )
    }
}
