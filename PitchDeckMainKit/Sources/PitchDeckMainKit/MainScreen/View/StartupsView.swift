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
                if viewModel.isInitialLoading {
                    viewModel.send(event: .onAppear)
                }
            }
            .onAppear {
                if viewModel.needsRefresh {
                    viewModel.needsRefresh = false
                    viewModel.send(event: .onRefresh)
                }
            }
    }
    
    // MARK: - Private methods
    
    private var content: some View {
        if viewModel.isInitialLoading || (viewModel.isLoading && viewModel.startups.isEmpty) {
            return LoadingView().eraseToAnyView()
        } else if let error = viewModel.errorMessage {
            return Text(String(format: "startups.error.title".localized, error)).foregroundColor(.red).eraseToAnyView()
        } else {
            return mainList.eraseToAnyView()
        }
    }
    
    private var mainList: some View {
        ScrollViewReader { proxy in
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
                                if viewModel.isLoading {
                                    ProgressView()
                                        .padding()
                                } else {
                                    Text("startups.empty.title".localized)
                                }
                            } else {
                                ForEach(viewModel.startups) { item in
                                    StartupRow(item: item) {
                                        viewModel.lastViewedStartupId = item.id
                                        onStartupSelected(item.documentId)
                                    }
                                    .id(item.id)
                                }
                                GeometryReader { geometry in
                                    Color.clear
                                        .preference(
                                            key: ViewOffsetKey.self,
                                            value: geometry.frame(in: .named("scrollView")).minY
                                        )
                                }
                                .frame(height: 20)
                                
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
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ViewOffsetKey.self) { offset in
                if offset < UIScreen.main.bounds.height,
                   viewModel.hasMore,
                   !viewModel.isLoadingMore,
                   !viewModel.isLoading {
                    viewModel.send(event: .onLoadMore)
                }
            }
            .navigationTitle("startups.title".localized)
            .toolbarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.send(event: .onRefresh)
            }
            .onChange(of: viewModel.startups) { _ in
                if let id = viewModel.lastViewedStartupId,
                   !viewModel.isLoading,
                   !viewModel.startups.isEmpty {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                        viewModel.lastViewedStartupId = nil
                    }
                }
            }
        }
    }
}
