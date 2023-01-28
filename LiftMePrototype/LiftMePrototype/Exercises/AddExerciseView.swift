//
//  AddExerciseView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 7/12/22.
//

import SwiftUI

enum MuscleGroup: String {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Tricpes"
    case abs = "Abs"
}

struct AddExerciseView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var nameInput: String = ""
    @State private var descriptionInput: String = ""
    @State private var selectedMuscleGroup: MuscleGroup = .chest
    let muscleGroups: [MuscleGroup] = [
        .chest,
        .back,
        .legs,
        .shoulders,
        .biceps,
        .triceps,
        .abs
    ]
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $nameInput)
            }
            
            Section("Description") {
                TextEditor(text: $descriptionInput)
            }
            
            Section("Muscle Groups") {
                Picker("Select Muscle Group", selection: $selectedMuscleGroup) {
                    ForEach(muscleGroups, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
        }
        .navigationTitle("Add Exercise")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}
