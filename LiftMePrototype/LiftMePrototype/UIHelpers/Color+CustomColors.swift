//
//  Color+CustomColors.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 11/3/22.
//

import SwiftUI
import UIKit

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
