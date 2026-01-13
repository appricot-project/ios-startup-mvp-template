//
//  System.swift
//  PitchDeckCoreKit
//
//  Created by Anton Redkozubov on 11.12.2025.
//

import Combine

public extension Publishers {
    
    static func system<State, Event, Scheduler: Combine.Scheduler>(
        initial: State,
        reduce: @escaping (State, Event) -> State,
        scheduler: Scheduler,
        feedbacks: [Feedback<State, Event>]
    ) -> AnyPublisher<State, Never> {
        
        let state = CurrentValueSubject<State, Never>(initial)
        let events = feedbacks.map { feedback in feedback.run(state.eraseToAnyPublisher()) }
        
        return Deferred {
            Publishers.MergeMany(events)
                .receive(on: scheduler)
                .scan(initial, reduce)
                .handleEvents(receiveOutput: state.send)
                .receive(on: scheduler)
                .prepend(initial)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Self.Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: WritableKeyPath<Root, Self.Output>, weakly object: Root) -> AnyCancellable {
        return self.sink { [weak object] output in
            object?[keyPath: keyPath] = output
        }
    }
}
