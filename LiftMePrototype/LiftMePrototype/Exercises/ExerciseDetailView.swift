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
        
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(exercise.description)
                    .padding(.horizontal)
                
                
                Section {
                    List(exercise.records) { exerciseRecord in
                        Section {
                            ForEach(Array(exerciseRecord.sets.enumerated()), id: \.offset) { index, setRecord in
                                SetRecordRow(index: index, setRecord: setRecord)
                            }
                        } header: {
                            HStack {
                                Text(exerciseRecord.dateCompletedString)
                                Spacer()
                                Text("\(exerciseRecord.numberOfSets) sets")
                            }
                        }
                    }
                    
                } header: {
                    HStack(alignment: .center) {
                        Text("Logs")
                            .font(Font.title2)
                            .padding([.horizontal, .top])
                        
                        Spacer()
                        
                        NavigationLink {
                            AddExerciseRecordView(exercise: exercise)
                        } label: {
                            Image(systemName: "plus")
                                .padding(.horizontal)
                        }
                    }.padding(.horizontal)
                }
                
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct SetRecordRow: View {
    
    let index: Int
    let setRecord: SetRecord
    
    var body: some View {
        HStack {
            Text("Set \(index+1)")
                .foregroundStyle(.secondary)
            Spacer()
            HStack {
                Text("\(setRecord.weight)lbs")
                Text("x")
                Text("\(setRecord.repCount ?? 0)")
            }
        }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let mockExercise = Exercise.mock
        
        ExerciseDetailView(exercise: mockExercise)
    }
}
