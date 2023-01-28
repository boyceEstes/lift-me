//
//  ButtonStyles.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI


struct LowKeyButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? Color.universeRed : Color.universeRed.opacity(0.5))
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


struct HomeButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: .white))
            .padding(4)
            .padding(.horizontal, 6)
            .background(
                Color.universeRed
//                Capsule()
//                    .fill(Color.universeRed)
            )
            .cornerRadius(8)
    }
}
