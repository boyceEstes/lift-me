//
//  HistoryNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository


class HistoryNavigationFlow: NewStackNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    
    // MARK: Stack Destinations
    enum StackIdentifier: Hashable {

        case routineRecordDetail(RoutineRecord)
        
        
        static func == (lhs: HistoryNavigationFlow.StackIdentifier, rhs: HistoryNavigationFlow.StackIdentifier) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .routineRecordDetail(routineRecord):
                hasher.combine("routineRecordDetail-\(routineRecord.id)")
            }
        }
    }
}
