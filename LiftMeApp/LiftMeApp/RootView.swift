//
//  RootView.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS

struct RootView: View {
    
    let homeUIComposer: HomeUIComposer
    let historyUIComposer: HistoryUIComposer
    
    
    init(routineStore: RoutineStore) {
        
        self.homeUIComposer = HomeUIComposer(routineStore: routineStore)
        self.historyUIComposer = HistoryUIComposer(routineStore: routineStore)
    }
    
    
    var body: some View {
        TabView {
            homeUIComposer.makeHomeViewWithSheetyNavigation()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            historyUIComposer.makeHistoryViewWithStackNavigation()
                .tabItem {
                    Label("History", systemImage: "book.closed")
                }
        }
    }
}


//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView(routineStore: RoutineStorePreview.self as! RoutineStore)
//    }
//}
