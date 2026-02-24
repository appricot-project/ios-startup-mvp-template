//
//  StartupDetailViewModel.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 25.12.2025.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckMainApiKit

@MainActor
final class StartupDetailViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var startupItem: StartupItem?
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var showShareSheet: Bool = false
    @Published public var didDeleteStartup: Bool = false
    
    // MARK: - Private properties
    
    private let documentId: String
    private let service: StartupService
    private var loadTask: Task<Void, Never>? = nil
    private var currentUserEmail: String
    
    // MARK: - Init
    
    init(documentId: String, service: StartupService, currentUserEmail: String = "") {
        self.documentId = documentId
        self.service = service
        if !currentUserEmail.isEmpty {
            self.currentUserEmail = currentUserEmail
        } else {
            self.currentUserEmail = ""
        }
    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .onShareTapped:
                didTapShare()
            case .onDeleteTapped:
                await handleDelete()
            case .onEditTapped:
                break
            }
        }
    }
    
    func isOwner() -> Bool {
        return startupItem?.ownerEmail == currentUserEmail
    }
    
    func shareStartup() -> [Any] {
        guard let item = startupItem else { return [] }
        let shareText = "Check out this startup: \(item.title)"
        let shareURL = URL(string: "https://example.com/startup/\(item.id)")!
        return [shareText, shareURL]
    }
    
    // MARK: - Private methods
    
    private func handleOnAppear() async {
        guard startupItem == nil else {
            isLoading = false 
            return
        }

        loadTask?.cancel()
        isLoading = true
        errorMessage = nil
        
        loadTask = Task { @MainActor in
            do {
                try await ApolloWebClient.shared.apollo.clearCache()
                let item = try await service.getStartup(documentId: documentId)
                try Task.checkCancellation()
                
                self.startupItem = item
                self.errorMessage = nil
                self.isLoading = false
            } catch is CancellationError {
                self.isLoading = false
                return
            } catch {
                self.errorMessage = error.localizedDescription
                self.startupItem = nil
                self.isLoading = false
            }
        }
        
        await loadTask?.value
    }
    
    private func didTapShare() {
        showShareSheet = true
    }
    
    private func handleDelete() async {
        guard let documentId = startupItem?.documentId else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await service.deleteStartup(documentId: documentId)
            didDeleteStartup = true
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Event
    
    enum Event {
        case onAppear
        case onShareTapped
        case onDeleteTapped
        case onEditTapped
    }
}
