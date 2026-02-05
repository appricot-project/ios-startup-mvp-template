//
//  CreateStartupViewModel.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckMainApiKit

@MainActor
public final class CreateStartupViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published public var startupId: String = ""
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
        !startupId.isEmpty &&
        !title.isEmpty &&
        !description.isEmpty &&
        !location.isEmpty &&
        selectedCategoryId != nil
    }
    
    // MARK: - Private properties
    
    private let startupService: StartupService
    
    // MARK: - Init
    
    public init(startupService: StartupService) {
        self.startupService = startupService
    }
    
    // MARK: - Public methods
    
    public func loadCategories() async {
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
    
    public func createStartup() async {
        guard let selectedCategoryId = selectedCategoryId else { return }
        
        isCreating = true
        errorMessage = nil
        
        do {
            let request = CreateStartupRequest(
                startupId: startupId,
                title: title,
                description: description,
                location: location,
                categoryId: selectedCategoryId,
                imageData: selectedImageData
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
    
    public func selectImage(data: Data) {
        selectedImageData = data
    }
}
