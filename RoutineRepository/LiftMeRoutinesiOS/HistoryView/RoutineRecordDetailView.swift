//
//  RoutineRecordDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository


extension DateFormatter {
    
    static var shortDateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    
    static var shortTimeFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}


public class RoutineRecordDetailViewModel: ObservableObject {
    
    let routineRecord: RoutineRecord
    
    var creationDateString: String {
        return DateFormatter.shortDateFormatter.string(from: routineRecord.creationDate)
    }
    
    
    var creationTimeString: String {
        return DateFormatter.shortTimeFormatter.string(from: routineRecord.creationDate)
    }
    

    var completionDateString: String {
        guard let completionDate = routineRecord.completionDate else {
            return "No completion date"
        }
        
        return DateFormatter.shortDateFormatter.string(from: completionDate)
    }
    
    
    var completionTimeString: String {
        guard let completionDate = routineRecord.completionDate else {
            return "No completion date"
        }
        
        return DateFormatter.shortTimeFormatter.string(from: completionDate)
    }
    
    
    public init(routineRecord: RoutineRecord) {
        print("init routine record detail")
        self.routineRecord = routineRecord
    }
    
    
    deinit {
        print("deinit routine record detail")
    }
    
}


public struct RoutineRecordDetailView: View {
    
    @ObservedObject var viewModel: RoutineRecordDetailViewModel

    
    public init(viewModel: RoutineRecordDetailViewModel) {
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        
        ScrollView {
            LazyVStack(spacing: 20) {
                HStack(spacing: 20) {
                    CalendarStyleRoundedCellView(title: "Start", contentTitle: viewModel.creationDateString, contentSubtitle: viewModel.creationTimeString)
                    CalendarStyleRoundedCellView(title: "Finish", contentTitle: viewModel.completionDateString, contentSubtitle: viewModel.completionTimeString)
                }.padding(.top, 20)
                
                ExerciseWithSetInfoView(exerciseRecords: viewModel.routineRecord.exerciseRecords)
            }
            .padding(.horizontal)
        }
        .basicNavigationBar(title: "Workout Detail")
    }
}


struct RoutineRecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RoutineRecordDetailView(viewModel:
                RoutineRecordDetailViewModel(
                    routineRecord: RoutineRecord(
                        id: UUID(),
                        note: "Super high energy. Ready to destroy the lift!",
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
}
