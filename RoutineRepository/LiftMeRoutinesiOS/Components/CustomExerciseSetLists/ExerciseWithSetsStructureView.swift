//
//  ExerciseWithSetsStructureView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI

struct ExerciseWithSetsStructureView<TitleContent: View, SetContent: View>: View {
    
    let titleContent: () -> TitleContent
    let setContent: () -> SetContent
    
    var body: some View {
        VStack(spacing: 0) {
            // Title view
            titleContent()
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
            
            VStack(spacing: 0) {
                // foreach set record content, rows formatted however you like
                setContent()
            }
        }
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .coordinateSpace(name: "Custom")
        .cornerRadius(10)
        .lightShadow()
    }
}


struct ExerciseWithSetsStructureView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseWithSetsStructureView {
            Text("Some Title")
        } setContent: {
            Text("Some Set")
        }
    }
}
