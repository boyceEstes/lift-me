//
//  BasicNavigationBarViewModifier.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/14/23.
//

import SwiftUI


struct ThemedNavigationBarStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.navigationBar, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}


struct ThemedNavigationBarWithTitle: ViewModifier {
    
    let title: String
    
    func body(content: Content) -> some View {

        content
            .navigationTitle(title)
            .themedNavigationBarStyle()
    }
}


struct ThemedNavigationBarWithTitleContent<TitleContent: View>: ViewModifier {
    
    let titleContent: () -> TitleContent
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    titleContent()
                }
            }
            .themedNavigationBarStyle()
    }
}


extension View {
    
    func basicNavigationBar(title: String) -> some View {
        modifier(ThemedNavigationBarWithTitle(title: title))
    }
    
    
    func basicNavigationBar<Content: View>(@ViewBuilder titleContent: @escaping () -> Content) -> some View {
        modifier(ThemedNavigationBarWithTitleContent(titleContent: titleContent))
    }
    
    
    fileprivate func themedNavigationBarStyle() -> some View {
        modifier(ThemedNavigationBarStyle())
    }
}
