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

struct StandardButtonSize: ViewModifier {
    
    func body(content: Content) -> some View {
        
        let dynamicTypeSizeRange = ..<DynamicTypeSize.accessibility3
        
        content
            .frame(height: 45)
            .dynamicTypeSize(dynamicTypeSizeRange)
    }
}

extension View {
    
    func standardButtonSize() -> some View {
        
        self.modifier(StandardButtonSize())
    }
}



struct StandardButtonPadding: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .padding(.horizontal)
    }
}


extension View {
    
    func standardButtonPadding() -> some View {
        
        self.modifier(StandardButtonPadding())
    }
}


struct MedKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundColor(Color.universeRed)
            .standardButtonPadding()
            .standardButtonSize()
    }
}


struct HighKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: .white))
            .standardButtonPadding()
            .standardButtonSize()
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
