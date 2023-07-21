//
//  NonEditableNoteSectionVIew.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 7/20/23.
//

import SwiftUI

struct NonEditableNoteSectionView: View {
    
    let note: String?
    
    var body: some View {
        ExerciseWithSetsStructureView {
            Text("Workout Note")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        } setContent: {
            Text("\(note ?? "No note available")")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


struct NonEditableNoteSectionVIew_Previews: PreviewProvider {
    static var previews: some View {
        NonEditableNoteSectionView(note: nil)
    }
}
