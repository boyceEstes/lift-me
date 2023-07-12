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
    @State private var routineDetailNavigationFlowDisplayedSheet: RoutineDetailNavigationFlow.SheetyIdentifier?
    // Workout
    @State private var workoutNavigationFlowDisplayedSheet: WorkoutNavigationFlow.SheetyIdentifier?
    // CreateRoutine
    @State private var createRoutineNavigationFlowPath = [CreateRoutineNavigationFlow.StackIdentifier]()
    @State private var createRoutineNavigationFlowDisplayedSheet: CreateRoutineNavigationFlow.SheetyIdentifier?
    // Add Exercise
    @State private var addExerciseNavigationFlowDisplayedSheet: AddExerciseNavigationFlow.SheetyIdentifier?
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

    
    // MARK: Routine Detail NavigationFlow
    
    // NOTE: This is going to be pushed from the HomeNavigationFlow path. If it ever needs it own modal, give it its
    // own navigation stack
    @ViewBuilder
    func routineDetailViewWithSheetNavigation(
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
        homeNavigationFlowPath.append(.exerciseDetail(exercise: exercise))
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
        
        NavigationStack(path: $createRoutineNavigationFlowPath) {
            createRoutineViewWithSheetNavigation(
                routineRecord: routineRecord,
                superDismiss: superDismiss
            )
            .navigationDestination(for: CreateRoutineNavigationFlow.StackIdentifier.self) { identifier in
                switch identifier {
                case let .exerciseDetail(exercise):
                    exerciseDetailView(exercise: exercise)
                }
            }
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
            }
        }
    }
    
    
    func goToAddExerciseFromCreateRoutine(addExerciseCompletion: @escaping AddExercisesCompletion) {
        createRoutineNavigationFlowDisplayedSheet = .addExercise(addExercisesCompletion: addExerciseCompletion)
    }
    
    
    func goToExerciseDetailFromCreateRoutine(exercise: Exercise) {
        createRoutineNavigationFlowPath.append(.exerciseDetail(exercise))
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
