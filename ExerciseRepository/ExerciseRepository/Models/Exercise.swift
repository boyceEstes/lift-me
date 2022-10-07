//
//  Exercise.swift
//  
//
//  Created by Boyce Estes on 4/13/22.
//

import Foundation

public struct Exercise: Equatable, Identifiable, Hashable {
    
    public let id: UUID
    public let name: String
    public let dateCreated: Date
    public let desc: String?
    public let dateLastCompleted: Date?
    
    public var exerciseRecords: [ExerciseRecord]
    
    public init(id: UUID, name: String, dateCreated: Date, desc: String?, dateLastCompleted: Date?, exerciseRecords: [ExerciseRecord]) {
        self.id = id
        self.name = name
        self.dateCreated = dateCreated
        self.desc = desc
        self.dateLastCompleted = dateLastCompleted
        self.exerciseRecords = exerciseRecords
    }
}
