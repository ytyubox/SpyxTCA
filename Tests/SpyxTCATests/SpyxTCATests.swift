import ComposableArchitecture
import SpyxTCA
import XCTest

final class SpyxTCATests: XCTestCase {
  func test() throws {
    let spy = Spy()
    let store = TestStore(initialState: Load(), reducer: reducer, environment: spy.makeEnvironment())

    store.send(.load) {
      $0.description = "loading"
    }

    spy.response("any response")

    store.receive(.receive(.success("any response"))) {
      $0.description = "any response"
    }
  }

  func testFail() throws {
    let spy = Spy()
    let store = TestStore(initialState: Load(), reducer: reducer, environment: spy.makeEnvironment())

    store.send(.load) {
      $0.description = "loading"
    }
    let error = LoadError(errorDescription: "something went wrong")
    spy.response(error)

    store.receive(.receive(.failure(error))) {
      $0 = Load()
    }
  }

  func testTimeout() throws {
    let spy = Spy()
    let store = TestStore(initialState: Load(), reducer: reducer, environment: spy.makeEnvironment())

    store.send(.load) {
      $0.description = "loading"
    }
    spy.scheduler.run()
    let error = LoadError(errorDescription: "timeout")

    store.receive(.receive(.failure(error))) {
      $0 = Load()
    }
  }
}

final class Spy {
  private var attemptToFulfill: ((Result<String, LoadError>) -> Void)?
  func response(_ stub: String) {
    attemptToFulfill?(.success(stub))
    attemptToFulfill = nil
    adv()
  }

  func response(_ error: LoadError) {
    attemptToFulfill?(.failure(error))
    attemptToFulfill = nil
    adv()
  }
  private func adv() {
    scheduler.advance(by: 0.00000000000001)
  }

  var scheduler = DispatchQueue.test
  func makeEnvironment() -> Environment {
    Environment(load: {
      Effect.future { callback in
        self.attemptToFulfill = { result in
          callback(result.mapError { $0 })
        }
      }
    }, scheduler: scheduler.eraseToAnyScheduler())
  }
}
