//
//  ExerciseWithSetInfoView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI
import RoutineRepository

struct ExerciseWithSetInfoView: View {
    
    let exerciseRecords: [ExerciseRecord]
    
    var body: some View {
        ForEach(exerciseRecords, id: \.self) { exerciseRecord in
            ExerciseWithSetsStructureView {
                HStack {
                    Text(exerciseRecord.exercise.name)
                    Spacer()
                    Text("\(exerciseRecord.setRecords.count) sets")
                }
            } setContent: {
                SetInfoViews(setRecords: exerciseRecord.setRecords)
            }
        }
    }
}


// TODO: 0.1.0 - When ExerciseRecord gets the dateCompletion property, we would want to make this work with
// a title that refers to the date completed instead of the exercise name (for exercise details page)
struct ExerciseWithSetInfoDateFocusedView: View {
    
    let exerciseRecords: [ExerciseRecord]
    
    var body: some View {
        ForEach(exerciseRecords, id: \.self) { exerciseRecord in
            ExerciseWithSetsStructureView {
                HStack {
                    Text("Some Date exercise was done (TBD)")
                    Spacer()
                    Text("\(exerciseRecord.setRecords.count) sets")
                }
            } setContent: {
                
                SetInfoViews(setRecords: exerciseRecord.setRecords)
            }
        }
    }
}


struct SetInfoViews: View {
    
    let setRecords: [SetRecord]
    
    var body: some View {
        ForEach(0..<setRecords.count, id: \.self) { index in
            HStack {
                Text("Set \(index+1)")
                Spacer()
                Text("\(String(setRecords[index].weight)) x \(String(setRecords[index].repCount))")
            }
            // We know that this is embedded in a VStack
            if index != (setRecords.count - 1) {
                Divider()
            }
        }
    }
}


struct ExerciseWithSetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseWithSetInfoView(exerciseRecords: [])
    }
}
