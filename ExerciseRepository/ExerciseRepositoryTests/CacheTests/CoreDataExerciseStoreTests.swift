
import XCTest
import ExerciseRepository


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
        
        let exp = expectation(description: "Wait for retrievals to complete")
        sut.retrieveAll { firstResult in
            
            sut.retrieveAll { secondResult in
                
                switch (firstResult, secondResult) {
                case (let .success(firstExercises), let .success(secondExercises)):
                    XCTAssertEqual(firstExercises, secondExercises)
                    XCTAssertEqual(secondExercises, [])
                    
                default:
                    XCTFail("Expected two retrieves to return empty, found first result \(firstResult) and second result \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnNonEmptyCache_deliversExercises() {
        
        let sut = makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        // insert into cache
        let exp = expectation(description: "Wait for insertion completion")
        sut.insert(exercise: exercise) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        // retrieve from cache
        let exp2 = expectation(description: "Wait for retrieve completion")
        sut.retrieveAll { result in
            switch result {
            case let .success(receivedExercises):
                XCTAssertEqual(receivedExercises, [exercise])
                
            default:
                XCTFail("Expected \(exercise), got \(result) instead")
            }
            
            exp2.fulfill()
        }
        
        wait(for: [exp2], timeout: 1)
    }
    
    
    private func makeSut() -> ExerciseStore {
        
        let bundle = Bundle(for: CoreDataExerciseStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataExerciseStore(storeURL: storeURL, bundle: bundle)
        trackForMemoryLeaks(sut)
        return sut
    }
}
