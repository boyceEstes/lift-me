
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
        
        insert(exercise, into: sut)
        
        expect(sut: sut, toRetrieve: .success([exercise]))
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnNonEmptyCacheTwice_hasNoSideEffects() {
        
        let sut = makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        expect(sut: sut, toRetrieveTwice: .success([exercise]))
    }
    
    
    func test_coreDataExerciseStore_insertExerciseIntoEmptyCache_deliversNoError() {
        
        let sut = makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        let insertError = insert(exercise, into: sut)
        
        XCTAssertNil(insertError)
    }
    
    
    func test_coreDataExerciseStore_insertExerciseIntoNonEmptyCache_deliversNoError() {
        
        let sut = makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let exercise2 = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        let insertError = insert(exercise2, into: sut)
        
        XCTAssertNil(insertError)
    }
    
    
    // MARK: - Helpers
    
    private func makeSut() -> ExerciseStore {
        
        let bundle = Bundle(for: CoreDataExerciseStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataExerciseStore(storeURL: storeURL, bundle: bundle)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    
    @discardableResult
    private func insert(_ exercise: LocalExercise, into sut: ExerciseStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        
        let exp = expectation(description: "Wait for insertion completion")
        
        var receivedError: Error?
        
        sut.insert(exercise: exercise) { error in
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        return receivedError
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
