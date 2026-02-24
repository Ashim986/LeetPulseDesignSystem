import Combine

public protocol ReducerProtocol {
    associatedtype State
    associatedtype Event

    mutating func reduce(state: inout State, event: Event)
}

public final class StateStore<R: ReducerProtocol>: ObservableObject {
    @Published public private(set) var state: R.State
    private var reducer: R

    public init(initial: R.State, reducer: R) {
        self.state = initial
        self.reducer = reducer
    }

    public func send(_ event: R.Event) {
        reducer.reduce(state: &state, event: event)
    }
}
