//
//  ExerciseDetailView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 7/5/22.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    let exercise: Exercise
    
    var body: some View {
        NavigationView {
            VStack {
                Text(exercise.description)
                
                Text("Records")
                List(exercise.records) { exerciseRecord in
                    Text("HELLO")
                }
            }
            .navigationTitle(exercise.name)
        }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let mockExercise = Exercise.mock
        
        ExerciseDetailView(exercise: mockExercise)
    }
}
