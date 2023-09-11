
import SwiftUI
import RoutineRepository

class ExerciseListNavigationFlow: NewStackNavigationFlow, NewSheetyNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    @Published var displayedSheet: SheetyIdentifier?
    
    // MARK: Stack Destinations
    enum StackIdentifier: Hashable {
        
        case exerciseDetail(Exercise)
        
        static func == (lhs: ExerciseListNavigationFlow.StackIdentifier, rhs: ExerciseListNavigationFlow.StackIdentifier) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .exerciseDetail(exercise):
                hasher.combine("exerciseDetail-\(exercise.id)")
            }
        }
    }
    
    // MARK: Sheety Destinations
    enum SheetyIdentifier: Identifiable {
        
        case createExercise
        
        var id: String {
            switch self {
            case .createExercise: return "createExercise"
            }
        }
    }
}
