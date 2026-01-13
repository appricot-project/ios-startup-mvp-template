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
    
    // MARK: - Private properties
    
    @ObservedObject private var viewModel: StartupDetailViewModel
    
    // MARK: - Init
    
    public init(viewModel: StartupDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .background(Color(UIColor.globalBackgroundColor))
            .onAppear { self.viewModel.send(event: .onAppear) }
            .sheet(isPresented: $viewModel.showShareSheet) {
                ShareSheet(activityItems: viewModel.shareStartup())
            }
    }
    
    // MARK: - Private methods
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            Text(String(format: "startups.details.error.title".localized, error))
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        } else if let item = viewModel.startupItem {
            mainContent(item: item)
        } else {
            Text("startups.details.empty.title".localized)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func mainContent(item: StartupItem) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                if let imageURL = item.image,
                   !imageURL.isEmpty,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .empty, .failure:
                            placeholderImage
                        @unknown default:
                            placeholderImage
                        }
                    }
                    .frame(width: 250, height: 250)
                    .cornerRadius(16)
                    .padding(.horizontal)
                } else {
                    placeholderImage
                }
                
                VStack {
                    HStack(spacing: 8) {
                        Text(item.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("•")
                            .foregroundStyle(.secondary)
                        Text(item.location)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Text(item.description ?? "startups.details.empty.description".localized)
                    .font(.body)
                    .lineSpacing(6)
                    .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top, 10)
        }
        .navigationTitle(item.title)
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("startups.details.button.title".localized) {
                viewModel.send(event: .onShareTapped)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(UIColor.globalBackgroundColor))
        }
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color(uiColor: .grayD7))
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            )
            .frame(width: 250, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
