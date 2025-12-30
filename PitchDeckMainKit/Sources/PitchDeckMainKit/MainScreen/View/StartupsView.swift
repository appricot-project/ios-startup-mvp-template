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
    @State private var searchText: String = ""
    
    let onStartupSelected: (String) -> Void
    
    // MARK: - Init
    
    public init(
        viewModel: StartupListViewModel,
        onStartupSelected: @escaping (String) -> Void
    ) {
        self.viewModel = viewModel
        self.onStartupSelected = onStartupSelected
    }
    
    var body: some View {
        content
            .background(Color(UIColor.globalBackgroundColor))
            .task {
                viewModel.send(event: .onAppear)
            }
    }
    
    // MARK: - Private methods
    
    private var content: some View {
        if viewModel.isInitialLoading || (viewModel.isLoading && viewModel.startups.isEmpty) {
            return LoadingView().eraseToAnyView()
        } else if let error = viewModel.errorMessage {
            return Text("Error: \(error)").foregroundColor(.red).eraseToAnyView()
        } else {
            return mainList.eraseToAnyView()
        }
    }
    
    private var mainList: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    VStack {
                        SearchBar(text: $searchText) { text in
                            viewModel.send(event: .onSearch(text))
                        }
                        
                        CategoryRow(
                            categories: viewModel.categories,
                            selectedCategoryId: viewModel.selectedCategoryId,
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
                        if viewModel.startups.isEmpty {
                            Text("No available")
                        } else {
                            ForEach(viewModel.startups) { item in
                                StartupRow(item: item) {
                                    onStartupSelected(item.documentId)
                                }
                                .onAppear {
                                    if item.id == viewModel.startups.last?.id && viewModel.hasMore {
                                        viewModel.send(event: .onLoadMore)
                                    }
                                }
                            }
                            if viewModel.isLoadingMore {
                                ProgressView()
                                    .padding()
                            }
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
