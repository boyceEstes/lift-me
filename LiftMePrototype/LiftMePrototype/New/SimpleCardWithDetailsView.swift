//
//  SimpleCardWithDetailsView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 9/9/23.
//

import SwiftUI

/*
 Design for card is mostly on Figma
 */

struct HighKeyButton<Content: View>: View {
    
    let label: () -> Content
    
    var body: some View {
        
        Button {
            print("hello world")
        } label: {
            label()
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(HighKeyButtonStyle())
        .background(
            Capsule()
                .fill(Color.universeRed)
        )
    }
}

struct MedKeyButton<Content: View>: View {
    
    let label: () -> Content
    
    var body: some View {
        
        Button {
            print("hello world")
        } label: {
            label()
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(MedKeyButtonStyle())
        .overlay(
            Capsule()
                .stroke(Color.universeRed, lineWidth: 2.0)
        )
    }
}


struct Take2: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let title: String
    let subtitle1: String
    let subtitle2: String
    let subtitle1Value: String
    let subtitle2Value: String
    
    init(title: String, bestORM: String, last: String) {
        
        self.title = title
        self.subtitle1 = "Best ORM"
        self.subtitle2 = "Last"
        self.subtitle1Value = "\(bestORM) lb"
        self.subtitle2Value = last
    }
    
    
    init(title: String, avgDuration: String, last: String) {
        
        self.title = title
        self.subtitle1 = "Avg Duration"
        self.subtitle2 = "Last"
        self.subtitle1Value = avgDuration
        self.subtitle2Value = last
    }
    
    
    var dynamicCardWidth: CGFloat {
        switch dynamicTypeSize {
        case .xSmall: return 180
        case .small: return 190
        case .medium: return 200
        case .large: return 205
        case .xLarge, .xxLarge: return 230
        case .xxxLarge: return 240
        case .accessibility1: return 290
        default: return 290 // Cap frame width to this size
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)//("Rear Delt Reverse Pec Deck Fly with more")
                .font(.headline)
                .lineLimit(2, reservesSpace: true)
            
            HStack(spacing: 5) {
                statView(subtitle: subtitle1, value: subtitle1Value)
                
                Spacer()
                statView(subtitle: subtitle2, value: subtitle2Value)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .frame(width: dynamicCardWidth)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
    
    
    func statView(subtitle: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
            Text(value)
                .font(.footnote)
                .foregroundColor(.universeRed)
                .lineLimit(1)
        }
    }
}


struct ExampleHomeScreen: View {
    
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                
                routineSection
                
                exerciseSection
            }
        }
    }
    
    
    func sectionTitle1(title: String) -> some View {
        
        HStack(spacing: 10) {
            Text(title)
            Image(systemName: "chevron.right")
                .imageScale(.small)
        }
        .font(.title2.weight(.semibold))
        .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    
    var routineSection: some View {
        
        VStack(spacing: 0) {
            
            sectionTitle1(title: "Routines")
            
            ScrollView([.horizontal]) {
                LazyHStack {
                    Take2(title: "Stuff and things and stuff and suff", avgDuration: "45m", last: "12/23/23")
                    Take2(title: "Chest Day", avgDuration: "1h 15m", last: "12/21/23")
                }
                .padding()
            }
            
            routineButtons
                .padding()
        }
    }
    
    
    var exerciseSection: some View {
        
        VStack(spacing: 0) {
            
            sectionTitle1(title: "Exercises")
            
            ScrollView([.horizontal]) {
                LazyHStack {
                    Take2(title: "Chest Day", bestORM: "225.0", last: "12/21/23")
                    Take2(title: "Stuff and things and stuff and suff", bestORM: "215.0", last: "12/23/23")
                }
                .padding()
            }
            
            HStack {
                exerciseButton
                Spacer()
            }
                .padding()
        }
    }
    
    
    var routineButtons: some View {
        
        ViewThatFits {
            routineButtonsInRow
            routineButtonsInColumn
        }
    }
    
    var routineButtonsInRow: some View {
        
        HStack(spacing: 8) {
            
            HighKeyButton {
                startCustomLabel
            }
            
            Spacer()
            
            
            MedKeyButton {
                newRoutineLabel
            }
        }
    }
    
    
    var routineButtonsInColumn: some View {
        
        VStack(spacing: 5) {
            
            HighKeyButton {
                startCustomLabel
            }
            
            
            Spacer()
            
            MedKeyButton {
                newRoutineLabel
            }
        }
    }
    
    
    var startCustomLabel: some View {
        
        HStack(spacing: 5) {
            Image(systemName: "bolt.fill")
                .imageScale(.medium)
            Text("Start Custom")
        }
    }
    
    
    var newRoutineLabel: some View {
        HStack(spacing: 5) {
            Image(systemName: "plus.circle")
                .imageScale(.medium)
            Text("New Routine")
        }
    }
    
    
    var exerciseButton: some View {
        
        MedKeyButton {
            newExerciseLabel
        }
    }
    
    
    var newExerciseLabel: some View {

        HStack(spacing: 5) {
            Image(systemName: "plus.circle")
                .imageScale(.medium)
            Text("New Exercise")
        }
    }
}


// Reusable stuff: Horizontal sliding section


struct SimpleCardWithDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleHomeScreen()
    }
}
