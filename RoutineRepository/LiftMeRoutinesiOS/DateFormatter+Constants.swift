//
//  DateFormatter+Constants.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 9/2/23.
//

import Foundation



extension DateFormatter {
    
    static var shortDateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    
    static var shortTimeFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    
    static var mediumDateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    
    static var mediumDateShortTimeFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}

