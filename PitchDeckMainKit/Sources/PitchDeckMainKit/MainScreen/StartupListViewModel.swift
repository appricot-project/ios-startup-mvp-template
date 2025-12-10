//
//  StartupListViewModel.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation
//import Combine

@MainActor
final class StartupListViewModel: ObservableObject {
    
    // MARK: - Enums
    
    struct State {
        enum State: Equatable {
            case idle
            case loading
            case loaded([StartupItem]?, [CategoryItem]?)
        }
        var state = State.idle
    }
    
    enum Event {
        case onDataLoading
    }
    
    // MARK: - Private properties
    
    @Published private(set) var state = State()
    
    //    private var cancellables = Set<AnyCancellable>()
    //    private let api: StartupAPI
    //
    //    init(api: StartupAPI) {
    //        self.api = api
    //    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        switch event {
        case .onDataLoading:
            Task {
                state.state = .loading
                let result = await loadData()
                state.state = .loaded(result.0, result.1)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func loadData() async -> ([StartupItem]?, [CategoryItem]?) {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда
        
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
        
        return (startups, categories)
    }
}
