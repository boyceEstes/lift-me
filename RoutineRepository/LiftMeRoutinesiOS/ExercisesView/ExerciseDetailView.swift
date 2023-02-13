//
//  ExerciseDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository

public class ExerciseDetailViewModel: ObservableObject {
    
    @Published var exerciseRecords = [ExerciseRecord]()
    
    let routineStore: RoutineStore
    let exercise: Exercise
    
    
    public init(routineStore: RoutineStore, exercise: Exercise) {
        
        self.routineStore = routineStore
        self.exercise = exercise
        
        print("Initialized \(exercise.name) viewModel")
    }
    
    deinit {
        print("deinitialized \(exercise.name) viewModel")
    }
    
    
    func readExerciseRecordsForExercise() {
        
        routineStore.readExerciseRecords(for: exercise) { [weak self] result in
            
            guard let self = self else {
//                fatalError("Ah ha")
                return
            }
            
            switch result {
            case let .success(exerciseRecords):
                self.exerciseRecords = exerciseRecords
                
            case let .failure(error):
                // TODO: Handle error
                fatalError("Ah shit, \(error)")
            }
        }
    }
}


public struct ExerciseDetailView: View {
    
    @ObservedObject var viewModel: ExerciseDetailViewModel
    
    public let inspection = Inspection<Self>()

    
    public init(viewModel: ExerciseDetailViewModel) {
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        VStack {
            // TODO: For some reason there is n
            Text("Exercise Details - like name")
            Text("Date Created \(viewModel.exercise.creationDate)")
            Text("Exercise Records \(viewModel.exerciseRecords.count)")
            
            List {
                ForEach(viewModel.exerciseRecords, id: \.self) { exerciseRecord in
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
        .navigationTitle(viewModel.exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
        .onAppear {
            viewModel.readExerciseRecordsForExercise()
        }
    }
}


struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseDetailView(
                viewModel: ExerciseDetailViewModel(
                    routineStore: RoutineStorePreview(),
                    exercise: Exercise(
                        id: UUID(),
                        name: "Any exercise",
                        creationDate: Date(),
                        tags: []
                    )
                )
            )
        }
    }
}
