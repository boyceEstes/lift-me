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
    
    lazy var navigationFlow: HomeNavigationFlow = { [unowned self] in
        return HomeNavigationFlow(
            homeUIComposer: self,
            workoutUIComposer: WorkoutUIComposer(routineStore: routineStore)
        )
    }()
    
    
    init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }


    func makeHomeViewWithSheetyNavigation() -> SheetyNavigationView<HomeView, HomeNavigationFlow> {

        let homeView = makeHomeView()
        
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: homeView
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
        
        let (routineListView, routineListViewModel) = makeRoutineListView()
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: routineListView,
            onDismiss: {
                routineListViewModel.loadRoutines()
            }
        )
    }
    
    
    func makeRoutineListView() -> (view: RoutineListView, viewModel: RoutineListViewModel) {
        
        let viewModel = RoutineListViewModel(
            routineStore: routineStore,
            goToCreateRoutine: {
                self.navigationFlow.modallyDisplayedView = .createRoutine
            },
            goToWorkoutView: { routine in
                self.navigationFlow.modallyDisplayedView = .workout(routine)
            }
        )
        
        return (RoutineListView(viewModel: viewModel), viewModel)
    }
    
    
    func makeCreateRoutineView() -> CreateRoutineView {

        let viewModel = CreateRoutineViewModel(
            routineStore: routineStore,
            dismiss: { [weak self] in
                print("my dismiss action")
                self?.navigationFlow.dismiss()
            }
        )
        
        return CreateRoutineView(viewModel: viewModel)
    }
}

