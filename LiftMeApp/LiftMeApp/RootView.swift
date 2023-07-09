//
//  RootView.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


//struct SecondHomeView: View {
//
//    let goToWorkout: () -> Void
////    let goToCreateRoutine: () -> Void
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Button("Go to Workout") {
//                goToWorkout()
//            }
//
////            Button("Go to Create Routine") {
////                goToCreateRoutine()
////            }
//        }
//    }
//}
//
//
//struct SecondWorkoutView: View {
//
//    let goToAddExercise: () -> Void
//    //    let goToCreateRoutine: (RoutineRecord) -> Void
//
//    var body: some View {
//        VStack {
//            Button("Go to Add Exercise") {
//                goToAddExercise()
//            }
//            //
//            //            Button("Go to Create Routine") {
//            //                goToCreateRoutine(RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: []))
//            //            }
//        }
//    }
//}
//
//
//class SecondHomeNavigationFlow: NewSheetyNavigationFlow {
//
//    @Published var displayedSheet: SheetyIdentifier?
//
//    enum SheetyIdentifier: String, Identifiable {
//        case workout
//
//        var id: String { self.rawValue }
//    }
//}
//
//class SecondWorkoutNavigationFlow: NewSheetyNavigationFlow {
//
//    @Published var displayedSheet: SheetyIdentifier?
//
//    enum SheetyIdentifier: String, Identifiable {
//        case addExercise
//
//        var id: String { self.rawValue }
//    }
//}
//
//
//struct SecondRootView: View {
//
//    @StateObject private var homeNavFlow = SecondHomeNavigationFlow()
//    @StateObject private var workoutNavFlow = SecondWorkoutNavigationFlow()
//
//    var body: some View {
//
//        SecondHomeView {
//            homeNavFlow.displayedSheet = .workout
//        }
//        .sheet(item: $homeNavFlow.displayedSheet) { identifier in
//            switch identifier {
//            case .workout:
//                SecondWorkoutView {
//                    workoutNavFlow.displayedSheet = .addExercise
//                }
//                .sheet(item: $workoutNavFlow.displayedSheet) { identifier in
//                    switch identifier {
//                    case .addExercise:
//                        Text("Add Exercise")
//                    }
//                }
//            }
//        }
//    }
//}


struct RootView: View {
    
    // new navigation
    let routineStore: RoutineStore
    @StateObject var homeNavigationFlow = HomeNavigationFlow()
    @State private var workoutNavigationFlowDisplayedSheet: WorkoutNavigationFlow.SheetyIdentifier?
    @State private var createRoutineNavigationFlowDisplayedSheet: CreateRoutineNavigationFlow.SheetyIdentifier?
//    @StateObject var workoutNavigationFlow = WorkoutNavigationFlow()
    @StateObject var addExerciseNavigationFlow = AddExerciseNavigationFlow()
    @StateObject var exerciseListNavigationFlow = ExerciseListNavigationFlow()
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
            .onChange(of: homeNavigationFlow.displayedSheet) { newValue in
                print("home flow: \(String(describing: newValue))")
            }
//            .onChange(of: workoutNavigationFlow.displayedSheet) { newValue in
//                print("workout flow: \(String(describing: newValue))")
//            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

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
        .sheet(item: $workoutNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
            case let .addExercise(addExercisesCompletion):
                addExerciseViewWithNavigation(addExercisesCompletion: addExercisesCompletion)

            case let .createRoutine(routineRecord):
                NavigationStack {
                    CreateRoutineUIComposer.makeCreateRoutineView(
                        routineStore: routineStore,
                        routineRecord: routineRecord,
                        superDismiss: superDismissWorkoutSheetAndHomeSheet,
                        goToAddExercise: { }
                    )
                }
            }
        }
    }
    
    
    func superDismissWorkoutSheetAndHomeSheet() {
        
        workoutNavigationFlowDisplayedSheet = nil
        homeNavigationFlow.displayedSheet = nil
    }
    
    
    func goToCreateRoutine(with routineRecord: RoutineRecord) {
        workoutNavigationFlowDisplayedSheet = .createRoutine(routineRecord: routineRecord)
    }
    
    
    func goToAddExercise(addExercisesCompletion: @escaping AddExercisesCompletion) {
        workoutNavigationFlowDisplayedSheet = .addExercise(addExercisesCompletion: addExercisesCompletion)
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
        .sheet(item: $addExerciseNavigationFlow.displayedSheet) { identifier in
            switch identifier {
            case let .createExercise(createExerciseCompletion, _):
                let viewModel = CreateExerciseViewModel(routineStore: routineStore, dismiss: createExerciseCompletion)
                
                NavigationStack {
                    CreateExerciseView(viewModel: viewModel)
                }
            }
        }
    }
    
    
    func goToCreateExerciseFromAddExercise(createExerciseCompletion: @escaping (Exercise?) -> Void) {
        addExerciseNavigationFlow.displayedSheet = .createExercise(createExerciseCompletion: createExerciseCompletion, UUID())
    }
    
    
    // MARK: Exercise List Navigation Flow
    func goToExerciseDetail(exercise: Exercise) {
        exerciseListNavigationFlow.push(.exerciseDetail(exercise))
    }
    
    
    func goToCreateExercise() {
        exerciseListNavigationFlow.displayedSheet = .createExercise
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
