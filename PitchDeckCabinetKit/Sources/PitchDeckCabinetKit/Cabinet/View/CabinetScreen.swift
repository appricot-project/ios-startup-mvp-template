//
//  CabinetScreen.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit

public struct CabinetScreen: View {
    
    @ObservedObject private var viewModel: CabinetViewModel
    let coordinator: CabinetCoordinator
    
    public init(viewModel: CabinetViewModel, coordinator: CabinetCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    profileSection
                    startupsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .navigationTitle("cabinet.title".localized)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.send(event: .onAppear)
            }
            .onChange(of: viewModel.didLogout) { didLogout in
                if didLogout {
                    NotificationCenter.default.post(name: NSNotification.Name("UserDidLogout"), object: nil)
                    viewModel.didLogout = false
                }
            }
        }
    }
    
    // MARK: - Private views
    
    private var logoutButtonCompact: some View {
        Button(action: {
            viewModel.send(event: .logout)
        }) {
            HStack {
                Image(systemName: "arrow.right.square")
                    .font(.caption)
                Text("cabinet.logout".localized)
                    .font(.caption)
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .foregroundColor(.red)
            .padding(.vertical, 8)
        }
        .disabled(viewModel.isLoading)
    }
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("cabinet.profile.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                profileField(title: "cabinet.profile.firstName".localized, value: viewModel.userProfile?.firstName ?? "")
                profileField(title: "cabinet.profile.lastName".localized, value: viewModel.userProfile?.lastName ?? "")
                profileField(title: "cabinet.profile.email".localized, value: viewModel.userProfile?.email ?? "")
                
                Divider()
                
                logoutButtonCompact
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var startupsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("cabinet.startups.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if viewModel.userStartups.isEmpty {
                VStack(spacing: 16) {
                    Text("cabinet.startups.empty".localized)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    PrimaryButton("cabinet.startups.create".localized) {
                        coordinator.push(.createStartup)
                    }
                }
                .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.userStartups) { startup in
                        StartupRow(startup: startup)
                            .onTapGesture {
                                coordinator.push(.details(documentId: startup.documentId))
                            }
                    }
                    
                    PrimaryButton("cabinet.startups.create".localized) {
                        coordinator.push(.createStartup)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func profileField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Supporting Views

private struct StartupRow: View {
    let startup: StartupItem
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageURL = startup.image, !imageURL.isEmpty, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty, .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(startup.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(startup.description ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(startup.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
    }
}
