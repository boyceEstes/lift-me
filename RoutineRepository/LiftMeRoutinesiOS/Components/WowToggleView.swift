//
//  WowToggleView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 9/2/23.
//

import SwiftUI

struct WowToggleView: View {
    
    @Binding var isTurnedOn: Bool
//    @State private var isTurnedOn = false
    @State private var tap = false
    
    var body: some View {
        VStack {
            
            if isTurnedOn {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            } else {
                EmptyView()
            }
        }
        .frame(width: 32, height: 32)
        .background(isTurnedOn ? Color.universeRed : Color(uiColor: .tertiarySystemGroupedBackground))
        .cornerRadius(Constant.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .strokeBorder(Color.universeRed, lineWidth: 4)
        }
        .clipShape(RoundedRectangle(cornerRadius: Constant.cornerRadius))
        .scaleEffect(isTurnedOn ? (tap ? 1.1 : 1) : 0.9)
        .animation(isTurnedOn ? .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.2) : .easeOut(duration: 0.6), value: isTurnedOn)
        .onTapGesture {
            tap = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tap = false
                isTurnedOn.toggle()
            }
        }
    }
}

struct WowToggleView_Previews: PreviewProvider {
    static var previews: some View {
        WowToggleView(isTurnedOn: .constant(true))
//        WowToggleView()
    }
}
