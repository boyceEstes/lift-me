
import XCTest
import ExerciseRepository

class CoreDataExerciseStore: ExerciseStore {
        
    init() {}
    
    
    // Exercise Use Cases
    func insert(exercise: LocalExercise, completion: @escaping InsertExerciseCompletion) {
        
    }
    
    
    func retrieveAll(completion: @escaping RetrieveAllExercisesCompletion) {
        
    }
    
    
    func update(exercise: LocalExercise, completion: @escaping UpdateExerciseCompletion) {
        
    }
    
    
    func delete(exercise: LocalExercise, completion: @escaping DeleteExerciseCompletion) {
        
    }
    
    
    // Exercise Record Use Case
    func insert(exerciseRecord: LocalExerciseRecord, completion: @escaping InsertExerciseRecordCompletion) {
        
    }
    
    
    func retrieveAllExerciseRecords(completion: @escaping RetrieveAllExerciseRecordsCompletion) {
        
    }
    
    
    func delete(exerciseRecord: LocalExerciseRecord, completion: @escaping DeleteExerciseRecordCompletion) {
        
    }
    
    
    // Set Record Use Case
    func insert(setRecord: LocalSetRecord, completion: @escaping InsertSetRecordCompletion) {
        
    }

    
    func update(setRecord: LocalSetRecord, completion: @escaping UpdateSetRecordCompletion) {
        
    }
    
    
    func delete(setRecord: LocalSetRecord, completion: @escaping DeleteSetRecordCompletion) {
        
    }
}


class CoreDataExerciseStoreTests: XCTestCase {

    func test_coreDataExerciseStore_creation_deliversEmptyExerciseCache() {
        
        let sut = makeSut()
        
        sut.retrieveAll { result in
            switch result {
            case let .success(exercises):
                XCTAssertEqual(exercises, [], "Expected empty cache, got \(exercises) instead")
            default:
                XCTFail("Expected successful empty exercise cache retrieval, got \(result) instead")
            }
        }
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnEmptyCacheTwice_deliversHasNoSideEffects() {
        
        let sut = makeSut()
        
        sut.retrieveAll { firstResult in
            sut.retrieveAll { secondResult in
                switch (firstResult, secondResult) {
                case (let .success(firstExercises), let .success(secondExercises)):
                    XCTAssertEqual(firstExercises, secondExercises)
                    XCTAssertEqual(secondExercises, [])
                    
                default:
                    XCTFail("Expected two retrieves to return empty, found first result \(firstResult) and second result \(secondResult) instead")
                }
            }
        }
    }
    
    
    private func makeSut() -> ExerciseStore {
        
        let sut = CoreDataExerciseStore()
        trackForMemoryLeaks(sut)
        return sut
    }
}
