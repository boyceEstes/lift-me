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
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    
    var timeFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    
    var creationDateString: String {
        return dateFormatter.string(from: routineRecord.creationDate)
    }
    
    var creationTimeString: String {
        return timeFormatter.string(from: routineRecord.creationDate)
    }
    

    var completionDateString: String {
        guard let completionDate = routineRecord.completionDate else {
            return "No completion date"
        }
        
        return dateFormatter.string(from: completionDate)
    }
    
    
    var completionTimeString: String {
        guard let completionDate = routineRecord.completionDate else {
            return "No completion date"
        }
        
        return timeFormatter.string(from: completionDate)
    }
    
    
    public init(routineRecord: RoutineRecord) {
        print("init routine record detail")
        self.routineRecord = routineRecord
    }
    
    
    deinit {
        print("deinit routine record detail")
    }
    
}


struct CalendarStyleDateTimeView: View {
    
    let cellHeight: CGFloat = 100
    
    let title: String
    let dateString: String
    let timeString: String
    
    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(title)
                    .fontWeight(.bold)
                Spacer()
            }
            .font(.callout)
            .foregroundColor(Color(uiColor: .label))
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3, alignment: .leading)
            .background(Color.universeRed)
            
            VStack(spacing: 0) {
                Text("\(dateString)")
                    
                    .font(.headline)
                Text("\(timeString)")
            }
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3 * 2)
        }
            .roundedCell(cellHeight: cellHeight)
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
                    CalendarStyleDateTimeView(title: "Start", dateString: viewModel.creationDateString, timeString: viewModel.creationTimeString)
                    CalendarStyleDateTimeView(title: "Finish", dateString: viewModel.completionDateString, timeString: viewModel.completionTimeString)
                }.padding(.top, 20)
                
                ForEach(viewModel.routineRecord.exerciseRecords, id: \.self) { exerciseRecord in
                    Section {
                        ExerciseWithSetsStructure {
                            HStack {
                                Text(exerciseRecord.exercise.name)
                                Spacer()
                                Text("\(exerciseRecord.setRecords.count) sets")
                            }
                        } setContent: {
                            ForEach(0..<exerciseRecord.setRecords.count, id: \.self) { index in
                                HStack {
                                    Text("Set \(index)")
                                    Spacer()
                                    Text("\(String(exerciseRecord.setRecords[index].weight)) x \(String(exerciseRecord.setRecords[index].repCount))")
                                }
                                // We know that this is embedded in a VStack
                                if index != (exerciseRecord.setRecords.count - 1) {
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
//        }
//
//        VStack {
//            VStack {
//                HStack {
//                    Text("Creation Date")
//                    Spacer()
//                    Text(viewModel.creationDateString)
//                }
//
//                HStack {
//                    Text("Completion Date")
//                    Spacer()
//                    Text(viewModel.completionDateString)
//                }
//            }
//            .padding(.horizontal)

            
//
//            List {
//                ForEach(viewModel.routineRecord.exerciseRecords, id: \.self) { exerciseRecord in
//                    Section {
//                        HStack {
//                            Text(exerciseRecord.exercise.name)
//                            Spacer()
//                            Text("\(exerciseRecord.setRecords.count) sets")
//                        }
//                        .font(Font.headline)
//
//                        ForEach(0..<exerciseRecord.setRecords.count, id: \.self) { index in
//                            HStack {
//
//                                Text("Set \(index)")
//                                Spacer()
//                                Text("\(String(exerciseRecord.setRecords[index].weight)) x \(String(exerciseRecord.setRecords[index].repCount))")
//                            }
//                        }
//                    }
//                }
//            }
//
//            Spacer()
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
