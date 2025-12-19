//
//  MainScreen.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckUIKit

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
        case .loading:
            return LoadingView().eraseToAnyView()
        case .loaded(let startUps, let categories):
            return main(filteredStartups: startUps, categories: categories).eraseToAnyView()
        case .error(let error):
            print(error)
            return main().eraseToAnyView()
        }
    }

    private func main(filteredStartups: [StartupItem]? = nil, categories: [CategoryItem]? = nil) -> some View {
        NavigationView {
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        VStack(spacing: 10) {
                            SearchBar(text: $serachText) { text in
                                print(text)
                            }
                            CategoryRow(categories: categories ?? [])
                        }
                        .background(Color(.systemBackground))
                    }
                    .padding(.bottom, 10)
                    Section {
                        VStack(spacing: 12) {
                            ForEach(filteredStartups ?? []) { item in
                                StartupRow(item: item)
//                                    .padding(.vertical, 2)
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

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}



//
//    private var filteredStartups: [StartupItem] {
//        if let selected = vm.selectedCategory {
//            return vm.startups.filter { $0.category == selected }
//        } else {
//            return vm.startups
//        }
//    }


extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                           to: nil,
                                           from: nil,
                                           for: nil)
        }
    }
    
    func hideKeyboardOnTapBackground() -> some View {
        self.background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                   to: nil,
                                                   from: nil,
                                                   for: nil)
                }
        )
    }
}
