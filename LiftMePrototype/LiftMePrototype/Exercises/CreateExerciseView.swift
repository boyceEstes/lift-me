//
//  CreateExerciseView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 3/1/23.
//

import SwiftUI

struct CreateExerciseView: View {
    
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Bench Press", text: $name)
                TextField("Description", text: $description)
            }
        }
    }
}

struct CreateExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExerciseView()
    }
}
