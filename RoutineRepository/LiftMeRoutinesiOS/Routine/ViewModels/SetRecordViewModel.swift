//
//  SetRecordViewModel.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import Foundation
import RoutineRepository


public struct SetRecordViewModel: Hashable, Identifiable {
    
    public var id = UUID()
    
    public var weight: String
    public var repCount: String
}


extension SetRecordViewModel {
    
    static var preview: SetRecordViewModel {
        
        SetRecordViewModel(weight: "225", repCount: "5")
    }
}
