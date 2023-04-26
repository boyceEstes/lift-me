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
    
    let routineStore: RoutineStore
    
    init() {
        // Do calculations to get the routineStore here
        // pass it into the UIComposer which will create the HomeUIComposer  and othe stuff woith it
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("routine-store.sqlite")
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: localStoreURL, bundle: bundle)
        let mainQueueRoutineStore = DispatchQueueMainDecorator<RoutineStore>(decoratee: routineStore)
        self.routineStore = mainQueueRoutineStore
    }

    
    var body: some Scene {
        WindowGroup {
            RootView(routineStore: routineStore)
        }
    }
}
