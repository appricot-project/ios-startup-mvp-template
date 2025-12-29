//
//  StartupsView.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit

struct StartupsView: View {
    
    // MARK: - Private properties
    
    @ObservedObject private var viewModel: StartupListViewModel
    @State private var serachText: String = ""
    
    // MARK: - Public properties
    
    let onStartupSelected: (String) -> Void
    
    // MARK: - Init
    
    public init(
        viewModel: StartupListViewModel, onStartupSelected: @escaping (String) -> Void) {
            self.viewModel = viewModel
            self.onStartupSelected = onStartupSelected
        }
    
    var body: some View {
        content
            .background(Color(UIColor.globalBackgroundColor))
            .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    // MARK: - Private methods
    
    private var content: some View {
        switch viewModel.state.state {
        case .idle:
            return Color.white.eraseToAnyView()
        case .loading, .serach:
            return LoadingView().eraseToAnyView()
        case .loaded(let startUps, let categories, let selectedCategoryId, let hasMore):
            return main(
                filteredStartups: startUps,
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                hasMore: hasMore,
                onStartupSelected: onStartupSelected
            ).eraseToAnyView()
        case .loadingMore:
            return LoadingView().eraseToAnyView()
        case .error(let error):
            print(error)
            return main(onStartupSelected: onStartupSelected).eraseToAnyView()
        }
    }
    
    private func main(
        filteredStartups: [StartupItem]? = nil,
        categories: [CategoryItem]? = nil,
        selectedCategoryId: Int? = nil,
        hasMore: Bool = false,
        onStartupSelected: @escaping (String) -> Void
    ) -> some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    VStack {
                        SearchBar(text: $serachText) { text in
                            if text == "" {
                                viewModel.send(event: .onAppear)
                            } else {
                                viewModel.send(event: .onSerach(text))
                            }
                        }
                        CategoryRow(
                            categories: categories ?? [],
                            selectedCategoryId: selectedCategoryId,
                            onCategoryChanged: { id in
                                viewModel.send(event: .onSelectedCategory(id))
                            }
                        )
                    }
                    .background(Color(UIColor.globalBackgroundColor))
                }
                .padding(.bottom, 8)
                
                Section {
                    VStack(spacing: 12) {
                        if let items = filteredStartups {
                            ForEach(items) { item in
                                StartupRow(item: item) {
                                    onStartupSelected(item.documentId)
                                }
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
                    .background(Color(UIColor.globalBackgroundColor))
                }
            }
        }
        .navigationTitle("Startups")
        .toolbarTitleDisplayMode(.inline)
    }
}
