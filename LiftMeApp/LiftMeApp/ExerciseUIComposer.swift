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


class ExerciseUIComposer {
    
    let routineStore: RoutineStore
    
    lazy var navigationFlow: ExerciseNavigationFlow = { [unowned self] in
        
        return ExerciseNavigationFlow(exerciseUIComposer: self)
    }()
    
    
    init(routineStore: RoutineStore) {

        self.routineStore = routineStore
    }
    
    
    func makeExercisesViewWithStackNavigation() -> StackNavigationView<ExercisesView, ExerciseNavigationFlow> {
        
        let exerciseListView = makeExercisesView()
        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: exerciseListView)
    }
    
    
    func makeExercisesView() -> ExercisesView {
        
        let viewModel = ExercisesViewModel(routineStore: routineStore) { exercise in
            self.navigationFlow.path.append(.exerciseDetailView(exercise: exercise))
        }
        return ExercisesView(viewModel: viewModel)
    }
    
    
    func makeExerciseDetailViewWithStackNavigation(exercise: Exercise) -> StackNavigationView<ExerciseDetailView, ExerciseNavigationFlow> {
        
        let exerciseDetailView = makeExerciseDetailView(exercise: exercise)
        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: exerciseDetailView)
    }
    
    
    func makeExerciseDetailView(exercise: Exercise) -> ExerciseDetailView {
        
        let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
        return ExerciseDetailView(viewModel: viewModel)
    }
}
