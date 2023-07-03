//
//  HistoryNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import NavigationFlow
import RoutineRepository



//class HistoryNavigationFlow: StackNavigationFlow {
//
//
//    enum StackIdentifier: Hashable {
//
//        case historyView
//        case routineRecordDetailView(routineRecord: RoutineRecord)
//    }
//
//    let historyUIComposer: HistoryUIComposer
//
//    @Published var path = [StackIdentifier]()
//
//    init(historyUIComposer: HistoryUIComposer) {
//
//        self.historyUIComposer = historyUIComposer
//    }
//
//
//    func pushToStack(_ identifier: StackIdentifier) -> some View {
//
//        Group {
//            switch identifier {
//            case .historyView:
//                historyUIComposer.makeHistoryView()
//
//            case let .routineRecordDetailView(routineRecord):
//                historyUIComposer.makeRoutineRecordDetailViewWithStackNavigation(routineRecord: routineRecord)
//            }
//        }
//    }
//}


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
