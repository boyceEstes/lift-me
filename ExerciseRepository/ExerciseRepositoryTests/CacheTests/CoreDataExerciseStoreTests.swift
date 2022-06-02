
import XCTest
import ExerciseRepository
import CoreData


extension NSManagedObjectContext {
    static func alwaysFailingFetchStub() -> Stub {
        Stub(source: #selector(NSManagedObjectContext.execute(_:)),
             destination: #selector(Stub.execute(_:)))
    }
    
    
    class Stub: NSObject {
        
        private let source: Selector
        private let destination: Selector
        
        init(source: Selector, destination: Selector) {
            self.source = source
            self.destination = destination
        }
        
        
        @objc
        func execute(_: Any) throws -> Any {
            throw anyNSError()
        }
        
        
        func startIntercepting() {
            method_exchangeImplementations(
                class_getInstanceMethod(NSManagedObjectContext.self, source)!,
                class_getInstanceMethod(Stub.self, destination)!
            )
        }
        
        
        deinit {
            method_exchangeImplementations(
                class_getInstanceMethod(Stub.self, destination)!,
                class_getInstanceMethod(NSManagedObjectContext.self, source)!
            )
        }
    }
}

class CoreDataExerciseStoreTests: XCTestCase {

    func test_coreDataExerciseStore_creation_deliversEmptyExerciseCache() throws {
        
        let sut = try makeSut()
        
        expect(sut: sut, toRetrieve: .success([]))
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnEmptyCacheTwice_deliversHasNoSideEffects() throws {
        
        let sut = try makeSut()
        
        expect(sut: sut, toRetrieveTwice: .success([]))
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnNonEmptyCache_deliversExercises() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        expect(sut: sut, toRetrieve: .success([exercise]))
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesOnNonEmptyCacheTwice_hasNoSideEffects() throws{
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        expect(sut: sut, toRetrieveTwice: .success([exercise]))
    }
    
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesFailure_deliversFailure() throws {
        
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        
        let sut = try makeSut()
        
        expect(sut: sut, toRetrieve: .failure(anyNSError()))
    }
    
    
    func test_coreDataExerciseStore_retrieveAllExercisesFailure_hasNoSideEffects() throws {
        
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        
        let sut = try makeSut()
        
        expect(sut: sut, toRetrieveTwice: .failure(anyNSError()))
    }
    

    func test_coreDataExerciseStore_insertExerciseIntoEmptyCache_deliversNoError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        let insertError = insert(exercise, into: sut)
        
        XCTAssertNil(insertError)
    }
    
    
    func test_coreDataExerciseStore_insertExerciseIntoNonEmptyCache_deliversNoError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let exercise2 = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        let insertError = insert(exercise2, into: sut)
        
        XCTAssertNil(insertError)
    }
    
    
    func test_coreDataExerciseStore_updateExerciseFromEmptyCache_deliversRecordNotFoundError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let updatedExercise = makeUniqueExerciseTuple().local
       
        let updateError = update(exercise, with: updatedExercise, in: sut)

        XCTAssertEqual(updateError as NSError?, CoreDataExerciseStore.Error.recordNotFound(exercise) as NSError?)
    }
    
    
    func test_coreDataExerciseStore_updateExerciseFromEmptyCache_hasNoSideEffects() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let updatedExercise = makeUniqueExerciseTuple().local
        
        update(exercise, with: updatedExercise, in: sut)
        
        expect(sut: sut, toRetrieve: .success([]))
    }
    
    
    func test_coreDataExerciseStore_updateExerciseWhenMatchingExerciseAndUpdatedExerciseAreSame_deliversCannotUpdateDuplicateError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        let updateError = update(exercise, with: exercise, in: sut)
        XCTAssertEqual(updateError as NSError?, CoreDataExerciseStore.Error.cannotUpdateDuplicate(exercise) as NSError?)
    }
    
    
    func test_coreDataExerciseStore_updateExerciseFromNonEmptyCacheWithMatch_deliversNoError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let updatedExercise = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        let updateError = update(exercise, with: updatedExercise, in: sut)
        XCTAssertNil(updateError)
    }
    
    
    func test_coreDataExerciseStore_updateExerciseFromNonEmptyCacheWithNoMatch_deliversNoRecordFoundError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let exerciseNotFound = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        let updateError = update(exerciseNotFound, with: exercise, in: sut)
        XCTAssertEqual(updateError as NSError?, CoreDataExerciseStore.Error.recordNotFound(exerciseNotFound) as NSError?)
    }
    
    
    func test_coreDataExerciseStore_updateExerciseFromNonEmptyCacheWithNoMatch_hasNoSideEffects() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let exerciseNotFound = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        update(exerciseNotFound, with: exercise, in: sut)
        
        expect(sut: sut, toRetrieve: .success([exercise]))
    }
    
    
    func test_coreDataExerciseStore_deleteExerciseFromEmptyCache_deliversNoRecordFoundError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        let deletionError = delete(exercise, from: sut)
        XCTAssertEqual(deletionError as NSError?, CoreDataExerciseStore.Error.recordNotFound(exercise) as NSError?)
    }
    
    
    func test_coreDataExerciseStore_deleteExerciseFromEmptyCache_hasNoSideEffects() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        delete(exercise, from: sut)
        
        expect(sut: sut, toRetrieve: .success([]))
    }
    
    
    func test_coreDataExerciseStore_deleteExerciseFromNonEmptyCacheWithMatch_deliversNoError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        let deletionError = delete(exercise, from: sut)
        XCTAssertNil(deletionError)
        
        expect(sut: sut, toRetrieve: .success([]))
    }
    
    
    func test_coreDataExerciseStore_deleteExerciseFromNonEmptyCacheWithNoMatch_deliversNoRecordFoundError() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        let searchExercise = makeUniqueExerciseTuple().local
        
        insert(exercise, into: sut)
        
        let deletionError = delete(searchExercise, from: sut)
        XCTAssertEqual(deletionError as NSError?, CoreDataExerciseStore.Error.recordNotFound(exercise) as NSError?)
        
        expect(sut: sut, toRetrieve: .success([exercise]))
    }
    
    
    func test_coreDataExerciseStore_serialOperations_runInOrder() throws {
        
        let sut = try makeSut()
        let exercise = makeUniqueExerciseTuple().local
        
        var completedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "Operation 1")
        sut.insert(exercise: exercise) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.delete(exercise: exercise) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(exercise: makeUniqueExerciseTuple().local) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    
    // MARK: - Helpers
    
    private func makeSut() throws -> ExerciseStore {
        
        let bundle = Bundle(for: CoreDataExerciseStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataExerciseStore(storeURL: storeURL, bundle: bundle)
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
    
    
    @discardableResult
    private func update(_ exercise: LocalExercise, with updatedExercise: LocalExercise, in sut: ExerciseStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        
        let exp = expectation(description: "Wait for update completion to finish")
        
        var receivedError: Error?
        
        sut.update(exercise: exercise, with: updatedExercise) { error in

            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedError
    }
    
    
    @discardableResult
    private func delete(_ exercise: LocalExercise, from sut: ExerciseStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        
        let exp = expectation(description: "Wait for deletion completion")
        
        var receivedError: Error?
        
        sut.delete(exercise: exercise) { error in
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
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
                
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
