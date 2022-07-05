//
//  ContentView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 6/30/22.
//

import SwiftUI

struct Exercise: Identifiable {

    let id = UUID()
    let name: String
    let lastDoneDate: Date?
    let personalRecord: Int
    
    init(name: String) {
        self.name = name
        self.lastDoneDate = Bool.random() == true ? Date() : nil
        self.personalRecord = Int.random(in: 100..<300)
    }
    
    var lastDoneDateString: String {
        if let lastDoneDate = lastDoneDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let stringDate = formatter.string(from: lastDoneDate)
            return "Last completed: \(stringDate)"
        } else {
            return "No records found"
        }
    }
}

struct ContentView: View {
    
    let exercises = [Exercise(name: "Deadlift"), Exercise(name: "Bench Press"), Exercise(name: "Squat"), Exercise(name: "Tricep Extension")]
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationView {
            List(exercises) { exercise in
                ExerciseRow(exercise: exercise)
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
