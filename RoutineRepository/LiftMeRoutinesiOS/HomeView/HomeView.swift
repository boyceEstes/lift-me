//
//  HomeView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI

public struct HomeView: View {
    
    public init() {}
    
    public var body: some View {
        
        VStack {
            
            Button {
                // go to next view
                print("Go to custom routine")
            } label: {
                Text("Custom Routine")
            }
            .frame(maxWidth: .infinity, maxHeight: 35)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: .white))
            .background(
                RoundedRectangle(cornerRadius: 8)
                .fill(Color.universeRed)
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
