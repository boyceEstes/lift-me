//
//  RoutineListView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 10/14/22.
//

import SwiftUI
extension UIColor {
    static var universeRedDark = UIColor(displayP3Red: 251/255, green: 91/255, blue: 104/255, alpha: 1.0)
    static var universeRedLight = UIColor(displayP3Red: 251/255, green: 87/255, blue: 101/255, alpha: 1.0)
}

extension Color {
    
    static var paleYellow = Color(.sRGB, red: 255/255, green: 246/255, blue: 205/255, opacity: 1.0)
    // 255,218,186
    static var paleOrange = Color(.sRGB, red: 255/255, green: 218/255, blue: 186/255, opacity: 1.0)
    // 255,185,175
    static var paleOrange2 = Color(.sRGB, red: 255/255, green: 185/255, blue: 175/255, opacity: 1.0)
    static var pomegranate = Color(.sRGB, red: 99/255, green: 24/255, blue: 64/255, opacity: 1.0)
    static var maroon = Color(.sRGB, red: 163/255, green: 42/255, blue: 83/255, opacity: 1.0)

    static var universeWhite = Color(.sRGB, red: 254/255, green: 255/255, blue: 237/255, opacity: 1.0)
    static var universePaleYellow = Color(.sRGB, red: 250/255, green: 249/255, blue: 203/255, opacity: 1.0)

    static var universeYellow = Color(.sRGB, red: 238/255, green: 239/255, blue: 162/255, opacity: 1.0)
    static var universeGold = Color(.sRGB, red: 254/255, green: 208/255, blue: 7/255, opacity: 1.0)
    static var universePink = Color(.sRGB, red: 251/255, green: 151/255, blue: 173/255, opacity: 1.0)
    static var universeBlue = Color(.sRGB, red: 70/255, green: 151/255, blue: 184/255, opacity: 1.0)
    static var universeLightBlue = Color(.sRGB, red: 110/255, green: 186/255, blue: 198/255, opacity: 1.0)
    static var universeBlack = Color(.sRGB, red: 26/255, green: 38/255, blue: 51/255, opacity: 1.0)
    static var universeBrightPink = Color(.sRGB, red: 241/255, green: 96/255, blue: 129/255, opacity: 1.0)
    
    
    
    
    
    static var systemBackgroundLight = Color(.sRGB, red: 255/255, green: 255/255, blue: 255/255, opacity: 1.0)
    static var systemBackgroundDark = Color(.sRGB, red: 0/255, green: 0/255, blue: 0/255, opacity: 1.0)
    

    static var secondarySystemBackgroundLight = Color(.sRGB, red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0)
    static var secondarySystemBackgroundDark =  Color(.sRGB, red: 0.11, green: 0.11, blue: 0.12, opacity: 1.0)
    
    
    static var tertiarySystemBackgroundLight = Color(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
    static var tertiarySystemBackgroundDark =  Color(.sRGB, red: 0.17, green: 0.17, blue: 0.18, opacity: 1.0)
    
    
    static var universeRed = Color(uiColor: .universeRedLight | .universeRedDark)

}


struct HomeView: View {
    var body: some View {
        ZStack {
//            LinearGradient(colors: [.white, .universeWhite], startPoint: .bottom, endPoint: .top)
//                .edgesIgnoringSafeArea(.all)
            RoutineListView3()
        }
    }
}


struct RoutineListView: View {
    
    var body: some View {
        ZStack {
            
        }
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                Button {
                    print("print")
                } label: {
                    Text("Show more")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 40)
                        .background(Capsule().fill(Color.universePink))
                }
            }.padding(.horizontal)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyVStack {
                    LazyHStack() {
                        ForEach(1...10, id: \.self) { id in
                            RoutineCellView(routineName: "Routine Biceps and Back \(id)")
                        }
                    }.padding(.leading)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.universeWhite, .paleYellow], startPoint: .bottom, endPoint: .top))
            )
            .padding(.horizontal)
            .padding(.top, 3)
        }
    }
}


struct RoutineCellView: View {
    
    let routineName: String
    
    var body: some View {
        Text("\(routineName)")
            .multilineTextAlignment(.center)
            .font(Font.title2)
            .padding(.horizontal, 5)
            .foregroundColor(.white)
            .frame(width: 150, height: 150)
            .background(
                LinearGradient(colors: [.paleYellow, .paleOrange, .universePink], startPoint: .bottom, endPoint: .top)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(colors: [.paleYellow, .paleOrange, .universePink], startPoint: .top, endPoint: .bottom),
                        lineWidth: 4
                    )
            )
            .padding(.horizontal, 2)
            .padding(.vertical)
    }
}


