//
//  CabinetViewModel.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckCabinetApiKit
import PitchDeckMainApiKit

@MainActor
public final class CabinetViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published public var userProfile: UserProfile?
    @Published public var userStartups: [StartupItem] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    // MARK: - Private properties
    
    private let cabinetService: CabinetService
    
    // MARK: - Init
    
    public init(cabinetService: CabinetService) {
        self.cabinetService = cabinetService
    }
    
    // MARK: - Public methods
    
    public func loadUserProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            userProfile = try await Task.detached {
                try await self.cabinetService.getUserProfile()
            }.value
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func loadUserStartups() async {
        guard let profile = userProfile else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            userStartups = try await Task.detached {
                try await self.cabinetService.getUserStartups(email: profile.email)
            }.value
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func loadAllData() async {
        await loadUserProfile()
        await loadUserStartups()
    }
}
