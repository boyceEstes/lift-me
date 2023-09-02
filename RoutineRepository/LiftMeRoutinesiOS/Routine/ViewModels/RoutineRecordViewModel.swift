//
//  RoutineRecordViewModel.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import Foundation
import RoutineRepository


public struct RoutineRecordViewModel: Hashable {

    public let creationDate: Date
    public var exerciseRecordViewModels: [ExerciseRecordViewModel]
    
    public func mapToRoutineRecord(note: String?, completionDate: Date) -> RoutineRecord {
        RoutineRecord(
            id: UUID(),
            note: note,
            creationDate: creationDate,
            completionDate: completionDate,
            exerciseRecords: exerciseRecordViewModels.map {
                ExerciseRecord(
                    id: UUID(),
                    setRecords: $0.setRecordViewModels.map {
                        // You cannot have 0 reps #businessRule - should be done somewhere
                        // else, but anyway: You can have a 0 weight. So if nothing is
                        // set for the weight, we will assume its zero.
                        
                        // If rep count is empty we will error - set it to negative 1
                        SetRecord(
                            id: UUID(),
                            duration: nil,
                            repCount: ($0.repCount.isEmpty ? -1 : Double($0.repCount)) ?? -1,
                            weight: ($0.weight.isEmpty ? 0 : Double($0.weight)) ?? 0,
                            difficulty: nil,
                            completionDate: $0.completionDate ?? creationDate
                        )
                    },
                    exercise: $0.exercise
                )
            }
        )
    }
    
    
    mutating func deleteExerciseRecord(index: Int) {
        exerciseRecordViewModels.remove(at: index)
    }
}
