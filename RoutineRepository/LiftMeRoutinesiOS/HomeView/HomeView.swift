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
        
        VStack {
            Button {
                goToWorkoutViewWithNoRoutine()
            } label: {
                Text("Custom Routine")
            }
            .frame(maxWidth: .infinity, maxHeight: 35)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: .white))
            .background(
                RoundedRectangle(cornerRadius: 8)
                .fill(Color.universeRed)
            )
            .padding(.horizontal)
            
            routineListView
            
            Spacer()
        }
        .padding(.top)
        .basicNavigationBar(title: "Home")
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
                        goToWorkoutView: { _ in }
                    )
                ), goToWorkoutViewWithNoRoutine: { }
            )
        }
    }
}
