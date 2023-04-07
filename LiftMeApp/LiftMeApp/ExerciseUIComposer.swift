//
//  ExerciseUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import RoutineRepository
import NavigationFlow
import LiftMeRoutinesiOS
import SwiftUI


// we want to initialize a navigation flow with a reference to ExerciseUIComposer
// but we also want to have an reference to navigation flow in ExerciseUIComposer
// If we ever had to deinit ExerciseUIComposer - we would then deinit navigation flow, and vice versa
// We could solve this by making one of them weak? I'm attempting to make ExerciseNavigationFlow have
// a weak reference to this composer

class ExerciseUIComposer {
    
    let routineStore: RoutineStore
    
//    @ObservedObject var navigationFlow: ExerciseNavigationFlow
    
    lazy var navigationFlow: ExerciseNavigationFlow = { [unowned self] in

        return ExerciseNavigationFlow(exerciseUIComposer: self)
    }()

    
    init(routineStore: RoutineStore) {

        self.routineStore = routineStore
    }
    
    
    func makeExercisesViewWithSheetyStackNavigation() -> StackNavigationView<SheetyNavigationView<ExercisesView, ExerciseNavigationFlow>, ExerciseNavigationFlow> {
        
        let exerciseListView = makeExercisesView()
        let sheetyExerciseListView = SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: exerciseListView,
            onDismiss: { print("dismiss create exercise") })
        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: sheetyExerciseListView)
    }
    
    
    func makeExercisesView() -> ExercisesView {
        
        let viewModel = ExercisesViewModel(routineStore: routineStore) { exercise in
            self.navigationFlow.path.append(.exerciseDetailView(exercise: exercise))
        } goToCreateExerciseView: {
            self.navigationFlow.modallyDisplayedView = .createExerciseView
        }
        return ExercisesView(viewModel: viewModel)
    }
    
    
    func makeExerciseDetailViewWithStackNavigation(exercise: Exercise) -> StackNavigationView<ExerciseDetailView, ExerciseNavigationFlow> {
        
        let exerciseDetailView = makeExerciseDetailView(exercise: exercise)
        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: exerciseDetailView)
    }
    
    
    func makeExerciseDetailView(exercise: Exercise) -> ExerciseDetailView {
        
        let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
        let view = ExerciseDetailView(viewModel: viewModel)

        return view
    }
    
    
    func makeCreateExerciseViewWithStackNavigation() -> StackNavigationView<CreateExerciseView, ExerciseNavigationFlow> {
        
        StackNavigationView(stackNavigationViewModel: navigationFlow, content: makeCreateExerciseView())
    }
    
    
    func makeCreateExerciseView() -> CreateExerciseView {
        
        let viewModel = CreateExerciseViewModel()
        return CreateExerciseView(viewModel: viewModel)
    }
}
//
//struct SomeView: View {
//
//    let viewModel: SomeViewModel
//
//    init(exercise: Exercise) {
//        viewModel = SomeViewModel(exercise: exercise)
//        print("init for View")
//    }
//
//    var body: some View {
//        Text("\(viewModel.exercise.name) 4")
//    }
//}
//
//class SomeViewModel: ObservableObject {
//
//    @Published var exercise: Exercise
//
//    init(exercise: Exercise) {
//        print("init")
//        self.exercise = exercise
//    }
//
//    deinit {
//        print("deinit")
//    }
//}
