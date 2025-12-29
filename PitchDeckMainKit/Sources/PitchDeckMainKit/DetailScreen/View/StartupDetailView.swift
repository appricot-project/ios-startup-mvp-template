//
//  StartupDetailView.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit

struct StartupDetailView: View {
    
    // MARK: - Public properties
    
    @ObservedObject private var viewModel: StartupDetailViewModel
    
    // MARK: - Init
    
    public init(viewModel: StartupDetailViewModel) {
        self.viewModel = viewModel
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
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().eraseToAnyView()
        case .loaded(let startupItem):
            return main(startupItem: startupItem).eraseToAnyView()
        case .error(let error):
            print(error)
            return Text("Error loading details").eraseToAnyView()
        }
    }
    
    private func main(startupItem: StartupItem) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                if let imageURL = startupItem.image, !imageURL.isEmpty, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure, .empty:
                            placeholderImage
                        @unknown default:
                            placeholderImage
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                VStack {
                    HStack(spacing: 8) {
                        Text(startupItem.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("•")
                            .foregroundStyle(.secondary)
                        Text(startupItem.location)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Text(startupItem.description ?? "No description available.")
                    .font(.body)
                    .lineSpacing(6)
                    .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top, 10)
        }
        .navigationTitle(startupItem.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            )
    }
}
