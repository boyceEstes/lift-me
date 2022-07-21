//
//  AddExerciseView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 7/12/22.
//

import SwiftUI

struct AddExerciseView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var nameInput: String = ""
    @State private var descriptionInput: String = ""
    
    var body: some View {
        Form {
            HStack {
                Text("Name")
                Spacer()
                TextField("Name", text: $nameInput)
            }
            
            HStack {
                Text("Description")
                Spacer()
                TextField("Description", text: $descriptionInput)
            }
        }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}
