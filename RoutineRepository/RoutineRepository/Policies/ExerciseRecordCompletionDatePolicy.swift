//
//  ExerciseRecordCompletionDatePolicy.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 9/2/23.
//


import Foundation


public enum ExerciseRecordCompletionDatePolicy {
    
    public static func calculateCompletionDate(using setRecords: [SetRecord]) -> Date? {
        
        guard !setRecords.isEmpty else { return nil }

        let earliestCompletionDate = setRecords.reduce(setRecords[0].completionDate) { earliestCompletionDate, currentSetRecord in
            
            return earliestCompletionDate <= currentSetRecord.completionDate ? earliestCompletionDate : currentSetRecord.completionDate
        }
        
        return earliestCompletionDate
    }
}

