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
            case loading(Int)
            case loaded([StartupItem], [CategoryItem]?, Bool)
            case loadingMore(Int)
            case error(String)
            case serach(String, Int)
        }
        
        var state = State.idle
        var currentPage: Int = 1
        var statups: [StartupItem] = []
        var categories: [CategoryItem] = []
        var hasMore: Bool = false
        var searchText: String? = nil
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
        case (_, .onAppear):
            var newState = state
            newState.currentPage = 1
            newState.state = .loading(newState.currentPage)
            return newState
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
            if text != state.searchText {
                var newState = state
                newState.currentPage = 1
                newState.searchText = text
                newState.state = .serach(text, 1)
                return newState
            } else {
                return state
            }
        case (_, .onLoadedSerch(let items)):
            var newState = state
            newState.statups = items
            newState.hasMore = false
            newState.state = .loaded(items, newState.categories, false)
            return newState
        }
    }

    @MainActor
    private static func whenLoading(service: StartupService) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            switch state.state {
            case .loading(let currentPage):
                return Self.loadData(service: service, page: currentPage)
                    .map { Event.onLoaded($0.0, $0.1, $0.2) }
                    .catch { Just(Event.onError($0.localizedDescription)) }
                    .eraseToAnyPublisher()
            case .loadingMore(let currentPage):
                return Self.loadData(service: service, page: currentPage)
                    .map { Event.onLoadedMore($0.0, $0.2) }
                    .catch { Just(Event.onError($0.localizedDescription)) }
                    .eraseToAnyPublisher()
            case .serach(let text, let currentPage):
                return Self.searchStartup(service: service, title: text, page: currentPage)
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
                        async let startupsTask = service.startups(title: nil, page: page, pageSize: pageSize)
                        async let categoriesTask = service.startupsCategoris()
                        let (startups, categories) = try await (startupsTask, categoriesTask)
                        let hasMore = startups.count == pageSize
                        promise(.success((startups, categories, hasMore)))
                    } else {
                        let startups = try await service.startups(title: nil, page: page, pageSize: pageSize)
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
    private static func searchStartup(service: StartupService, title: String, page: Int) -> AnyPublisher<([StartupItem]), BaseServiceError> {
        Future { promise in
            Task {
                do {
                    let startups = try await service.startups(title: title, page: page, pageSize: pageSize)
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
