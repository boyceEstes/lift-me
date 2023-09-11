//
//  ExerciseDropDelegate.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import SwiftUI


struct ExerciseDropDelegate: DropDelegate {
    
    let destinationExerciseRecordViewModel: ExerciseRecordViewModel
    @Binding var exerciseRecordViewModels: [ExerciseRecordViewModel]
    @Binding var draggedExerciseRecordViewModel: ExerciseRecordViewModel?
    
    
    func performDrop(info: DropInfo) -> Bool {
        
        draggedExerciseRecordViewModel = nil
        return true
    }
    
    
    func dropEntered(info: DropInfo) {
        
        guard let draggedExerciseRecordViewModel = draggedExerciseRecordViewModel,
              let sourceIndex = exerciseRecordViewModels.firstIndex(of: draggedExerciseRecordViewModel),
              let destinationIndex = exerciseRecordViewModels.firstIndex(of: destinationExerciseRecordViewModel)
        else {
            return
        }
        
        let calculatedDestinationindex = destinationIndex > sourceIndex ? destinationIndex + 1 : destinationIndex
        
        withAnimation {
            exerciseRecordViewModels.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: calculatedDestinationindex)
        }
    }
    
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        
        DropProposal(operation: .move)
    }
}

