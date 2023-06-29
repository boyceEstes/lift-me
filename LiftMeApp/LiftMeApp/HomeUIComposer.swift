//
//  RoutineUIComposer.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 11/3/22.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS
import NavigationFlow
import CoreData


// Warning: there should only be ONE usage of this implementation in the production app
// Not static or final so that it can be sublclassed for testing
public class HomeUIComposer {
    
    let routineStore: RoutineStore
    let createRoutineUIComposer: CreateRoutineUIComposer // I am passing this through because I only want one instance at the root that will be used
    let workoutUIComposer: WorkoutUIComposer
    let addExerciseUIComposer: AddExerciseUIComposer
    
    lazy var navigationFlow: HomeNavigationFlow = { [unowned self] in
        
        return HomeNavigationFlow(
            homeUIComposer: self,
            workoutUIComposer: workoutUIComposer,
            createRoutineUIComposer: createRoutineUIComposer,
            addExerciseUIComposer: addExerciseUIComposer
        )
    }()
    
    
    init(routineStore: RoutineStore,
         workoutUIComposer: WorkoutUIComposer,
         createRoutineUIComposer: CreateRoutineUIComposer,
         addExerciseUIComposer: AddExerciseUIComposer
    ) {
        
        self.routineStore = routineStore
        self.workoutUIComposer = workoutUIComposer
        self.createRoutineUIComposer = createRoutineUIComposer
        self.addExerciseUIComposer = addExerciseUIComposer
    }
    
    // MARK: - Home View
    typealias HomeViewWithNavigation = StackNavigationView<SheetyNavigationView<HomeView, HomeNavigationFlow>, HomeNavigationFlow>
    
    func makeHomeViewWithNavigation() -> HomeViewWithNavigation {
        
        let homeView = makeHomeView()
        let sheetyNavigationView = SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: homeView
        )
        return StackNavigationView(
            stackNavigationViewModel: navigationFlow,
            content: sheetyNavigationView
        )
    }
    
    
    func makeHomeView() -> HomeView {
        
        return HomeView(
            routineListView: makeRoutineListView().view,
            goToWorkoutViewWithNoRoutine: {
                self.navigationFlow.modallyDisplayedView = .workout(nil)
            }
        )
    }

    
    func makeRoutineListWithSheetyNavigation() -> SheetyNavigationView<RoutineListView, HomeNavigationFlow> {
        
        let (routineListView, _) = makeRoutineListView()
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: routineListView,
            onDismiss: nil
        )
    }
    
    
    func makeRoutineListView() -> (view: RoutineListView, viewModel: RoutineListViewModel) {
        
        let viewModel = RoutineListViewModel(
            routineStore: routineStore,
            goToCreateRoutine: {
                self.navigationFlow.modallyDisplayedView = .createRoutine
            },
            goToRoutineDetail: { routine in
                self.navigationFlow.path.append(.routineDetail(routine: routine))
            }
        )
        
        return (RoutineListView(viewModel: viewModel), viewModel)
    }
    
    
    
    func makeRoutineDetailView(routine: Routine) -> RoutineDetailView {
        
        let viewModel = RoutineDetailViewModel(routine: routine)
        
        return RoutineDetailView(
            viewModel: viewModel,
            goToAddExercise: {
                self.navigationFlow.modallyDisplayedView = .addExercise(
                    addExerciseCompletion: viewModel.addExercisesCompletion,
                    dismiss: { [weak self] in
                        self?.navigationFlow.dismiss()
                    }
                )
            }
        )
    }
}

