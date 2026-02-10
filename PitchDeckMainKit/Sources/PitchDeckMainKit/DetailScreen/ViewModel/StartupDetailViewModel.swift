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
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showShareSheet = false
    
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
        loadTask?.cancel()
        
        if currentUserEmail.isEmpty {
            do {
                let loadedEmail = await KeychainStorage().string(forKey: .userEmail) ?? ""
                self.currentUserEmail = loadedEmail
            }
        }
        
        isLoading = true
        errorMessage = nil
        
        loadTask = Task { @MainActor in
            do {
                let item = try await service.getStartup(documentId: documentId)
                try Task.checkCancellation()
                
                self.startupItem = item
                self.errorMessage = nil
            } catch is CancellationError {
                print("qqqq \(self.startupItem)")
                return
            } catch {
                print("qqqq \(self.startupItem)")
                self.errorMessage = error.localizedDescription
                self.startupItem = nil
            }
            self.isLoading = false
        }
        
        await loadTask?.value
    }
    
    private func didTapShare() {
        showShareSheet = true
    }
    
    // MARK: - Event
    
    enum Event {
        case onAppear
        case onShareTapped
        case onEditTapped
    }
}
