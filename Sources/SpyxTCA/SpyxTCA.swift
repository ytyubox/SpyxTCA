import ComposableArchitecture

public struct Load: Equatable {
  public var description: String

  public init() {
    self.description = "hello world!"
  }
}

public enum LoadAction: Equatable {
  case load
  case receive(Result<String, LoadError>)
}

public struct LoadError: LocalizedError, Equatable {
  public init(errorDescription: String? = nil) {
    self.errorDescription = errorDescription
  }

  public var errorDescription: String?
}

public struct Environment {
  public var load: () -> Effect<String, Error>

  public init(load: @escaping () -> Effect<String, Error>) {
    self.load = load
  }
}

public let reducer = Reducer<Load, LoadAction, Environment> { state, action, environment in
  switch action {
    case .load:
      state.description = "loading"
      return environment.load()
        .catchToEffect()
        .map { result in
          LoadAction.receive(result.mapError { LoadError(errorDescription: $0.localizedDescription) })
        }
    case let .receive(.success(result)):
      state.description = result
      return .none
    case .receive(.failure(_)):
      state = Load()
      return .none
  }
}
