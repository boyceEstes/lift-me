//
//  RoutineRecordDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository

public class RoutineRecordDetailViewModel: ObservableObject {
    
    let routineRecord: RoutineRecord
    
    public init(routineRecord: RoutineRecord) {
        self.routineRecord = routineRecord
    }
}


public struct RoutineRecordDetailView: View {
    
    @ObservedObject var viewModel: RoutineRecordDetailViewModel

    
    public init(viewModel: RoutineRecordDetailViewModel) {
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        Text("Routine Record Detail - exercise records \(viewModel.routineRecord.exerciseRecords.count)")
    }
}


struct RoutineRecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineRecordDetailView(viewModel:
            RoutineRecordDetailViewModel(
                routineRecord: RoutineRecord(
                    id: UUID(),
                    creationDate: Date(),
                    completionDate: Date(),
                    exerciseRecords: [
                        ExerciseRecord(
                            id: UUID(),
                            setRecords: [
                                SetRecord(
                                    id: UUID(),
                                    duration: nil,
                                    repCount: 12,
                                    weight: 100,
                                    difficulty: nil
                                ),
                                SetRecord(
                                    id: UUID(),
                                    duration: nil,
                                    repCount: 8,
                                    weight: 185,
                                    difficulty: nil
                                ),
                                SetRecord(
                                    id: UUID(),
                                    duration: nil,
                                    repCount: 6,
                                    weight: 225,
                                    difficulty: nil
                                )
                            ],
                            exercise: Exercise(
                                id: UUID(),
                                name: "Any Exercise",
                                creationDate: Date(),
                                tags: [])
                        )
                    ]
                )
            )
        )
    }
}
