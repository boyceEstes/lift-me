//
//  ContentView.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 10/25/22.
//

import SwiftUI
import CoreData
import LiftMeRoutinesiOS
import RoutineRepository

struct ContentView: View {
    
    let routineStore: CoreDataRoutineStore
    let routineRepository: RoutineRepository
    
    
    init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        self.routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        
        let routineRepositoryMainQueue = DispatchQueueMainDecorator(decoratee: LocalRoutineRepository(routineStore: routineStore))
        
        self.routineRepository = routineRepositoryMainQueue
    }

    var body: some View {
        RoutineListView(viewModel: RoutineViewModel(routineRepository: routineRepository))
    }
}


class DispatchQueueMainDecorator: RoutineRepository {
    
    let decoratee: RoutineRepository
    
    init(decoratee: RoutineRepository) {
        self.decoratee = decoratee
    }
    
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {

        decoratee.save(routine: routine) { [weak self] error in
            self?.guaranteeMainThread {
                completion(error)
            }
        }
    }
    
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        
        decoratee.loadAllRoutines { [weak self] result in
            self?.guaranteeMainThread {
                completion(result)
            }
        }
    }
    
    
    private func guaranteeMainThread(_ work: @escaping () -> Void) {
        
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}

class RoutineRepositoryPreview: RoutineRepository {
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {
        completion(nil)
    }
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        completion(.success([]))
    }
}
