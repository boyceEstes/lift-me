//
//  ExerciseSelectionListView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 12/13/22.
//

import SwiftUI


struct SelectableTag: Identifiable, Hashable {

    var id: UUID { UUID() }
    
    let tag: TagType
    var selected: Bool
    
    internal init(tag: TagType, selected: Bool) {
        self.tag = tag
        self.selected = selected
    }
}


class ExerciseSelectionListViewModel: ObservableObject {
    
    let allExercises = [
        Exercise(name: "Deadlift", tags: [.back]),
        Exercise(name: "Bench press", tags: [.chest]),
        Exercise(name: "Squat", tags: [.glutes, .quads, .hamstrings]),
        Exercise(name: "Bicep curl", tags: [.bicep]),
        Exercise(name: "Tricep extension", tags: [.tricep]),
        Exercise(name: "Overhead tricep extension", tags: [.tricep]),
        Exercise(name: "Leg press", tags: [.quads, .glutes]),
        Exercise(name: "Bicep dumbbell press", tags: [.bicep]),
        Exercise(name: "Single-leg press", tags: [.quads]),
        Exercise(name: "Romanian deadlift", tags: [.back, .hamstrings]),
        Exercise(name: "Single-leg Romanian deadlift", tags: [.hamstrings]),
        Exercise(name: "Leg curl", tags: [.hamstrings]),
        Exercise(name: "Lying leg curl", tags: [.hamstrings]),
        Exercise(name: "Leg extension", tags: [.quads]),
        Exercise(name: "Cable bicep curl", tags: [.bicep]),
        Exercise(name: "Cable tricep extension", tags: [.tricep]),
        Exercise(name: "Tricep extensions", tags: [.tricep]),
        Exercise(name: "Tricep skullcrushers", tags: [.tricep]),
        Exercise(name: "Chest fly", tags: [.chest])
    ]
    
    @Published var selectableTags = TagType.allCases.map { SelectableTag(tag: $0, selected: false) }
    
    @Published var filteredExercises = [Exercise]()
    @Published var filterExerciseText = ""
    
    @Published var selectedExercises = [Exercise]()
    
    
    var selectedTags: [TagType] {
        selectableTags.filter {
            $0.selected
        }.map {
            $0.tag
        }
    }
    
    
    func selectTag(at index: Int) {
        
        selectableTags[index].selected.toggle()
        
        filterExercises()
    }
    
    
    func filterExercises() {
        
        filteredExercises = allExercises.filter { exercise in
            
            
            // filter exercises
            // exercise.tags.contains selectedTags
            // if exercise.tag contains one selected tag and not the other
            // it is NOT included
            
            // Only include the exercise if both tags are included
            
            var allSelectedIncludedValues = [Bool]()
            
            selectedTags.forEach { selectedTagType in
                
                // selected: [Quad, Hamstring]
                var selectedIncluded = false
                
                exercise.tags.forEach { tagType in
                    
                    
                    // exercise:  [Glutes, Hamstring, Quads]
                    // exercise2: [Quad, Hamstrings, Glutes]
                    // exercise3: [Quad, Glutes]
                    // exercise4: [Chest]
                    
                    if tagType == selectedTagType {
                        
                        selectedIncluded = true
                        return
                    }
                }
                
                // if the last one is true, but all others are false,
                allSelectedIncludedValues.append(selectedIncluded)
            }
            
            let allSelectedIncluded = allSelectedIncludedValues.reduce(true) {
                return $0 && $1
            }
            
            guard allSelectedIncluded else { return false }
            
            if filterExerciseText.isEmpty {
                return true
            } else {
                return exercise.name.localizedCaseInsensitiveContains(filterExerciseText)
            }
        }
    }
}

struct ExerciseSelectionListView: View {
    

    @ObservedObject var viewModel = ExerciseSelectionListViewModel()
    @State private var multiselection = Set<UUID>()
    @State var editMode: EditMode = .active
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(zip(viewModel.selectableTags.indices, viewModel.selectableTags)), id: \.1) { index, selectableTag in
                        
                        Button {
                            viewModel.selectTag(at: index)
                            
                        } label: {
                            Text("\(selectableTag.tag.rawValue.capitalized)")
                        }
                       
                        .buttonStyle(SelectableHighKeyButton(selected: selectableTag.selected))
                    }
                }
            }
            .padding(.horizontal)

                
            List(viewModel.filteredExercises, selection: $multiselection) { exercise in
                VStack(alignment: .leading) {
                    
                    Text(exercise.name)
                    HStack {
                        ForEach(exercise.tags, id: \.self) {
                            Text("\($0.rawValue.capitalized)")
                        }
                    }
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.caption)
                    
                }
            }
        }
        .onAppear() {
            viewModel.filterExercises()
        }
        .onChange(of: viewModel.filterExerciseText, perform: { newValue in
            viewModel.filterExercises()
        })
        .onSubmit {
            viewModel.filterExercises()
        }
            .navigationTitle("Select Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.filterExerciseText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddButton(selectedExercises: multiselection, dismiss: {
                        dismiss()
                    })
                        .buttonStyle(LowKeyButtonStyle())
                }
            }
            .environment(\.editMode, $editMode)
    }
}


struct AddButton: View {
    
    let selectedExercises: Set<UUID>
    let dismiss: (() -> Void)?
    
    var body: some View {
        Button("Add (\(selectedExercises.count))") {
            print("add however many")
            dismiss?()
        }
        .disabled(selectedExercises.isEmpty ? true : false)
    }
}


struct ExerciseSelectionListView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ExerciseSelectionListView()
        }
    }
}
