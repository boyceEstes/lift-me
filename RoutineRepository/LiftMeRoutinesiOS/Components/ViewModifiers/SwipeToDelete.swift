//
//  SwipeToDeleteViewModifier.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 7/23/23.
//

import SwiftUI

struct SwipeToDeleteViewModifier: ViewModifier {
    
    // constants
    let deleteButtonWidth = 55.0
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    // initialization arguments
    let deleteAction: () -> Void
    let height: CGFloat
    
    // state variables
    @State private var itemOffset = 0.0
    @State private var isSwiped = false
    
    func body(content: Content) -> some View {
        
        ZStack {
            // DELETE BUTTON
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .frame(maxWidth: deleteButtonWidth, maxHeight: height)
                    .offset(x: itemOffset + deleteButtonWidth)
            }
            .background(Color.red)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    delete()
                }
            }
            
            
            // ROW CONTENT
            content
                .background(Color.secondarySystemBackground)
                .offset(x: itemOffset)
                .gesture(DragGesture().onChanged(onChanged(_:)).onEnded(onEnded(_:)))
        }
    }
    
    
    func onChanged(_ value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiped {
                
                itemOffset = value.translation.width - deleteButtonWidth
            } else {
                itemOffset = value.translation.width
            }
        }
    }
    
    
    func onEnded(_ value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            if value.translation.width < 0 {
//                if -value.translation.width > viewWidth / 2 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    itemOffset = -1000
                    delete()
                } else if -itemOffset > deleteButtonWidth {
                    isSwiped = true
                    itemOffset = -deleteButtonWidth
                } else {
                    resetView()
                }
            } else {
                resetView()
            }
        }
    }
    
    
    func delete() {
        
        impactFeedback.impactOccurred()
        resetView()
        deleteAction()
    }
    
    
    func resetView() {
        
        itemOffset = 0
        isSwiped = false
    }
}


extension View {
    
    func swipeToDelete(height: CGFloat = .infinity, deleteAction: @escaping () -> Void) -> some View {
        modifier(SwipeToDeleteViewModifier(deleteAction: deleteAction, height: height))
    }
}


struct SwipeToDeleteViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Some cell content")
            .frame(height: 40)
            .frame(maxWidth: .infinity)
//            .background(Color.secondarySystemBackground)
            .swipeToDelete(height: 40) {
                print("delete row")
            }
    }
}
