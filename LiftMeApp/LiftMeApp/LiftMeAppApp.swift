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
    
    // TODO: Is there a way to prevent this from being initialized as an instance (Or limit to one instance) while still being testable
    var body: some Scene {
        WindowGroup {
            RoutineUIComposer().makeRoutineListWithStackNavigation()
        }
    }
}

