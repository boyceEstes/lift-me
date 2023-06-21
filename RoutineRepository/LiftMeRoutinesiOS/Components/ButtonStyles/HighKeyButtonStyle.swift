//
//  HighKeyButtonStyle.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/14/23.
//

import SwiftUI


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
