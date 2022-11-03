//
//  CreateRoutineView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI

struct CreateRoutineView: View {
    
    @State private var routineName: String = ""
    @State private var routineDesc: String = ""
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $routineName)
                TextField("Description", text: $routineDesc)
                Button("This is mine") {}.buttonStyle(.)
            }
            Text("Placeholder Select ExerciseView")
            Spacer()
        }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateRoutineView()
        }
    }
}
