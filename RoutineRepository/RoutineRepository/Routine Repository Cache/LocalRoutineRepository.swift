////
////  LocalRoutineRepository.swift
////  RoutineRepository
////
////  Created by Boyce Estes on 10/10/22.
////
//
//import Foundation
//
//public class LocalRoutineRepository: RoutineRepository {
//    
//    public enum Error: Swift.Error {
//        case routineWithNameAlreadyExists
//        case routineWithExercisesAlreadyExists(cachedRoutineName: String)
//    }
//    
//    
//    public let routineStore: RoutineStore
//    
//    
//    public init(routineStore: RoutineStore) {
//        self.routineStore = routineStore
//    }
//    
//    
//    public func save(routine: Routine, completion: @escaping RoutineRepository.SaveRoutineCompletion) {
//        
//        let localRoutine = routine.toLocal()
//        
//        routineStore.readRoutines(with: routine.name, or: localRoutine.exercises) { [weak self] readRoutineResult in
//            
//            guard let self = self else { return }
//            
//            switch readRoutineResult {
//                
//            case let .success(cachedRoutines):
//                
//                if cachedRoutines.isEmpty {
//                    
//                    self.routineStore.create(localRoutine) { createRoutineResult in
//                        if createRoutineResult == nil {
//                            completion(nil)
//                        } else {
//                            completion(createRoutineResult)
//                        }
//                    }
//                    
//                } else {
//                    let error = self.getErrorFrom(saving: localRoutine, with: cachedRoutines)
//                    completion(error)
//                }
//                
//            case let .failure(error):
//                completion(error)
//            }
//        }
//    }
//    
//    
//    private func getErrorFrom(saving routine: LocalRoutine, with routines: [LocalRoutine]) -> LocalRoutineRepository.Error {
//        
//        if let firstRoutine = routines.first,
//           routine.name != firstRoutine.name {
//            
//            return .routineWithExercisesAlreadyExists(cachedRoutineName: firstRoutine.name)
//        } else {
//            return .routineWithNameAlreadyExists
//        }
//    }
//    
//    
//    public func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
//        routineStore.readAllRoutines { result in
//            switch result {
//                
//            case let .success(routines):
//                let routines = routines.toModel()
//                completion(.success(routines))
//                
//            case let .failure(error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
//
//
//private extension Routine {
//    
//    func toLocal() -> LocalRoutine {
//        return LocalRoutine(
//            id: self.id,
//            name: self.name,
//            creationDate: self.creationDate,
//            exercises: self.exercises.toLocal(),
//            routineRecords: self.routineRecords.toLocal())
//    }
//}
//
//
//private extension Array where Element == LocalRoutine {
//    
//    func toModel() -> [Routine] {
//        return map {
//            $0.toModel()
//        }
//    }
//}
//
//
//private extension LocalRoutine {
//    
//    func toModel() -> Routine {
//        return Routine(
//            id: self.id,
//            name: self.name,
//            creationDate: self.creationDate,
//            exercises: self.exercises.toModel(),
//            routineRecords: self.routineRecords.toModel())
//    }
//}
//
//
//private extension Array where Element == Exercise {
//    
//    func toLocal() -> [LocalExercise] {
//        return map {
//            LocalExercise(
//                id: $0.id,
//                name: $0.name,
//                creationDate: $0.creationDate,
//                exerciseRecords: $0.exerciseRecords.toLocal(),
//                tags: $0.tags.toLocal())
//        }
//    }
//}
//
//
//private extension Array where Element == LocalExercise {
//    func toModel() -> [Exercise] {
//        return map {
//            Exercise(
//                id: $0.id,
//                name: $0.name,
//                creationDate: $0.creationDate,
//                exerciseRecords: $0.exerciseRecords.toModel(),
//                tags: $0.tags.toModel())
//        }
//    }
//}
//
//
//private extension Array where Element == ExerciseRecord {
//    
//    func toLocal() -> [LocalExerciseRecord] {
//        return map {
//            LocalExerciseRecord(
//                id: $0.id,
//                setRecords: $0.setRecords.toLocal())
//        }
//    }
//}
//
//
//private extension Array where Element == LocalExerciseRecord {
//    
//    func toModel() -> [ExerciseRecord] {
//        return map {
//            ExerciseRecord(
//                id: $0.id,
//                setRecords: $0.setRecords.toModel())
//        }
//    }
//}
//
//
//private extension Array where Element == SetRecord {
//    
//    func toLocal() -> [LocalSetRecord] {
//        return map {
//            LocalSetRecord(
//                id: $0.id,
//                duration: $0.duration,
//                repCount: $0.repCount,
//                weight: $0.weight,
//                difficulty: $0.difficulty)
//        }
//    }
//}
//
//
//private extension Array where Element == LocalSetRecord {
//    
//    func toModel() -> [SetRecord] {
//        return map {
//            SetRecord(
//                id: $0.id,
//                duration: $0.duration,
//                repCount: $0.repCount,
//                weight: $0.weight,
//                difficulty: $0.difficulty)
//        }
//    }
//}
//
//
//private extension Array where Element == Tag {
//    
//    func toLocal() -> [LocalTag] {
//        return map {
//            LocalTag(id: $0.id, name: $0.name)
//        }
//    }
//}
//
//
//private extension Array where Element == LocalTag {
//    
//    func toModel() -> [Tag] {
//        return map {
//            Tag(id: $0.id, name: $0.name)
//        }
//    }
//}
//
//
//private extension Array where Element == RoutineRecord {
//    
//    func toLocal() -> [LocalRoutineRecord] {
//        return map {
//            LocalRoutineRecord(
//                id: $0.id,
//                creationDate: $0.creationDate,
//                completionDate: $0.completionDate,
//                exerciseRecords: $0.exerciseRecords.toLocal())
//        }
//    }
//}
//
//
//private extension Array where Element == LocalRoutineRecord {
//    
//    func toModel() -> [RoutineRecord] {
//        return map {
//            RoutineRecord(
//                id: $0.id,
//                creationDate: $0.creationDate,
//                completionDate: $0.completionDate,
//                exerciseRecords: $0.exerciseRecords.toModel())
//        }
//    }
//}
