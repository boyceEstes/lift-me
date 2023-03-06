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
    
    var dateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    
    var creationDateString: String {
        return dateFormatter.string(from: routineRecord.creationDate)
    }
    

    var completionDateString: String {
        guard let completionDate = routineRecord.completionDate else {
            return "No completion date"
        }
        
        return dateFormatter.string(from: completionDate)
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
        VStack {
            VStack {
                HStack {
                    Text("Creation Date")
                    Spacer()
                    Text(viewModel.creationDateString)
                }
                
                HStack {
                    Text("Completion Date")
                    Spacer()
                    Text(viewModel.completionDateString)
                }
            }
            .padding(.horizontal)

            
            List {
                ForEach(viewModel.routineRecord.exerciseRecords, id: \.self) { exerciseRecord in
                    Section {
                        HStack {
                            Text(exerciseRecord.exercise.name)
                            Spacer()
                            Text("\(exerciseRecord.setRecords.count) sets")
                        }
                        .font(Font.headline)
                        
                        ForEach(0..<exerciseRecord.setRecords.count, id: \.self) { index in
                            HStack {
                                
                                Text("Set \(index)")
                                Spacer()
                                Text("\(String(exerciseRecord.setRecords[index].weight)) x \(String(exerciseRecord.setRecords[index].repCount))")
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
            .navigationTitle("Routine Record Detail")
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct RoutineRecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
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
}
