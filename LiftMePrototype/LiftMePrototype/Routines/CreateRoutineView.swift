//
//  CreateRoutineView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI


struct ExerciseRowViewModel: Hashable, Equatable {

    var name: String
    var selected: Bool

    static var mock: [ExerciseRowViewModel] {
        [
            ExerciseRowViewModel(name: "Bench press", selected: false),
            ExerciseRowViewModel(name: "Tricep extension", selected: false),
            ExerciseRowViewModel(name: "Overhead tricep extension", selected: true)
        ]
    }
}


class CreateRoutineViewModel: ObservableObject {
    
    @Published var exerciseList = ExerciseRowViewModel.mock
    
    func moveExercise(fromOffsets source: IndexSet, toOffset destination: Int) {
        exerciseList.move(fromOffsets: source, toOffset: destination)
    }
}


struct CreateRoutineView: View {
    
    @ObservedObject var viewModel = CreateRoutineViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var routineName: String = ""
    @State private var routineDesc: String = ""
    @State private var exerciseSearch = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $routineName)
                        TextField("Description", text: $routineDesc)
                    }
                    
                    Section {
                        if viewModel.exerciseList.isEmpty {
                            Text("")
                        } else {
                            ForEach(viewModel.exerciseList, id: \.self) {
                                Text($0.name)
                            }.onDelete { index in
                                viewModel.exerciseList.remove(atOffsets: index)
                            }.onMove(perform: viewModel.moveExercise(fromOffsets:toOffset:))
                        }
                    } header: {
                        HStack {
                            Text("Exercises")
                                .textCase(.uppercase)
                                .padding(.trailing, 6)
                            
                            NavigationLink {
                                ExerciseSelectionListView()
                            } label: {
                                HStack {
                                    Text("Add")
                                    Image(systemName: "plus")
                                }
                            }
                            .buttonStyle(HighKeyButtonStyle())

  
                            Spacer()
                            EditButton()
                                .foregroundColor(.universeRed)
                        }
                        .font(.headline)
                    }.textCase(nil)

                    
//                    Section("Exercises Available") {
//                        ForEach($viewModel.exerciseList, id: \.self) { exercise in
////                            Text(exercise.name)
//                            SelectableExerciseRow(exerciseName: exercise.name.wrappedValue, selected: exercise.selected)
////                            SelectableExerciseRow(exerciseName: exercise.name, selected: exercise.$selected)
//                        }
//                    }
                }
            }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
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



// TODO: Create some sort of
struct SelectableExerciseRow: View {
    
    let exerciseName: String
    @Binding var selected: Bool
    
    var body: some View {

        HStack {
            
            Button {
                selected.toggle()
                
            } label: {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(selected ? Color.universeRed : Color(uiColor: .tertiaryLabel))
            }.padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(exerciseName)
                Text("Last completed: 11/27/22")
                    .font(Font.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateRoutineView()
                .environment(\.editMode, .constant(.active))
        }
    }
}
