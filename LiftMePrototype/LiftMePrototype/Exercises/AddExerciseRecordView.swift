//
//  AddExerciseRecordView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 7/5/22.
//

import SwiftUI

struct AddExerciseRecordView: View {
    
    @Environment(\.presentationMode) var presentationMode

    let exercise: Exercise
    @State private var setRecords = [SetRecord(repCount: 0, duration: 0, weight: 0, difficulty: 0)]
    
    var body: some View {

        VStack {
            List {
                Section {
                    ForEach(Array(setRecords.enumerated()), id: \.offset) { index, setRecord in
                        AddSetRecordView(index: index, setRecord: setRecord)
                    }
                } header: {
                    HStack(alignment: .center) {
                        Text("Sets")
                            .font(Font.title2)
                        
                        Spacer()
                        
                        Button {
                            setRecords.append(SetRecord(repCount: 0, duration: 0, weight: 0, difficulty: 0))
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }.textCase(nil)
            }
        }
        .navigationTitle("Add \(exercise.name) Log")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}


struct AddSetRecordView: View {
    
    @State private var weightAmount: String = ""
    @State private var repAmount: String = ""
    
    let index: Int
    let setRecord: SetRecord
    
    init(index: Int, setRecord: SetRecord) {
        
        self.index = index + 1 // Add one so that it isn't labelled starting at 0
        self.setRecord = setRecord
        self.weightAmount = "\(setRecord.weight)"
        self.repAmount = "\(setRecord.repCount ?? 0)"
    }
    
    var body: some View {
        
        HStack {
            Text("Set \(index)")
            Spacer()
            HStack(spacing: 0) {
                TextField("weight", text: $weightAmount)
                    .frame(width: 60)
                Text("lbs")
            }
            Text("x")
            TextField("reps", text: $repAmount)
            .frame(width: 60)
        }
    }
}

struct AddExerciseRecordView_Previews: PreviewProvider {
    static var previews: some View {
        let exercise = Exercise.mock
        AddExerciseRecordView(exercise: exercise)
    }
}

struct AddSetRecordView_Previews: PreviewProvider {
    static var previews: some View {
        let setRecord = SetRecord(repCount: 0, duration: 0, weight: 0, difficulty: 0)
        AddSetRecordView(index: 0, setRecord: setRecord)
    }
}
