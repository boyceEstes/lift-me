//
//  ExerciseWithSetsStructureView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI

struct ExerciseWithSetsStructureView<TitleContent: View, SetContent: View>: View {
    
    let cornerRadius = 10.0
    
    let setSwipeToDelete: Bool
    let titleContent: () -> TitleContent
    let deleteTitleAction: (() -> Void)?
    let setContent: () -> SetContent
    
    init(
        setSwipeToDelete: Bool = false,
        titleContent: @escaping () -> TitleContent,
        deleteTitleAction: (() -> Void)? = nil,
        setContent: @escaping () -> SetContent
    ) {
        self.setSwipeToDelete = setSwipeToDelete
        self.titleContent = titleContent
        self.deleteTitleAction = deleteTitleAction
        self.setContent = setContent
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Title view
            if let deleteTitleAction = deleteTitleAction {
                titleContent()
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .swipeToDelete {
                        deleteTitleAction()
                    }
            } else {
                titleContent()
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
            }
            
            VStack(spacing: 0) {
                // foreach set record content, rows formatted however you like
                if setSwipeToDelete {
                    setContent() // Format in the content view
                } else {
                    setContent() // default implementation with no formatting
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
        }
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .coordinateSpace(name: "Custom")
        .cornerRadius(cornerRadius)
        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: cornerRadius))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: cornerRadius))
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
