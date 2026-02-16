//
//  EditStartupViewModel.swift
//  PitchDeckMainKit
//
//  Created by Cascade on 10.02.2026.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckMainApiKit

@MainActor
final class EditStartupViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var location: String = ""
    @Published var selectedCategoryId: String = ""
    @Published var selectedImageData: Data? = nil
    @Published var categories: [CategoryItem] = []
    @Published var isLoading = false
    @Published var isUpdating = false
    @Published var errorMessage: String? = nil
    @Published var didUpdateStartup = false
    
    // MARK: - Private properties
    
    private let startupService: StartupService
    private let documentId: String
    private var originalTitle: String = ""
    private var originalDescription: String = ""
    private var originalLocation: String = ""
    private var originalCategoryId: String = ""
    private var originalImageData: Data?
    private var updateTask: Task<Void, Never>? = nil
    
    // MARK: - Computed properties
    
    var isUpdateEnabled: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedCategoryId.isEmpty &&
        (title != originalTitle ||
         description != originalDescription ||
         location != originalLocation ||
         selectedCategoryId != originalCategoryId ||
         selectedImageData != originalImageData)
    }
    
    // MARK: - Init
    
    init(startupService: StartupService, documentId: String) {
        self.startupService = startupService
        self.documentId = documentId
    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .onUpdate:
                await handleUpdate()
            case .onSelectImage(let data):
                selectedImageData = data
            }
        }
    }
    
    func preloadData(from startup: StartupItem) {
        title = startup.title
        description = startup.description ?? ""
        location = startup.location
        originalTitle = startup.title
        originalDescription = startup.description ?? ""
        originalLocation = startup.location
        originalCategoryId = selectedCategoryId
        
        if let imageURL = startup.image, !imageURL.isEmpty,
           let url = URL(string: imageURL) {
            Task { @MainActor in
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    selectedImageData = data
                    originalImageData = data
                } catch {
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func handleOnAppear() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let categoriesTask = startupService.getStartupsCategories()
            async let startupTask = startupService.getStartup(documentId: documentId)
            
            let (categories, startup) = try await (categoriesTask, startupTask)
            
            self.categories = categories
            preloadData(from: startup)
            
            if let category = categories.first(where: { $0.title == startup.category }) {
                selectedCategoryId = String(category.documentId)
            }
            
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func handleUpdate() async {
        guard isUpdateEnabled else { return }
        
        isUpdating = true
        errorMessage = nil
        
        do {
            let request = UpdateStartupRequest(
                documentId: documentId,
                title: title,
                description: description,
                location: location,
                categoryId: selectedCategoryId,
                imageData: selectedImageData
            )
            
            _ = try await startupService.updateStartup(request: request)
            didUpdateStartup = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isUpdating = false
    }
    
    // MARK: - Event
    
    enum Event {
        case onAppear
        case onUpdate
        case onSelectImage(Data)
    }
}
