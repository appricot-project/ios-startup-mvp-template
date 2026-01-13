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
    
    // MARK: - Init
    
    init(documentId: String, service: StartupService) {
        self.documentId = documentId
        self.service = service
    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .onShareTapped:
                showShareSheet = true
            }
        }
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
        
        isLoading = true
        errorMessage = nil
        
        loadTask = Task {
            do {
                let item = try await service.getStartup(documentId: documentId)
                try Task.checkCancellation()
                
                self.startupItem = item
                self.errorMessage = nil
            } catch is CancellationError {
                return
            } catch {
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
    }
}
