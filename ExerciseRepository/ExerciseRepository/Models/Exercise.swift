//
//  Exercise.swift
//  
//
//  Created by Boyce Estes on 4/13/22.
//

import Foundation

public struct Exercise: Equatable, Identifiable {
    
    public let id: UUID
    public let name: String
    public let dateCreated: Date
    public let desc: String?
    
    public var exerciseRecords: [ExerciseRecord]
    
    public init(id: UUID, name: String, dateCreated: Date, desc: String?, exerciseRecords: [ExerciseRecord]) {
        self.id = id
        self.name = name
        self.dateCreated = dateCreated
        self.desc = desc
        self.exerciseRecords = exerciseRecords
    }
}
