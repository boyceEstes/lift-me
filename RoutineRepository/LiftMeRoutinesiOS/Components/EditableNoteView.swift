//
//  EditableNote.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 7/19/23.
//

import SwiftUI

enum NoteButtonState: String {
    case add
    case done
    case edit
    
    // business logic
    func nextState(note: String) -> NoteButtonState {
        
        switch self {
        
        // Not editing - must have no content
        case .add:
            return .done
        
        // Currently editing
        case .done:
            if note.isEmpty {
                return .add
            } else {
                return .edit
            }
            
        // Not editing - must have some content
        case .edit:
            return .done
        }
    }
}


extension NoteButtonState {
    
    func systemImageNameForButtonState(note: String) -> String {
        
        switch self {
        case .add:
            return "plus.circle.fill"
        case .edit:
            return "pencil.circle"
        case .done:
            if note.isEmpty {
                return "checkmark.circle"
            } else {
                return "checkmark.circle.fill"
            }
        }
    }
}


struct EditableNoteSectionView: View {
    
    @Binding var buttonState: NoteButtonState
    @Binding var note: String
    
    var body: some View {

        ExerciseWithSetsStructureView {
            
            HStack {
                Text("Workout Note")
                    .font(.headline)
                Spacer()
                Button {
                    withAnimation {
                        buttonState = buttonState.nextState(note: note)
                    }
                } label: {
                    Image(systemName: buttonState.systemImageNameForButtonState(note: note))
                        .imageScale(.large)
                }
            }
        } setContent: {
            NoteContent(buttonState: $buttonState, note: $note)
        }

    }
}


struct NoteContent: View {
    
    @Binding var buttonState: NoteButtonState
    @Binding var note: String
    
    var body: some View {
        
        switch buttonState {
        case .add:
            EmptyView()
        case .edit:
            Text("\(note)")
                .frame(maxWidth: .infinity, alignment: .leading)
        case .done:
            TextField("Note", text: $note, prompt: Text("JOYCE forever ❤️"), axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5)
        }
    }
}


struct EditableNote_Previews: PreviewProvider {
    static var previews: some View {
        EditableNoteSectionView(buttonState: .constant(.add), note: .constant(""))
    }
}
