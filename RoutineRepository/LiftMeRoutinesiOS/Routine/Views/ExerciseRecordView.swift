//
//  ExerciseRecordView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import SwiftUI
import RoutineRepository


public struct ExerciseRecordView: View {

    @Binding var exerciseRecordViewModel: ExerciseRecordViewModel
    // Do not update the original until this has finished - keyboard has been dismissed
    let deleteExerciseAction: () -> Void
    let goToExerciseDetails: (Exercise) -> Void

    public var body: some View {
        
        ExerciseWithSetsStructureView(setSwipeToDelete: true) {
            HStack {
                Text(exerciseRecordViewModel.exercise.name)
                    .font(.headline)
                Spacer()
                Button("Add Set") {
                    $exerciseRecordViewModel.wrappedValue.addNewSetRecordViewModel()
                }.buttonStyle(LowKeyButtonStyle())
            }
            .contentShape(Rectangle())
            .onTapGesture {
                goToExerciseDetails(exerciseRecordViewModel.exercise)
            }
        } deleteTitleAction: {
            deleteExerciseAction()
        } setContent: {
            ForEach($exerciseRecordViewModel.setRecordViewModels) { $setRecordViewModel in
                SetRecordView(
                    setRecordViewModel: $setRecordViewModel,
                    rowNumber: exerciseRecordViewModel.setRecordViewModels.firstIndex(of: $setRecordViewModel.wrappedValue) ?? 0 + 1
                )
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .swipeToDelete {
                        exerciseRecordViewModel.deleteRow(index: exerciseRecordViewModel.setRecordViewModels.firstIndex(of: $setRecordViewModel.wrappedValue) ?? 0)
                    }
            }
        }
    }
}


struct ExerciseRecordView_Previews: PreviewProvider {
    
    @State static var exerciseRecordViewModel = ExerciseRecordViewModel.preview
    
    static var previews: some View {
        ExerciseRecordView(exerciseRecordViewModel: $exerciseRecordViewModel, deleteExerciseAction: {}, goToExerciseDetails: { _ in })
    }
}
