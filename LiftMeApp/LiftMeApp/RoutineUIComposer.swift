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
    
    let navigationViewModel = RoutineNavigationViewModel()
    let routineRepository: RoutineRepository
    
    init(routineRepository: RoutineRepository) {
        
        self.routineRepository = routineRepository
    }
    
    
    convenience init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        let routineRepository: RoutineRepository = DispatchQueueMainDecorator(decoratee: LocalRoutineRepository(routineStore: routineStore))
        self.init(routineRepository: routineRepository)
    }
    
    
    func makeRoutineListWithStackNavigation() -> StackNavigationView<RoutineListView, RoutineNavigationViewModel> {
        
        return StackNavigationView(stackNavigationViewModel: navigationViewModel, content: makeRoutineList())
    }
    
    
    func makeRoutineList() -> RoutineListView {
        
        let viewModel = RoutineViewModel(routineRepository: routineRepository)
        
        return RoutineListView(viewModel: viewModel) {
            self.navigationViewModel.path.append(.createRoutine)
        }
    }

    
    func makeCreateRoutine() -> CreateRoutineView {

        return CreateRoutineView(routineRepository: routineRepository)
    }
}

