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
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    // we need to store the reference in-memory so that we can update this record whenever
    // are adding exercises or updating the routine in any way
    func createNewRoutineRecord() {
        
        routineStore.createRoutineRecord { result in
            switch result {
            case .success:
                print("Successfully created routine record")
            case let .failure(error):
                print("Failure to create routine record, \(error.localizedDescription)")
            }
        }
    }
    
    
    // Passed to AddExerciseViewModel for logic after Add button is tapped
    public func addExercisesCompletion(exercises: [Exercise]) {
        print("We have added an exercise")
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
                        Text(exercise.name)
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



struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkoutViewModel(routineStore: RoutineStorePreview())
        WorkoutView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
    }
}
