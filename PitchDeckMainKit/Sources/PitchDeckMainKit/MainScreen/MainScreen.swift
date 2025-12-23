//
//  MainScreen.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit

struct MainScreen: View {
    
    // MARK: - Public properties
    
    @ObservedObject private var viewModel: StartupListViewModel
    @State private var serachText: String = ""
    
    // MARK: - Init
    
    public init(viewModel: StartupListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    // MARK: - Private methods
    
    private var content: some View {
        switch viewModel.state.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading, .serach:
            return LoadingView().eraseToAnyView()
        case .loaded(let startUps, let categories, let hasMore):
            return main(filteredStartups: startUps, categories: categories, hasMore: hasMore).eraseToAnyView()
        case .loadingMore:
            return LoadingView().eraseToAnyView()
        case .error(let error):
            print(error)
            return main().eraseToAnyView()
        }
    }
    
    private func main(filteredStartups: [StartupItem]? = nil, categories: [CategoryItem]? = nil, hasMore: Bool = false) -> some View {
        NavigationView {
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        VStack(spacing: 10) {
                            SearchBar(text: $serachText) { text in
                                viewModel.send(event: .onSerach(text))
                            } onTextDeleted: {
                                viewModel.send(event: .onAppear)
                            }
                            CategoryRow(categories: categories ?? [])
                        }
                        .background(Color(.systemBackground))
                    }
                    .padding(.bottom, 10)
                    Section {
                        VStack(spacing: 12) {
                            if let items = filteredStartups {
                                ForEach(items) { item in
                                    StartupRow(item: item)
                                        .onAppear {
                                            let itemIndex = items.firstIndex(where: { $0.id == item.id }) ?? 0
                                            if itemIndex == items.count - 1, hasMore {
                                                viewModel.send(event: .onLoadingMore)
                                            }
                                        }
                                }
                            } else {
                                Text("No available")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Startups")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}


//
//    private var filteredStartups: [StartupItem] {
//        if let selected = vm.selectedCategory {
//            return vm.startups.filter { $0.category == selected }
//        } else {
//            return vm.startups
//        }
//    }
