//
//  CreateExerciseView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 3/1/23.
//

import SwiftUI

class CreateExerciseViewModel: ObservableObject {
    
    @Published var exerciseName: String = ""
    @Published var exerciseDescription: String = ""
    
    init() { }
}

public struct CreateExerciseView: View {
    
    @ObservedObject var viewModel = CreateExerciseViewModel()
    
    public init() {
    }
    
    public var body: some View {
        Form {
            TextField("Name", text: $viewModel.exerciseName)
            TextField("Description", text: $viewModel.exerciseDescription)
        }
    }
}

struct CreateExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExerciseView()
    }
}
