//
//  RoutineDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/28/23.
//

import SwiftUI
import RoutineRepository


public class RoutineDetailViewModel: ObservableObject {
    
    @Published public var routine: Routine
    
    public init(routine: Routine) {
        
        self.routine = routine
    }
    
    // Passed to AddExerciseViewModel for logic after Add button is tapped
    public func addExercisesCompletion(exercises: [Exercise]) {
        print("add exercises completion in workout view: received: \(exercises)")
        
        var updatedTotalExercises = routine.exercises
        for exercise in exercises {
            updatedTotalExercises.append(exercise)
        }
    }
}


public struct RoutineDetailView: View {
    
    let viewModel: RoutineDetailViewModel
    let goToAddExercise: () -> Void
//    let goToWorkout: (Routine) -> Void
//    let goToExerciseDetail: (Exercise) -> Void
    
    
    public init(
        viewModel: RoutineDetailViewModel,
        // We need this here because the add exercise completion method is needed
        goToAddExercise: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.goToAddExercise = goToAddExercise
    }
    
    
    public var body: some View {
        
        Form {
            Text("\(viewModel.routine.name)")
            
            EditableExerciseSectionView(
                exercises: viewModel.routine.exercises,
                goToAddExerciseView: goToAddExercise
            )
        }
        .basicNavigationBar(title: "Routine Details")
    }
}


struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = RoutineDetailViewModel(routine: Routine(id: UUID(), name: "Routine", creationDate: Date(), exercises: [], routineRecords: []))
        
        RoutineDetailView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
    }
}
