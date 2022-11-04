//
//  CreateRoutineView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI

struct CreateRoutineView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var routineName: String = ""
    @State private var routineDesc: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Name", text: $routineName)
                    TextField("Description", text: $routineDesc)
                }
                Text("Placeholder Select ExerciseView")
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                    }
                    .buttonStyle(LowKeyButtonStyle())
                    .padding(.horizontal, 8)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Save")
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.headline)
                    }
                    .buttonStyle(LowKeyButtonStyle())
                    .padding(.horizontal, 8)
                }
            }
        }
    }
}

struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateRoutineView()
        }
    }
}