struct RoutineListView2: View {
    
    var body: some View {
        ZStack {
            
        }
        VStack(spacing: 6) {
            
            HStack {
                Spacer()
                
                Button {
                    print("print")
                } label: {
                    Text("New Routine")
                        .font(Font.headline)
                        .foregroundColor(.universePink)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(
                            Capsule()
                                .fill(Color.universeWhite))
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.universePink, lineWidth: 4)
                        )
                }
                
                Button {
                    print("print")
                } label: {
                    Text("Show more")
                        .font(Font.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(
                            Capsule()
                                .fill(Color.universePink))
//                        .overlay(
//                            Capsule()
//                                .strokeBorder(Color.universeWhite, lineWidth: 4)
//                        )
                }
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyVStack {
                    LazyHStack() {
                        ForEach(1...10, id: \.self) { id in
                            RoutineCellView2(routineName: "Routine Biceps and Back \(id)")
                        }
                    }
                    .padding(.leading)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.universePink], startPoint: .bottom, endPoint: .top))
            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(LinearGradient(colors: [.universePink], startPoint: .bottom, endPoint: .top), lineWidth: 4)
//            )
//            .padding(.horizontal)
            .padding(.top, 3)
        }
        .padding()
        .background(Color.paleOrange)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}


struct RoutineCellView2: View {
    
    let routineName: String
    
    var body: some View {
        Text("\(routineName)")
            .multilineTextAlignment(.center)
            .font(Font.title2)
            .padding(.horizontal, 5)
            .foregroundColor(.universePink)
            .frame(width: 150, height: 150)
            .background(
                LinearGradient(colors: [.universeWhite], startPoint: .bottom, endPoint: .top)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(colors: [.paleOrange2], startPoint: .top, endPoint: .bottom),
                        lineWidth: 4
                    )
            )
            .padding(.horizontal, 2)
            .padding(.vertical)
    }
}


struct RoutineListView3: View {
    let routineNames = ["Back and Biceps 1", "Chest and Triceps - Powerlifting", "Pull Day", "Push Day"]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 16) {
                    Text("Routines")
                        .font(.title2)
                        
                    Button {
                        print("hello world")
                    } label: {
                        HStack {
                            Text("New")
                                
                            Image(systemName: "plus")
        
                            
                        }
                        .font(.headline)
                        .foregroundColor(Color(uiColor: .label))
                        .padding(4)
                        .padding(.horizontal, 6)
                        .background(
                            Capsule()
                                .fill(Color.universeRed)
                        )
                    }
                }
                
                Spacer()
                
                Button {
                    print("hello world")
                } label: {
                    HStack {
                        Text("More")
                        Image(systemName: "chevron.right")
                    }.foregroundColor(.universeRed)
                }

            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyVStack {
                    LazyHStack(spacing: 12) {
                        ForEach(routineNames, id: \.self) { id in
                            RoutineCellView3(routineName: "\(id)")
                        }
                    }
                    .padding(.leading)
                }
            }
            
            .background(Color(uiColor: .secondarySystemBackground))
        }


    }
}


struct RoutineCellView3: View {
    
    let cellHeight: CGFloat = 120
    let routineName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(routineName)")
                .frame(maxWidth: .infinity, maxHeight: cellHeight / 3 * 2)
                .font(.headline)
            

            HStack() {
                HStack(spacing:0) {
                    Image(systemName: "star.fill")
                    Image(systemName: "star")
                    Image(systemName: "star")
                }
//                    .foregroundColor(.universeYellow)
                Text("(12)")
                    .font(.subheadline)
//                    .foregroundColor(.universeYellow)
            }
            .font(.callout)
            .foregroundColor(Color(uiColor: .label))
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3, alignment: .leading)
            .background(Color.universeRed)
        }
        .foregroundColor(Color(uiColor: .label))
        .frame(width: cellHeight, height: cellHeight)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(.vertical)
    }
}


struct RoutineListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.light)
    }
}

infix operator |: AdditionPrecedence
public extension UIColor {
    
    /// Easily define two colors for both light and dark mode.
    /// - Parameters:
    ///   - lightMode: The color to use in light mode.
    ///   - darkMode: The color to use in dark mode.
    /// - Returns: A dynamic color that uses both given colors respectively for the given user interface style.
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
            
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}
