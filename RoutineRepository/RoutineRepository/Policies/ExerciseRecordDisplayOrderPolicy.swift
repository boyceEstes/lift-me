//
//  ExerciseRecordDisplayOrderPolicy.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 9/4/23.
//

import Foundation

public enum ExerciseRecordDisplayOrderPolicy {
    
    public static func sortByDate(_ exerciseRecords: [ExerciseRecord]) -> [ExerciseRecord] {
        
        var setSortedExerciseRecords = exerciseRecords

        for index in 0..<setSortedExerciseRecords.count {
            setSortedExerciseRecords[index].setRecords = SetRecordDisplayOrderPolicy.sortByDate(setSortedExerciseRecords[index].setRecords)
        }
        
        
        let sortedExerciseRecords = setSortedExerciseRecords.sorted {
            
            guard let lhsCompletionDate = $0.completionDate else {
                return false
            }
            guard let rhsCompletionDate = $1.completionDate else {
                return true
            }
            
            return lhsCompletionDate > rhsCompletionDate
        }
        
        return sortedExerciseRecords
    }
}




public enum SetRecordDisplayOrderPolicy {
    
    public static func sortByDate(_ setRecords: [SetRecord]) -> [SetRecord] {
        guard !setRecords.isEmpty else { return [] }
        
        return setRecords.sorted {
            $0.completionDate < $1.completionDate
        }
    }
}
