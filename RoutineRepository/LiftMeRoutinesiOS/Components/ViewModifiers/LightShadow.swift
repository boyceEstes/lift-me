//
//  LightShadow.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI


struct LightShadow: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.2), radius: foregroundShadow)
    }
}

extension View {
    
    func lightShadow() -> some View {
        modifier(LightShadow())
    }
}

