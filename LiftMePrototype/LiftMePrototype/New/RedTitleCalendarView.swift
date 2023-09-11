//
//  MainView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 9/5/23.
//

import SwiftUI

/*
 This contains the view logic for creating a "calendar" view. with a subtitle. It is nice
 but too much graphically. Overwhelming with the red.
 */


struct RoundedCell: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .foregroundColor(Color(uiColor: .label))
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(16)
    }
}


extension View {
    
    func roundedCell(cellHeight: CGFloat = 130) -> some View {
        modifier(RoundedCell())
    }
}


struct CalendarStyleRoundedCellView: View {
    
    let title: String
    let contentTitle: String
    let contentSubtitle: String
    
    
    init(title: String, contentTitle: String, contentSubtitle: String = "") {
        
        self.title = title
        self.contentTitle = contentTitle
        self.contentSubtitle = contentSubtitle
    }
    
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(title) what if we have more text")
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .frame(width: 150)
                    .padding()
                    .foregroundColor(Color(uiColor: .label))
                    .background(Color.universeRed)
                
                VStack(spacing: 0) {
                    Text("\(contentTitle)")
                }
                .padding()
            }
        
                .roundedCell()
    }
}


struct CalendarView2: View {
    
    let title: String
    let subtitle1: String
    let subtitle1Value: String
    let subtitle2: String
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
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    // Up to Accessibility 1. Does not include Accessibility 2 ( at least not for title)
    var dynamicTitleHeight: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small, .medium, .large: return 60
        case .xLarge, .xxLarge: return 70
        case .xxxLarge: return 75
        case .accessibility1: return 85
        default: return 85 // Cap title frame height to this size
        }
    }
    
    var dynamicCardWidth: CGFloat {
        switch dynamicTypeSize {
        case .xSmall: return 185
        case .small: return 190
        case .medium: return 200
        case .large: return 205
        case .xLarge, .xxLarge: return 230
        case .xxxLarge: return 250
        case .accessibility1: return 290
        default: return 290 // Cap frame width to this size
        }
    }
    
    let dynamicTypeSizeRange = DynamicTypeSize.xSmall...DynamicTypeSize.accessibility1
    
    var body: some View {
        
            VStack(alignment: .center, spacing: 0) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.horizontal)
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: dynamicTitleHeight)
                    .background(Color.universeRed)
                    .dynamicTypeSize(dynamicTypeSizeRange)
                
                HStack(spacing: 0) {
//                    Spacer()
                    VStack(spacing: 0) {
                        Text(subtitle1)
                            .font(.caption2)
                            .padding(.bottom, 5)
                            .foregroundColor(.secondary)
                        Text(subtitle1Value)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 20,
                                    style: .continuous
                                )
                            )
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text(subtitle2)
                            .font(.caption2)
                            .padding(.bottom, 5)
                            .foregroundColor(.secondary)
                        Text(subtitle2Value)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 20,
                                    style: .continuous
                                )
                            )
                    }
//                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
            .multilineTextAlignment(.center)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
            .frame(width: dynamicCardWidth)
            .dynamicTypeSize(dynamicTypeSizeRange)
        
    }
}


struct CalendarView3: View {
    
    let title: String
    
    var body: some View {
        
        ZStack (alignment: .topLeading) {
            
            Rectangle()
                .foregroundColor(.white)
            
            Text("Hello world")
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50, alignment: .center)
                .background(Color.pink)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: 300, height: 450, alignment: .center)
    }
}

struct MainView: View {
    
    let dynamicTypeSizeRange = DynamicTypeSize.xSmall...DynamicTypeSize.accessibility1
    
    var body: some View {

        ZStack {
            Color(uiColor: UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                
                exerciseSectionTitle1(title: "Routines")
                
                routineCalendarSection
                    .padding(.leading)

//                routineButtons
//                    .padding()
//
                exerciseSectionTitle1(title: "Exercises")
                
                exerciseCalendarSection
                    .padding(.leading)
                
//                exerciseButton
//                    .padding()
            }
        }
    }
    
    
    var routineButtons: some View {
        
        HStack(spacing: 16) {
            Button {
                print("Hello world 2")
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "bolt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("Start Workout")
                }
                .font(.headline)
//                .frame(maxWidth: .infinity)
            }
//            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
            .tint(.universeRed)
            
            Spacer()
            
            Button {
                print("Hello world 2")
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("Create Routine")
                }
                .font(.headline)
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(
//                    Color(uiColor: .tertiarySystemGroupedBackground)
//                )
            }
            .foregroundColor(.universeRed)
//            .background(Color.yellow)
//            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    
    var exerciseButton: some View {
        
//        HStack {
            Button {
                print("Hello world 2")
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("Create Exercise")
                }
                .font(.headline)
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(
//                    Color(uiColor: .tertiarySystemGroupedBackground)
//                )
            }
//            .buttonStyle(.bordered)
//            .buttonBorderShape(.roundedRectangle(radius: 16))
//            .tint(.universeRed)
            .foregroundColor(.universeRed)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
//            Spacer()
//        }
    }
    
    
    
    var routineCalendarSection: some View {
        
        ScrollView([.horizontal]) {
            LazyHStack(spacing: 16) {
                CalendarView2(title: "Chest Day", avgDuration: "1h 14m", last: "12/28/23")
                CalendarView2(title: "Leg Day", avgDuration: "43m", last: "12/28/23")
                CalendarView2(title: "Back Day", avgDuration: "1h 14m", last: "12/28/23")
            }
        }
    }
    
    
    var exerciseCalendarSection: some View {
        
        ScrollView([.horizontal]) {
            LazyHStack(spacing: 16) {
                CalendarView2(title: "Bench Press", bestORM: "235.5", last: "12/28/23")
                CalendarView2(title: "Rear Delt Reverse Pec Deck Flys", bestORM: "235.5", last: "12/28/23")
                CalendarView2(title: "Overhead Tricep Extensions", bestORM: "235.5", last: "12/28/23")
            }
        }
    }
    
    
    func exerciseSectionTitle1(title: String) -> some View {
        
        HStack(spacing: 10) {
            Text(title)
            Image(systemName: "chevron.right")
                .imageScale(.small)
        }
        .font(.title2.weight(.semibold))
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
    }
    
    
    var exerciseSectionTitle2: some View {
        
        HStack {
            Text("Exercises".uppercased())
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
            Spacer()
            HStack {
                Text("See All")
                Image(systemName: "chevron.right")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
        }
        .padding(20)
        .dynamicTypeSize(dynamicTypeSizeRange)
    }
    
    
    var exerciseSectionTitle3: some View {
        
        HStack {
            Text("Exercises".uppercased())
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
            Spacer()
            HStack {
                Text("More")
                Image(systemName: "chevron.right")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .padding(20)
        .onTapGesture {
            print("Tap exercise")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
