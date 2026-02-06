//
//  CreateStartupViewModel.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckMainApiKit
import PitchDeckCabinetApiKit

@MainActor
public final class CreateStartupViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published public var ownerEmail: String = ""
    @Published public var title: String = ""
    @Published public var description: String = ""
    @Published public var location: String = ""
    @Published public var selectedCategoryId: Int?
    @Published public var categories: [CategoryItem] = []
    @Published public var selectedImageData: Data?
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var isCreating: Bool = false
    @Published public var didCreateStartup: Bool = false
    
    // MARK: - Computed properties
    
    public var isCreateEnabled: Bool {
        !ownerEmail.isEmpty &&
        !title.isEmpty &&
        !description.isEmpty &&
        !location.isEmpty &&
        selectedCategoryId != nil
    }
    
    // MARK: - Private properties
    
    private let startupService: StartupService
    private let cabinetService: CabinetService
    
    // MARK: - Init
    
    public init(startupService: StartupService, cabinetService: CabinetService) {
        self.startupService = startupService
        self.cabinetService = cabinetService
    }
    
    // MARK: - Event
    
    public enum Event {
        case onAppear
        case loadCategories
        case createStartup
        case selectImage(Data)
        case ownerEmailChanged(String)
        case titleChanged(String)
        case descriptionChanged(String)
        case locationChanged(String)
        case categoryChanged(Int?)
    }
    
    // MARK: - Public methods
    
    public func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .loadCategories:
                await loadCategories()
            case .createStartup:
                await createStartup()
            case .selectImage(let data):
                selectImage(data: data)
            case .ownerEmailChanged(let ownerEmail):
                self.ownerEmail = ownerEmail
            case .titleChanged(let title):
                self.title = title
            case .descriptionChanged(let description):
                self.description = description
            case .locationChanged(let location):
                self.location = location
            case .categoryChanged(let categoryId):
                self.selectedCategoryId = categoryId
            }
        }
    }
    
    // MARK: - Private methods
    
    private func handleOnAppear() async {
        await loadUserProfile()
        await loadCategories()
    }
    
    private func loadUserProfile() async {
        do {
            let profile = try await cabinetService.getUserProfile()
            if let email = profile.email, !email.isEmpty {
                ownerEmail = email
            }
        } catch {
            print("Failed to load user profile: \(error)")
        }
    }
    
    private func loadCategories() async {
        isLoading = true
        errorMessage = nil
        
        do {
            categories = try await Task.detached {
                try await self.startupService.getStartupsCategories()
            }.value
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func createStartup() async {
        guard let selectedCategoryId = selectedCategoryId else { 
            return
        }
        isCreating = true
        errorMessage = nil
        
        do {
            let request = CreateStartupRequest(
                ownerEmail: ownerEmail,
                title: title,
                description: description,
                location: location,
                categoryId: selectedCategoryId,
                imageData: selectedImageData,
                imageUrl: nil 
            )
            
            _ = try await Task.detached {
                try await self.startupService.createStartup(request: request)
            }.value
            didCreateStartup = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isCreating = false
    }
    
    private func selectImage(data: Data) {
        selectedImageData = data
    }
}
