//
//  StartupListViewModel.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation
import Combine
import PitchDeckCoreKit
import PitchDeckMainApiKit

final class StartupListViewModel: ObservableObject {

    // MARK: - Private properties

    @Published private(set) var state = State(state: .idle)
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    private let service: StartupService

    // MARK: - Init

    @MainActor
    init(service: StartupService) {
        self.service = service
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(service: service),
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
            case loaded([StartupItem], [CategoryItem]?, Bool)
            case loadingMore(Int)
            case error(String)
            case serach(String)
        }
        
        var state = State.idle
        var currentPage: Int = 1
        var statups: [StartupItem] = []
        var categories: [CategoryItem] = []
        var hasMore: Bool = false
    }

    enum Event {
        case onAppear
        case onLoaded([StartupItem], [CategoryItem]?, Bool)
        case onLoadingMore
        case onLoadedMore([StartupItem], Bool)
        case onError(String)
        case onSerach(String)
        case onLoadedSerch([StartupItem])
    }
    
    static let pageSize = 10
}

// MARK: - State Machine

extension StartupListViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch (state.state, event) {
        case (.idle, .onAppear):
            return State(state: .loading)
        case (_, .onLoaded(let items, let categories, let hasMore)):
            var newState = state
            newState.currentPage += 1
            newState.statups = items
            newState.categories = categories ?? []
            newState.hasMore = hasMore
            newState.state = .loaded(items, categories, hasMore)
            return newState
        case (_, .onLoadingMore):
            var newState = state
            guard newState.hasMore else { return state }
            newState.state = .loadingMore(newState.currentPage)
            return newState
        case (_, .onLoadedMore(let newItems, let hasMore)):
            var newState = state
            let items = newState.statups + newItems
            newState.statups = items
            newState.hasMore = hasMore
            newState.state = .loaded(items, newState.categories, hasMore)
            return newState
        case (_, .onError(let error)):
            return State(state: .error(error))
        case (_, .onSerach(let text)):
            var newState = state
            newState.currentPage = 1
            newState.state = .serach(text)
            return newState
        case (_, .onLoadedSerch(let items)):
            var newState = state
            newState.statups = items
            newState.hasMore = false
            newState.state = .loaded(items, newState.categories, false)
            return newState
        default:
            return state
        }
    }

    @MainActor
    private static func whenLoading(service: StartupService) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            switch state.state {
            case .loading:
                return Self.loadData(service: service, page: 1)
                    .map { Event.onLoaded($0.0, $0.1, $0.2) }
                    .catch { Just(Event.onError($0.localizedDescription)) }
                    .eraseToAnyPublisher()
            case .loadingMore(let currentPage):
                return Self.loadData(service: service, page: currentPage)
                    .map { Event.onLoadedMore($0.0, $0.2) }
                    .catch { Just(Event.onError($0.localizedDescription)) }
                    .eraseToAnyPublisher()
            case .serach(let text):
                return Self.searchStartup(service: service, filter: text)
                    .map { Event.onLoadedSerch($0) }
                    .catch { Just(Event.onError($0.localizedDescription)) }
                    .eraseToAnyPublisher()
            default:
                return Empty().eraseToAnyPublisher()
            }
        }
    }
    
    @MainActor
    private static func loadData(service: StartupService, page: Int) -> AnyPublisher<([StartupItem], [CategoryItem]?, Bool), BaseServiceError> {
        Future { promise in
            Task {
                do {
                    if page == 1 {
                        async let startupsTask = service.startups(page: page, pageSize: pageSize)
                        async let categoriesTask = service.startupsCategoris()
                        let (startups, categories) = try await (startupsTask, categoriesTask)
                        let hasMore = startups.count == pageSize
                        promise(.success((startups, categories, hasMore)))
                    } else {
                        let startups = try await service.startups(page: page, pageSize: pageSize)
                        let hasMore = startups.count == pageSize
                        promise(.success((startups, nil, hasMore)))
                    }
                } catch {
                    promise(.failure(error as? BaseServiceError ?? .custom(error.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    @MainActor
    private static func searchStartup(service: StartupService, filter: String) -> AnyPublisher<([StartupItem]), BaseServiceError> {
        Future { promise in
            Task {
                do {
                    let startups = try await service.serchStartup(filter: filter, page: 1, pageSize: pageSize)
//                    let hasMore = startups.count == pageSize
                    promise(.success(startups))
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
