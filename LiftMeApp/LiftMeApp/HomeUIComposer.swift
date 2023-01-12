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
        return HomeNavigationFlow(homeUIComposer: self)
    }()
    
    
    init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    convenience init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        let mainQueueRoutineStore = DispatchQueueMainDecorator<RoutineStore>(decoratee: routineStore)
        self.init(routineStore: mainQueueRoutineStore)
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
            goToWorkout: {
                self.navigationFlow.modallyDisplayedView = .workout
            }
        )
    }
    
    // I'm going to need a new NavigationFlow for the workout since I want it to stay up whne it presents its own sheet
    func makeWorkoutViewWithSheetyNavigation() -> SheetyNavigationView<WorkoutView, HomeNavigationFlow> {
        
        let workoutView = makeWorkoutView()
        
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: workoutView
        )
    }
    
    
    func makeWorkoutView() -> WorkoutView {
        
        return WorkoutView(
            goToAddExercise: {
                self.navigationFlow.modallyDisplayedView = .addExercise
            }
        )
    }
    
    
    func makeAddExerciseView() -> AddExerciseView {
        
        return AddExerciseView()
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
    
    
    func makeRoutineListView() -> (RoutineListView, RoutineListViewModel) {
        
        let viewModel = RoutineListViewModel(
            routineStore: routineStore,
            goToCreateRoutine: {
                self.navigationFlow.modallyDisplayedView = .createRoutine
            }
        )
        
        return (RoutineListView(viewModel: viewModel), viewModel)
    }
    
    
    func makeCreateRoutineView() -> CreateRoutineView {

        let viewModel = CreateRoutineViewModel(
            routineStore: routineStore,
            dismissAction: { [weak self] in
                print("my dismiss action")
                self?.navigationFlow.dismiss()
            }
        )
        
        return CreateRoutineView(viewModel: viewModel)
    }
}

