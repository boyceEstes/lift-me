//
//  ButtonStyles.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI


struct LowKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.universeRed)
    }
}

struct SelectableHighKeyButton: ButtonStyle {
    
    let selected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        
        if selected {
            configuration.label
                .fontWeight(.medium)
                .foregroundColor(Color(uiColor: .white))
                .padding(4)
                .padding(.horizontal, 6)
                .background(
                    Capsule()
                        .fill(Color.universeRed)
                )
        } else {
            configuration.label
                .fontWeight(.medium)
                .foregroundColor(.universeRed)
                .padding(4)
                .padding(.horizontal, 6)
                .background(
                    Capsule()
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(.universeRed)
                )
        }

    }
}


struct HighKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: .white))
            .padding(4)
            .padding(.horizontal, 6)
            .background(
                Capsule()
                    .fill(Color.universeRed)
            )
    }
}
