//
//  WorkoutView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI
import RoutineRepository


public class WorkoutViewModel {
    
    let routineStore: RoutineStore
    
    @Published var routineRecord: RoutineRecord?
    
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
        print("We have added an exercise")
        
        // We need to update Core Data with the new exercises
        // Then load the routine record from what is in Core Data
        
    }
}


public struct WorkoutView: View {
    
    public let inspection = Inspection<Self>()
    
    let allExercises: [Exercise] = []
    
    public let viewModel: WorkoutViewModel
    let goToAddExercise: () -> Void


    public init(viewModel: WorkoutViewModel, goToAddExercise: @escaping () -> Void) {
        
        self.viewModel = viewModel
        self.goToAddExercise = goToAddExercise
    }
    
    
    public var body: some View {
        List {
            Section {
                if allExercises.isEmpty {
                    Text("Try adding an exercise!")
                } else {
                    ForEach(allExercises, id: \.self) { exercise in
                        ExerciseWithSetsView(exercise: exercise)
                    }
                }
            } header: {
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
            }.textCase(nil)
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


public struct ExerciseWithSetsView: View {

    let exercise: Exercise

    public var body: some View {
        Text(exercise.name)
    }
}


struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkoutViewModel(routineStore: RoutineStorePreview())
        WorkoutView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
    }
}
