//
//  LocalTag.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalTag: Equatable {
    
    let id: UUID
    let name: String
    
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
