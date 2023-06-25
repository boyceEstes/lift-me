//
//  UIColor+LiftMeThemeColors.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 10/23/22.
//

import UIKit


extension UIColor {
    
    // #Fb5b68
    static var universeRedDark = UIColor(displayP3Red: 251/255, green: 91/255, blue: 104/255, alpha: 1.0)
    // #Fb5765
    static var universeRedLight = UIColor(displayP3Red: 251/255, green: 87/255, blue: 101/255, alpha: 1.0)
    
    
    // TODO: 0.1.0 - Decide on colors - Is a secondary color a good idea (yeah)
    
    
    /*
     *
     * Decent website for deciding on colors: https://imagecolorpicker.com/color-code/e2525e
     *
     * For increased contrast with text, we could make the color a shade darker
     * - #e2525e for `universeRedLight`
     * - #e2525e for `universeRedDark` (Same color but we can work out this difference later)
     */
    // #Fb5b68
    static var legacy_universeRedDark = UIColor(displayP3Red: 251/255, green: 91/255, blue: 104/255, alpha: 1.0)
    // #Fb5765
    static var legacy_universeRedLight = UIColor(displayP3Red: 251/255, green: 87/255, blue: 101/255, alpha: 1.0)
    
    // For a secondary color
    // #52e2d6 - "turquoise blue" is a solid choice. It will have "super" contrast with black text
    
    // ALSO UNIVERSE RED ISN'T THAT BAD WITH BLACK TEXT - CONSIDER FOR NONDARK MODE
    
    // monochromatic could also be a look With these colors: #a63c45, #511d22
    
    // TODO: 0.1.0 - Research coloring themes in iOS applications
    
}
