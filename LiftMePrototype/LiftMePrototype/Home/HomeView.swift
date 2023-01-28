//
//  HomeView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI


struct HomeView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    CustomRoutineContainerView()
                        .padding(.top)
                    
                    VStack {
                        RoutineListView3()
                    }
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(8)
                    Spacer()
                }
            }
            .navigationTitle(Text("Home"))
            .toolbarColorScheme(.dark, for: .automatic)
            .toolbarBackground(Color(uiColor: .universeRedLight), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}


struct CustomRoutineContainerView: View {
    
    var body: some View {
        
        NavigationLink {
            WorkoutView()
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
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
