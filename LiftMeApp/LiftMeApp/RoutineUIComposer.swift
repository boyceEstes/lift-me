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
public class RoutineUIComposer {
    
    let routineStore: RoutineStore
    
    lazy var navigationFlow: RoutineNavigationFlow = { [unowned self] in
        return RoutineNavigationFlow(routineUIComposer: self)
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
    
    
    func makeRoutineListWithSheetyNavigation() -> SheetyNavigationView<RoutineListView, RoutineNavigationFlow> {
        
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

