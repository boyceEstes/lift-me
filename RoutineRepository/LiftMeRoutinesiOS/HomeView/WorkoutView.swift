//
//  WorkoutView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI
import RoutineRepository

public struct WorkoutView: View {
    
    public init(goToAddExercise: @escaping () -> Void) {
        self.goToAddExercise = goToAddExercise
    }
    
    let allExercises: [Exercise] = []
    let goToAddExercise: () -> Void

    public var body: some View {
        List {
            Section {
                if allExercises.isEmpty {
                    Text("Try adding an exercise!")
                } else {
                    ForEach(allExercises, id: \.self) { exercise in
                        Text(exercise.name)
                    }
                }

            } header: {
                HStack {
                    Text("Exercises")
                        .textCase(.uppercase)
                        .padding(.trailing, 6)
                    
                    Button {
                        goToAddExercise()
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                    }
                    .buttonStyle(HighKeyButtonStyle())
                    .id("add-exercise-button")

                    Spacer()
                    EditButton()
                        .foregroundColor(.universeRed)
                }
                .font(.headline)
            }.textCase(nil)
        }
        .navigationTitle("Custom Workout")
    }
}



struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(goToAddExercise: { })
    }
}
