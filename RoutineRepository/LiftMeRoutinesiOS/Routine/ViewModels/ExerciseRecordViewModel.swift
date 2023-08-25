//
//  ExerciseRecordViewModel.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import Foundation
import RoutineRepository


public struct ExerciseRecordViewModel: Hashable, Identifiable {
    
    public var id = UUID()
    
    public var setRecordViewModels: [SetRecordViewModel]
    public let exercise: Exercise
    
    
    mutating func addNewSetRecordViewModel() {
        
        setRecordViewModels.append(SetRecordViewModel(weight: "", repCount: ""))
    }
    
    
    mutating func deleteRow(index: Int) {

        setRecordViewModels.remove(at: index)
    }
}



extension ExerciseRecordViewModel {
    
    static var preview: ExerciseRecordViewModel {
        ExerciseRecordViewModel(
            setRecordViewModels: [
                SetRecordViewModel.preview,
                SetRecordViewModel.preview,
                SetRecordViewModel.preview,
                SetRecordViewModel.preview,
                SetRecordViewModel.preview
            ],
            exercise: Exercise(id: UUID(), name: "Bench Press", creationDate: Date(), tags: [])
        )
    }
}
