//
//  MainScreen.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI

struct MainScreen: View {
    
    // MARK: - Public properties
    
    @StateObject private var viewModel: StartupListViewModel
    
    // MARK: - Init
    
    public init(viewModel: StartupListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .onAppear { self.viewModel.send(event: .onDataLoading) }
    }
    
    // MARK: - Private methods
    
    private var content: some View {
        switch viewModel.state.state {
        case .idle:
            return main().eraseToAnyView()
        case .loading:
            return ProgressView("Loading").eraseToAnyView()
        case .loaded(let startUps, let categories):
            return main().eraseToAnyView()
        }
    }
    
    private func main(filteredStartups: [StartupItem]? = nil,categories: [CategoryItem]? = nil, selectedCategory: CategoryItem? = nil) -> some View {
        VStack(spacing: 0) {
            CategoryRow(categories: categories ?? [])
            List(filteredStartups ?? []) { item in
                StartupRow(item: item)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Title")
    }
    //
    //    private var filteredStartups: [StartupItem] {
    //        if let selected = vm.selectedCategory {
    //            return vm.startups.filter { $0.category == selected }
    //        } else {
    //            return vm.startups
    //        }
    //    }
}


extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
