//
//  RoundedCell.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI



struct RoundedCell: ViewModifier {
    
    let cellHeight: CGFloat
    
    
    init(cellHeight: CGFloat = 130) {
        
        self.cellHeight = cellHeight
    }
    
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .foregroundColor(Color(uiColor: .label))
            .frame(width: cellHeight , height: cellHeight)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(16)
            .lightShadow()
    }
}


extension View {
    
    func roundedCell(cellHeight: CGFloat = 130) -> some View {
        modifier(RoundedCell(cellHeight: cellHeight))
    }
}


