//
//  BasicNavigationBarViewModifier.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/14/23.
//

import SwiftUI

struct BasicNavigationBarViewModifier: ViewModifier {
    
    let title: String
    
    func body(content: Content) -> some View {
        
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.navigationBar, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}


extension View {
    
    func basicNavigationBar(title: String) -> some View {
        modifier(BasicNavigationBarViewModifier(title: title))
    }
}
