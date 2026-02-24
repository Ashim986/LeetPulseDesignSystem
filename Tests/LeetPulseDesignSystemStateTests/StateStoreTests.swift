import XCTest
@testable import LeetPulseDesignSystemState

final class StateStoreTests: XCTestCase {
    struct CounterReducer: ReducerProtocol {
        mutating func reduce(state: inout Int, event: CounterEvent) {
            switch event {
            case .increment: state += 1
            case .decrement: state -= 1
            case .set(let value): state = value
            }
        }
    }

    enum CounterEvent {
        case increment
        case decrement
        case set(Int)
    }

    func testStateStoreAppliesEvents() {
        let store = StateStore(initial: 0, reducer: CounterReducer())
        store.send(.increment)
        XCTAssertEqual(store.state, 1)
        store.send(.decrement)
        XCTAssertEqual(store.state, 0)
        store.send(.set(10))
        XCTAssertEqual(store.state, 10)
    }
}
