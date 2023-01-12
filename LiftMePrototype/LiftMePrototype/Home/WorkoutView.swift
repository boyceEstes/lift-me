//
//  WorkoutView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI

struct WorkoutView: View {
    
    public let allExercises: [Exercise] = [
        Exercise(name: "Deadlift", tags: [.back]),
        Exercise(name: "Bench press", tags: [.chest])
//        Exercise(name: "Squat", tags: [.glutes, .quads, .hamstrings]),
//        Exercise(name: "Bicep curl", tags: [.bicep]),
//        Exercise(name: "Tricep extension", tags: [.tricep]),
//        Exercise(name: "Overhead tricep extension", tags: [.tricep]),
//        Exercise(name: "Leg press", tags: [.quads, .glutes]),
//        Exercise(name: "Bicep dumbbell press", tags: [.bicep]),
//        Exercise(name: "Single-leg press", tags: [.quads]),
//        Exercise(name: "Romanian deadlift", tags: [.back, .hamstrings]),
//        Exercise(name: "Single-leg Romanian deadlift", tags: [.hamstrings]),
//        Exercise(name: "Leg curl", tags: [.hamstrings]),
//        Exercise(name: "Lying leg curl", tags: [.hamstrings]),
//        Exercise(name: "Leg extension", tags: [.quads]),
//        Exercise(name: "Cable bicep curl", tags: [.bicep]),
//        Exercise(name: "Cable tricep extension", tags: [.tricep]),
//        Exercise(name: "Tricep extensions", tags: [.tricep]),
//        Exercise(name: "Tricep skullcrushers", tags: [.tricep]),
//        Exercise(name: "Chest fly", tags: [.chest])
    ]
    
    
    var body: some View {

            List {
                
                Section {
                    if allExercises.isEmpty {
                        Text("Try adding an exercise!")
                    } else {
                        ForEach(allExercises) { exercise in
                            Text(exercise.name)
                        }
                    }

                } header: {
                    HStack {
                        Text("Exercises")
                            .textCase(.uppercase)
                            .padding(.trailing, 6)
                        
                        NavigationLink {
                            ExerciseSelectionListView()
                        } label: {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus")
                            }
                        }
                        .buttonStyle(HighKeyButtonStyle())


                        Spacer()
                        EditButton()
                            .foregroundColor(.universeRed)
                    }
                    .font(.headline)
                }.textCase(nil)
            }
            
            
//
//            HStack {
//                Text("Exercises")
//                    .font(.title2)
//                    .fontWeight(.bold)
//
//                Spacer()
//
//                Button {
//                    print("help")
//                } label: {
//                    HStack {
//                        Text("Add")
//                        Image(systemName: "plus")
//                    }
//                }
//                .buttonStyle(HighKeyButtonStyle())
//            }
//            .padding(.horizontal)
            
//            Spacer()
//        }
            .navigationTitle(Text("Workout"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutView()
        }
    }
}
