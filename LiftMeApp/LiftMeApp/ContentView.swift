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
    let routineRepository: LocalRoutineRepository
    
    
    init() {
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        self.routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        self.routineRepository = LocalRoutineRepository(routineStore: routineStore)
    }

    var body: some View {
        RoutineListView(viewModel: RoutineViewModel(routineRepository: routineRepository))
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
