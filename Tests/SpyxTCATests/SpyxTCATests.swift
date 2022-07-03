import ComposableArchitecture
import SpyxTCA
import XCTest

final class SpyxTCATests: XCTestCase {
  func test() throws {
    let store = TestStore(initialState: Load(description: "any string"), reducer: reducer, environment: Environment { .none })
    
  }
}
