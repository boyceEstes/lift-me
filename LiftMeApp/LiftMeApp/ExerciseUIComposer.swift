////
////  ExerciseUIComposer.swift
////  LiftMeApp
////
////  Created by Boyce Estes on 2/12/23.
////
//
//import Foundation
//import RoutineRepository
//import NavigationFlow
//import LiftMeRoutinesiOS
//import SwiftUI
//
//
//// we want to initialize a navigation flow with a reference to ExerciseUIComposer
//// but we also want to have an reference to navigation flow in ExerciseUIComposer
//// If we ever had to deinit ExerciseUIComposer - we would then deinit navigation flow, and vice versa
//// We could solve this by making one of them weak? I'm attempting to make ExerciseNavigationFlow have
//// a weak reference to this composer
//
public class ExerciseUIComposer {
//
    let routineStore: RoutineStore
//
////    @ObservedObject var navigationFlow: ExerciseNavigationFlow
//
//    lazy var navigationFlow: ExerciseNavigationFlow = { [unowned self] in
//
//        return ExerciseNavigationFlow(exerciseUIComposer: self)
//    }()
//

    init(routineStore: RoutineStore) {

        self.routineStore = routineStore
    }

//
//    func makeExercisesViewWithSheetyStackNavigation() -> StackNavigationView<SheetyNavigationView<ExercisesView, ExerciseNavigationFlow>, ExerciseNavigationFlow> {
//
//        let exerciseListView = makeExercisesView()
//        let sheetyExerciseListView = SheetyNavigationView(
//            sheetyNavigationViewModel: navigationFlow,
//            content: exerciseListView,
//            onDismiss: { print("dismiss create exercise") })
//        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: sheetyExerciseListView)
//    }
//
//
//    func makeExercisesView() -> ExercisesView {
//
//        let viewModel = ExercisesViewModel(routineStore: routineStore) { exercise in
//            self.navigationFlow.path.append(.exerciseDetailView(exercise: exercise))
//        } goToCreateExerciseView: {
//
//            let destination: ExerciseNavigationFlow.SheetyIdentifier = .createExerciseView(
//                dismiss: { _ in
//
//                    self.navigationFlow.modallyDisplayedView = nil
//                }, uuid: UUID()
//            )
//
//            self.navigationFlow.modallyDisplayedView = destination
//        }
//        return ExercisesView(viewModel: viewModel)
//    }
//
//
//    func makeExerciseDetailViewWithStackNavigation(exercise: Exercise) -> StackNavigationView<ExerciseDetailView, ExerciseNavigationFlow> {
//
//        let exerciseDetailView = makeExerciseDetailView(exercise: exercise)
//        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: exerciseDetailView)
//    }
//
//
//    func makeExerciseDetailView(exercise: Exercise) -> ExerciseDetailView {
//
//        let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
//        let view = ExerciseDetailView(viewModel: viewModel)
//
//        return view
//    }
//
//
//    func makeCreateExerciseViewWithStackNavigation(dismiss: @escaping (Exercise?) -> Void) -> StackNavigationView<CreateExerciseView, ExerciseNavigationFlow> {
//
//        let createExerciseView = makeCreateExerciseView(dismiss: dismiss)
//        return StackNavigationView(stackNavigationViewModel: navigationFlow, content: createExerciseView)
//    }
//
//
//    func makeCreateExerciseView(dismiss: @escaping (Exercise?) -> Void) -> CreateExerciseView {
//
//        let viewModel = CreateExerciseViewModel(routineStore: routineStore, dismiss: dismiss)
//        return CreateExerciseView(viewModel: viewModel)
//    }
}
import RoutineRepository
import LiftMeRoutinesiOS

class ExerciseListUIComposer {
    
    static func makeExerciseList(
        routineStore: RoutineStore,
        goToCreateExercise: @escaping () -> Void,
        goToExerciseDetail: @escaping (Exercise) -> Void
    ) -> ExercisesView {
        
        let viewModel = ExercisesViewModel(
            routineStore: routineStore,
            goToExerciseDetailView: goToExerciseDetail,
            goToCreateExerciseView: goToCreateExercise
        )
        
        return ExercisesView(viewModel: viewModel)
    }
}
