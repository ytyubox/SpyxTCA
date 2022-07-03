import ComposableArchitecture

public struct Load: Equatable {
  public var description: String

  public init(description: String) {
    self.description = description
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

public let reducer = Reducer<Load, LoadAction, Environment> { _, action, _ in
  switch action {
    case .load:
      return .none
    case .receive(let result):
      return .none
  }
}
