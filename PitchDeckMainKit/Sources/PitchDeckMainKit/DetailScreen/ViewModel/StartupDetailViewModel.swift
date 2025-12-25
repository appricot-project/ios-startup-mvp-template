//
//  StartupDetailViewModel.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 25.12.2025.
//

import Foundation
import Combine
import PitchDeckCoreKit
import PitchDeckMainApiKit

final class StartupDetailViewModel: ObservableObject {
    
    // MARK: - Private properties
    
    @Published private(set) var state = State(state: .idle)
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    private let service: StartupService
    private let documentId: String
    
    // MARK: - Init
    
    @MainActor
    init(documentId: String, service: StartupService) {
        self.documentId = documentId
        self.service = service
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(service: service, documentId: documentId),
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

extension StartupDetailViewModel {
    
    struct State {
        enum State: Equatable {
            case idle
            case loading
            case loaded(StartupItem)
            case error(String)
        }
        
        var state = State.idle
        var startupItem: StartupItem?
    }
    
    enum Event {
        case onAppear
        case onLoaded(StartupItem)
        case onError(String)
    }
}

// MARK: - State Machine

extension StartupDetailViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch (state.state, event) {
        case (_, .onAppear):
            var newState = state
            newState.state = .loading
            return newState
        case (_, .onLoaded(let item)):
            var newState = state
            newState.startupItem = item
            newState.state = .loaded(item)
            return newState
        case (_, .onError(let error)):
            return State(state: .error(error))
        }
    }
    
    @MainActor
    private static func whenLoading(service: StartupService, documentId: String) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            switch state.state {
            case .loading:
                return Self.loadDetail(service: service, documentId: documentId)
                    .map { Event.onLoaded($0) }
                    .catch { Just(Event.onError($0.localizedDescription)) }
                    .eraseToAnyPublisher()
            default:
                return Empty().eraseToAnyPublisher()
            }
        }
    }
    
    @MainActor
    private static func loadDetail(service: StartupService, documentId: String) -> AnyPublisher<StartupItem, BaseServiceError> {
        Future { promise in
            Task {
                do {
                    let item = try await service.getStartup(documentId: documentId)
                    promise(.success(item))
                } catch {
                    promise(.failure(error as? BaseServiceError ?? .custom(error.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
