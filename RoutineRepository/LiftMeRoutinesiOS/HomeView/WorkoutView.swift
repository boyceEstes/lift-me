//
//  WorkoutView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI
import RoutineRepository

public struct WorkoutView: View {
    
    public let inspection = Inspection<Self>()
    
    let allExercises: [Exercise] = []
    
    let routineStore: RoutineStore
    let goToAddExercise: () -> Void


    public init(routineStore: RoutineStore, goToAddExercise: @escaping () -> Void) {
        
        self.routineStore = routineStore
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
            // we need to store the reference in-memory so that we can update this record whenever
            // are adding exercises or updating the routine in any way
            routineStore.createRoutineRecord { result in
                switch result {
                case .success:
                    print("Successfully created routine record")
                case let .failure(error):
                    print("Failure to create routine record, \(error.localizedDescription)")
                }
            }
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}



struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(
            routineStore: RoutineStorePreview(),
            goToAddExercise: { }
        )
    }
}
