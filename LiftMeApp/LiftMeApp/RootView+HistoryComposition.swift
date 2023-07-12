//
//  RootView+HistoryComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS



extension RootView {
    
    @ViewBuilder
    func makeHistoryView() -> some View {
        
        HistoryView(
            routineStore: routineStore,
            goToRoutineRecordDetailView: goToRoutineRecordDetail
        )
    }
}
