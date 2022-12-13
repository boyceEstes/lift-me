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
    
    static let shared = RoutineUIComposer()
    
    
    let navigationFlow = RoutineNavigationFlow()
    let routineRepository: RoutineRepository
    
    
    private init(routineRepository: RoutineRepository) {
        
        self.routineRepository = routineRepository
    }
    
    
    convenience init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        let routineRepository: RoutineRepository = DispatchQueueMainDecorator(decoratee: LocalRoutineRepository(routineStore: routineStore))
        self.init(routineRepository: routineRepository)
    }
    
    
    func makeRoutineListWithSheetyNavigation() -> SheetyNavigationView<RoutineListView, RoutineNavigationFlow> {
        
        return SheetyNavigationView(sheetyNavigationViewModel: navigationFlow, content: makeRoutineListView())
    }
    
    
    func makeRoutineListView() -> RoutineListView {
        
        let viewModel = RoutineListViewModel(routineRepository: routineRepository) {
            self.navigationFlow.modallyDisplayedView = .createRoutine
        }
        
        return RoutineListView(viewModel: viewModel)
    }
    
    
    func makeCreateRoutineView() -> CreateRoutineView {

        let viewModel = CreateRoutineViewModel(
            routineRepository: routineRepository,
            dismissAction: { [weak self] in
                print("my dismiss action")
                self?.navigationFlow.dismiss()
            }
        )
        
        return CreateRoutineView(viewModel: viewModel)
    }
}

