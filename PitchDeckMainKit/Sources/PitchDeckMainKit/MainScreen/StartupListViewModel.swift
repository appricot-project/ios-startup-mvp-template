//
//  StartupListViewModel.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation
import Combine
import PitchDeckCoreKit

final class StartupListViewModel: ObservableObject {

    // MARK: - Private properties

    @Published private(set) var state = State(state: .idle)
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()

    // MARK: - Init

    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, weakly: self)
        .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    // MARK: - Public methods
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner types

extension StartupListViewModel {

    struct State {
        enum State: Equatable {
            case idle
            case loading
            case loaded([StartupItem]?, [CategoryItem]?)
            case error(String)
        }
        
        var state = State.idle
    }

    enum Event {
        case onAppear
        case onLoaded([StartupItem]?, [CategoryItem]?)
        case onError(String)
    }
}

// MARK: - State Machine

extension StartupListViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch (state.state, event) {
        case (.idle, .onAppear):
            return State(state: .loading)
        case (_, .onLoaded(let items, let categories)):
            return State(state: .loaded(items, categories))
        case (_, .onError(let error)):
            return State(state: .error(error))
        default:
            return state
        }
    }

    private static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state.state else { return Empty().eraseToAnyPublisher() }
            return Self.loadData()
                .map { Event.onLoaded($0.0, $0.1) }
                .catch { Just(Event.onError($0.localizedDescription)) }
                .eraseToAnyPublisher()
        }
    }

    private static func loadData() -> AnyPublisher<([StartupItem]?, [CategoryItem]?), BaseServiceError> {
        return Future() { promise in
            do {
                let categories: [CategoryItem] = [
                    .init(id: "1", title: "AI"),
                    .init(id: "2", title: "Fintech"),
                    .init(id: "3", title: "Health")
                ]

                let startups: [StartupItem] = [
                    .init(id: "1", title: "NeuroGen", description: "New AI Startup", image: nil, category: "AI", location: "Moscow" ),
                    .init(id: "2", title: "HeartWell", description: "New AI Startup", image: nil, category: "Health", location: "London" ),
                    .init(id: "3", title: "PayWave", description: "New AI Startup", image: nil, category: "Fintech", location: "Vashington" ),
                    .init(id: "4", title: "NeuroPhoto", description: "New AI Startup", image: nil, category: "AI", location: "Moscow" ),
                    .init(id: "5", title: "NewLife", description: "New AI Startup", image: nil, category: "Health", location: "Vashington" ),
                    .init(id: "6", title: "PayWithoutCard", description: "New AI Startup", image: nil, category: "Fintech", location: "London" ),
                    .init(id: "7", title: "GPT-999", description: "New AI Startup", image: nil, category: "AI", location: "Moscow" ),
                    .init(id: "8", title: "Free Life", description: "New AI Startup", image: nil, category: "Health", location: "Moscow" ),
                    .init(id: "9", title: "AI-GPT", description: "New AI Startup", image: nil, category: "AI", location: "Moscow" ),
                    .init(id: "10", title: "Free Life", description: "New AI Startup", image: nil, category: "Health", location: "Moscow" ),
                ]

                let result = (startups, categories)
                promise(Result<([StartupItem]?, [CategoryItem]?) , BaseServiceError>.success(result))
            } catch {
                promise(Result<([StartupItem]?, [CategoryItem]?), BaseServiceError>.failure(error as? BaseServiceError ?? BaseServiceError.custom(error.localizedDescription)))
            }
        }.delay(for: .seconds(2), scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
