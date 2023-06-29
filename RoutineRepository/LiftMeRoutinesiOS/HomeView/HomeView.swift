//
//  HomeView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI


public struct HomeView: View {
    
    let routineListView: RoutineListView
    let goToWorkoutViewWithNoRoutine: () -> Void
    
    public init(routineListView: RoutineListView, goToWorkoutViewWithNoRoutine: @escaping () -> Void) {
        
        self.routineListView = routineListView
        self.goToWorkoutViewWithNoRoutine = goToWorkoutViewWithNoRoutine
    }
    
    
    public var body: some View {
        
        VStack(spacing: 20) {
            Button {
                goToWorkoutViewWithNoRoutine()
            } label: {
                Text("Start Custom Routine")
            }
            .buttonStyle(LongHighKeyButtonStyle())
            .padding(.horizontal)
            
            routineListView
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle("Home")
//        .basicNavigationBar(title: "Home")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(
                routineListView: RoutineListView(
                    viewModel: RoutineListViewModel(
                        routineStore: RoutineStorePreview(),
                        goToCreateRoutine: { },
                        goToRoutineDetail: { _ in }
                    )
                ), goToWorkoutViewWithNoRoutine: { }
            )
        }
    }
}
