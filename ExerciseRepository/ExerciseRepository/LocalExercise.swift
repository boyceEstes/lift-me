//
//  LocalExercise.swift
//  
//
//  Created by Boyce Estes on 4/20/22.
//

import Foundation

public struct LocalExercise: Equatable, Codable {
    
    let id: UUID
    let name: String
    let dateCreated: Date
    let desc: String?
    
    var exerciseRecords: [LocalExerciseRecord]
    
    public init(id: UUID, name: String, dateCreated: Date, desc: String?, exerciseRecords: [LocalExerciseRecord]) {
        self.id = id
        self.name = name
        self.dateCreated = dateCreated
        self.desc = desc
        self.exerciseRecords = exerciseRecords
    }
}

extension LocalExercise {
    
    func toModel() -> Exercise {
        Exercise(id: self.id, name: self.name, dateCreated: self.dateCreated, desc: self.desc, exerciseRecords: self.exerciseRecords.toModels())
    }
}

extension Exercise {
    
    func toLocal() -> LocalExercise {
        LocalExercise(id: self.id, name: self.name, dateCreated: self.dateCreated, desc: self.desc, exerciseRecords: self.exerciseRecords.toLocal())
    }
}


extension Array where Element == Exercise {
    
    public func toLocal() -> [LocalExercise] {
        self.map { $0.toLocal() }
    }
}


extension Array where Element == LocalExercise {
    
    func toModels() -> [Exercise] {
        self.map {
            Exercise(
                id: $0.id,
                name: $0.name,
                dateCreated: $0.dateCreated,
                desc: $0.desc,
                exerciseRecords: $0.exerciseRecords.toModels())
        }
    }
}
