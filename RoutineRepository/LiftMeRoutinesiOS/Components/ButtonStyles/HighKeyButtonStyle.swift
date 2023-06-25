//
//  HighKeyButtonStyle.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/14/23.
//

import SwiftUI


struct LongHighKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: thiccButtonHeight)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: .white))
            .background(
                RoundedRectangle(cornerRadius: 8)
                .fill(Color.universeRed)
            )
    }
}

struct HighKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color(uiColor: .white))
            .frame(height: thiccButtonHeight)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(Color.universeRed)
            )
    }
}
