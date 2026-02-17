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
        ScrollView {
            VStack(spacing: 24) {
                if let item = viewModel.startupItem {
                    mainContent(item: item)
                } else {
                    emptyStateView
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationTitle(viewModel.startupItem?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
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
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        .overlay {
            if viewModel.isLoading == true {
                LoadingView()
            } else if let error = viewModel.errorMessage {
                errorView(error: error)
            }
        }
    }
    
    // MARK: - Private methods
    
    private var emptyStateView: some View {
        Text("startups.details.empty.title".localized)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(error: String) -> some View {
        Text(String(format: "startups.details.error.title".localized, error))
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
    }
    
    private func mainContent(item: StartupItem) -> some View {
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
                    .padding(.horizontal, 16)
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
                .frame(minHeight: 100)
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
