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
    
    let routineRepository: RoutineRepository
    
    init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        self.routineRepository = DispatchQueueMainDecorator(decoratee: LocalRoutineRepository(routineStore: routineStore))
    }

    var body: some View {
        RoutineListUIComposer.routineListComposedWith(routineRepository: routineRepository)
    }
}


public final class RoutineListUIComposer {
    
    private init() {}
    
    
    public static func routineListComposedWith(routineRepository: RoutineRepository) -> RoutineListView {
        
        let viewModel = RoutineViewModel(routineRepository: routineRepository)
        return RoutineListView(viewModel: viewModel)
    }
}


class DispatchQueueMainDecorator<T> {
    
    let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(_ work: @escaping () -> Void) {
        guaranteeMainThread {
            work()
        }
    }
    
    // TODO: Make this check for main queue instead of main thread
    private func guaranteeMainThread(_ work: @escaping () -> Void) {
        
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
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
