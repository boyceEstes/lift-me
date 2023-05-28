//
//  NamingPolicy.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 5/25/23.
//

import Foundation
import UtilityMe

public enum NamingPolicy {
    
    // FIXME: Currently will break whenever there are double digits
    public static func uniqueName(from oldName: String) -> String {
        
        // Only capture the last 3 characters where we would make the unique name by number
        let capturableName = String(oldName.suffix(3))
        let parenthesisNumberPattern = #"(\d+)"#
        
        if let capturedNumberString = capturableName.capture(regex: parenthesisNumberPattern),
           var capturedNumber = Int(capturedNumberString) {
            
            capturedNumber += 1
            
            let nameWithoutCount = oldName.prefix(oldName.count - 4)
            
            return "\(nameWithoutCount) (\(capturedNumber))"
            
        } else {
            return "\(oldName) (1)"
        }
    }
}
