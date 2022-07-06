//
//  ContentView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 6/30/22.
//

import SwiftUI


struct ContentView: View {
    
    let exercises = Exercise.mocks
    @State private var searchText = ""

    var body: some View {
            
        NavigationView {
            List(exercises) { exercise in
                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    ExerciseRow(exercise: exercise)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Exercise List")
        }
    }
}


struct ExerciseRow: View {
    
    let exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name)
                Text(exercise.lastDoneDateString)
                    .font(.caption)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
