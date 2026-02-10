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
    let onEditTapped: ((String) -> Void)?
    let onDeleteSuccess: (() -> Void)?
    
    @State private var showDeleteAlert: Bool = false
    
    // MARK: - Init
    
    public init(
        viewModel: StartupDetailViewModel,
        onEditTapped: ((String) -> Void)? = nil,
        onDeleteSuccess: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.onEditTapped = onEditTapped
        self.onDeleteSuccess = onDeleteSuccess
    }
    
    var body: some View {
        content
            .background(Color(UIColor.globalBackgroundColor))
            .onAppear { 
                self.viewModel.send(event: .onAppear)
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                ShareSheet(activityItems: viewModel.shareStartup())
            }
            .alert(
                "startups.details.delete.alert.title".localized,
                isPresented: $showDeleteAlert
            ) {
                Button("common.cancel".localized, role: .cancel) {
                    showDeleteAlert = false
                }
                Button("startups.details.delete.alert.confirm".localized, role: .destructive) {
                    showDeleteAlert = false
                    viewModel.send(event: .onDeleteTapped)
                }
            } message: {
                Text("startups.details.delete.alert.message".localized)
            }
            .onChange(of: viewModel.didDeleteStartup) { didDelete in
                if didDelete {
                    onDeleteSuccess?()
                }
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
        VStack(spacing: 0) {
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
                                    .cornerRadius(16)
                            case .empty, .failure:
                                placeholderImage
                            @unknown default:
                                placeholderImage
                            }
                        }
                        .frame(height: 250)
                        .padding(.horizontal, 16)
                    } else {
                        placeholderImage
                    }
                    
                    VStack {
                        HStack(spacing: 8) {
                            Text(item.category)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("•")
                                .foregroundColor(.secondary)
                            Text(item.location)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    Text(item.description ?? "startups.details.empty.description".localized)
                        .font(.body)
                        .lineSpacing(6)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            .navigationTitle(item.title)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isOwner() {
                        Button(action: {
                            if let documentId = viewModel.startupItem?.documentId {
                                onEditTapped?(documentId)
                            }
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            VStack(spacing: 16) {
                PrimaryButton("startups.details.button.title".localized) {
                    viewModel.send(event: .onShareTapped)
                }
                
                if viewModel.isOwner() {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Text("startups.details.delete.button.title".localized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(UIColor.globalBackgroundColor))
        }
    }
    
    var placeholderImage: some View {
        Rectangle()
            .fill(Color(uiColor: .globalCellSeparatorColor))
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            )
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
    }
}
