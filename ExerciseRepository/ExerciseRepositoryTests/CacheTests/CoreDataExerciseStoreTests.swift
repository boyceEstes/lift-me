
import XCTest
import ExerciseRepository


class CoreDataExerciseStoreTests: XCTestCase {

    func test_coreDataExerciseStore_creation_deliversEmptyExerciseCache() {
        
        let sut = makeSut()
        
        expect(sut: sut, toRetrieve: .success([]))
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnEmptyCacheTwice_deliversHasNoSideEffects() {
        
        let sut = makeSut()
        
        expect(sut: sut, toRetrieveTwice: .success([]))
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
        expect(sut: sut, toRetrieve: .success([exercise]))
    }
    
    
    // MARK: - Helpers
    
    private func makeSut() -> ExerciseStore {
        
        let bundle = Bundle(for: CoreDataExerciseStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataExerciseStore(storeURL: storeURL, bundle: bundle)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    
    private func expect(sut: ExerciseStore, toRetrieve expectedResult: ExerciseStore.RetrieveExercisesResult, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieveAll { receivedResult in
            
            switch (receivedResult, expectedResult) {
            case let (.success(receivedExercises), .success(expectedExercises)):
                XCTAssertEqual(receivedExercises, expectedExercises, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expect(sut: ExerciseStore, toRetrieveTwice expectedResult: ExerciseStore.RetrieveExercisesResult, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut: sut, toRetrieve: expectedResult)
        expect(sut: sut, toRetrieve: expectedResult)
    }
}
