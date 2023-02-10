//
//  WorkoutView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI
import RoutineRepository


public class WorkoutViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    
    @Published var routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])
    
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    // we need to store the reference in-memory so that we can update this record whenever
    // are adding exercises or updating the routine in any way
    func createNewRoutineRecord() {
        
//        routineStore.createRoutineRecord { [weak self] result in
//            switch result {
//            case let .success(routineRecord):
//
//                print("Successfully created routine record")
//                self?.routineRecord = routineRecord
//
//            case let .failure(error):
//                print("Failure to create routine record, \(error.localizedDescription)")
//            }
//        }
    }
    
    // To be more performant, we could just deal with all of this in memory and
    // try to implement core data saving logic whenever we are backgrounding the app or closing it?
    
    // Or we can just do this as we go?
    // 1. So whenever we come here for the first time. Create a RoutineRecord
    // 2. Whenever we add exercises, update that routine record and load current from core data
    // 3. Whenever we add to a set, save to core data as well and then load from core data
    
    // Whenever we are opening this up, we should do a query for any routine records that do not
    // have a completion date - If there is, get that instead of making a new routine record
    func readLatestRoutineRecord() {
        
//        // We need an ID that we can use to fetch the latest information
//        guard let routineRecord = routineRecord else { return }
//
//        routineStore.readRoutineRecord(with: routineRecord.id) { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case let .success(routineRecord):
//                self.routineRecord = routineRecord
//
//            case let .failure(error):
//                fatalError("Need to deal with error for reading routine record with id, \(error)")
//            }
//        }
    }
    
    
    // Passed to AddExerciseViewModel for logic after Add button is tapped
    public func addExercisesCompletion(exercises: [Exercise]) {
        print("add exercises completion in workout view: received: \(exercises)")
        
        // We need to update Core Data with the new exercises
        // Then load the routine record from what is in Core Data
        
        // create an exercise record
        
        for exercise in exercises {
            let setRecord = SetRecord(id: UUID(), duration: nil, repCount: 12, weight: 120, difficulty: 4)
            
            let exerciseRecord = ExerciseRecord(id: UUID(), setRecords: [setRecord], exercise: exercise)
            routineRecord.exerciseRecords.append(exerciseRecord)
        }
    }
}


public struct WorkoutView: View {
    
    public let inspection = Inspection<Self>()
    
    @ObservedObject public var viewModel: WorkoutViewModel
    let goToAddExercise: () -> Void


    public init(viewModel: WorkoutViewModel, goToAddExercise: @escaping () -> Void) {
        
        self.viewModel = viewModel
        self.goToAddExercise = goToAddExercise
    }
    
    
    public var body: some View {
        VStack {
            HStack {
                Text("Exercises")
                    .textCase(.uppercase)
                    .padding(.trailing, 6)
                
                Button {
                    goToAddExercise()
                } label: {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(HighKeyButtonStyle())
                .id("add-exercise-button")

                Spacer()
                EditButton()
                    .foregroundColor(.universeRed)
            }
            .font(.headline)
            
            
            List {
                if viewModel.routineRecord.exerciseRecords.isEmpty {
                    Text("Try adding an exercise!")
                } else {
                    
                    ForEach($viewModel.routineRecord.exerciseRecords, id: \.self) { exerciseRecord in
                        ExerciseRecordView(exerciseRecord: exerciseRecord)
                    }
                }
            }
        }
        .navigationTitle("Custom Workout")
        .onAppear {

            viewModel.createNewRoutineRecord()
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}


public struct ExerciseRecordView: View {

    @Binding var exerciseRecord: ExerciseRecord
    

    public var body: some View {
        
        Section {
            ForEach(0..<exerciseRecord.setRecords.count, id: \.self) { index in
                
                SetRecordView(setRecord: $exerciseRecord.setRecords[index], rowNumber: index + 1)
            }
        } header: {
            HStack {
                Text(exerciseRecord.exercise.name)
                Spacer()
            }
        }
    }
}


public struct SetRecordView: View {
    
    @Binding var setRecord: SetRecord
    let rowNumber: Int
    
    public var body: some View {
        
        HStack {
            Text("Set \(rowNumber)")
            
            Spacer()
            
            HStack {
                TextField("120", value: $setRecord.weight, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                
                Text("x")
                TextField("10", value: $setRecord.repCount, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
            }
        }
    }
}


struct WorkoutView_Previews: PreviewProvider {
    
    @State static var setRecord = SetRecord(id: UUID(), duration: nil, repCount: 0, weight: 0, difficulty: 0)
    
    static var previews: some View {
        let viewModel = WorkoutViewModel(routineStore: RoutineStorePreview())
        WorkoutView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
        
        
        SetRecordView(setRecord: $setRecord, rowNumber: 1)
    }
}
