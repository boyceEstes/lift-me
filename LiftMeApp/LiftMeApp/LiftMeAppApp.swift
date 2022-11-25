//
//  LiftMeAppApp.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 10/25/22.
//

import SwiftUI
import RoutineRepository
import CoreData

@main
struct LiftMeAppApp: App {
    
    let routineRepository: RoutineRepository
    
    init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        self.routineRepository = DispatchQueueMainDecorator(decoratee: LocalRoutineRepository(routineStore: routineStore))
    }
    
    var body: some Scene {
        WindowGroup {
            RoutineUIComposer.makeRoutineListWithStackNavigation(routineRepository: routineRepository)
        }
    }
}


extension DispatchQueueMainDecorator: RoutineRepository where T == RoutineRepository {
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {
        
        decoratee.save(routine: routine) { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }
    }
    
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        
        decoratee.loadAllRoutines { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

