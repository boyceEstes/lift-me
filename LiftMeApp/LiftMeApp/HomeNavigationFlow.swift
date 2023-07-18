//
//  RoutineNavigationViewModel.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 11/24/22.
//

import SwiftUI
import LiftMeRoutinesiOS
import RoutineRepository


class HomeNavigationFlow: NewStackNavigationFlow, NewSheetyNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    @Published var displayedSheet: SheetyIdentifier?
    
    
    // MARK: Stack Destinations
    enum StackIdentifier: Hashable {
        
        case routineDetail(routine: Routine)
        case exerciseDetail(exercise: Exercise)
    }
    
    
    // MARK: - Sheety Destinations
    enum SheetyIdentifier: Identifiable, Hashable {
        
        var id: Int { self.hashValue }

        case createRoutine
        case workout(Routine?)
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case let .workout(routine):
                hasher.combine("workout-\(routine?.id.uuidString ?? "-1")")
            case .createRoutine:
                hasher.combine("createRoutine")
            }
        }
        
        
        static func == (lhs: HomeNavigationFlow.SheetyIdentifier, rhs: HomeNavigationFlow.SheetyIdentifier) -> Bool {
            
            switch (lhs, rhs) {
            case (.createRoutine, .createRoutine): return true
            case (.workout, .workout): return true
            default: return false
            }
        }
    }
}
