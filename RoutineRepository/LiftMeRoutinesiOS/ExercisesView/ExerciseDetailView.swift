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
    
    
    var exerciseCreationDateString: String {
        
        DateFormatter.shortDateFormatter.string(from: exercise.creationDate)
    }
    
    
    var exerciseCreationTimeString: String {
        DateFormatter.shortTimeFormatter.string(from: exercise.creationDate)
    }
    
    
    public init(routineStore: RoutineStore, exercise: Exercise) {
        
        self.routineStore = routineStore
        self.exercise = exercise
        
        readExerciseRecordsForExercise()
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
        
        ScrollView {
            LazyVStack(spacing: 20) {

                // TODO: - 0.1.0: Create description for each exercise
                
                HStack(spacing: 20) {
                    CalendarStyleRoundedCellView(title: "Created", contentTitle: viewModel.exerciseCreationDateString, contentSubtitle: viewModel.exerciseCreationTimeString)
                    CalendarStyleRoundedCellView(title: "Records", contentTitle: "\(viewModel.exerciseRecords.count)")
                    CalendarStyleRoundedCellView(title: "ORM", contentTitle: "TBD")
                }
                
                ExerciseWithSetInfoDateFocusedView(exerciseRecords: viewModel.exerciseRecords)
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .basicNavigationBar(title: viewModel.exercise.name)
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
        .onAppear {
//            viewModel.readExerciseRecordsForExercise()
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
