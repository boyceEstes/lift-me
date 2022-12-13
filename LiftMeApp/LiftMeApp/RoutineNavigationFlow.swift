//
//  RoutineNavigationViewModel.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 11/24/22.
//

import SwiftUI
import NavigationFlow
import LiftMeRoutinesiOS
import RoutineRepository


class RoutineNavigationFlow: SheetyNavigationFlow {
    
    enum SheetyIdentifier: Identifiable {
        
        var id: Int { self.hashValue }

        case createRoutine
    }
    
    
    @Published var modallyDisplayedView: SheetyIdentifier? = nil {
        willSet {
            print("current: \(modallyDisplayedView), new: \(newValue)")
        }
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        switch identifier {
        case .createRoutine:
            print("Create routine from navigation flow")
            return RoutineUIComposer.shared.makeCreateRoutineView()
        }
    }
}
