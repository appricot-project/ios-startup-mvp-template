//
//  CabinetViewModel.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckCabinetApiKit
import PitchDeckMainApiKit
import PitchDeckAuthApiKit

@MainActor
public final class CabinetViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published public var userProfile: UserProfileData?
    @Published public var userStartups: [StartupItem] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var didLogout: Bool = false
    
    // MARK: - Private properties
    
    private let cabinetService: CabinetService
    private let startupService: StartupService
    private let authService: AuthService
    
    // MARK: - Init
    
    public init(cabinetService: CabinetService, startupService: StartupService, authService: AuthService) {
        self.cabinetService = cabinetService
        self.startupService = startupService
        self.authService = authService
    }
    
    // MARK: - Event
    
    public enum Event {
        case onAppear
        case loadUserProfile
        case loadUserStartups
        case loadAllData
        case refreshStartups
        case refreshAll
        case logout
    }
    
    // MARK: - Public methods
    
    public func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .loadUserProfile:
                await loadUserProfile()
            case .loadUserStartups:
                await loadUserStartups()
            case .loadAllData:
                await loadAllData()
            case .refreshStartups:
                await loadUserStartups()
            case .refreshAll:
                await loadAllData()
            case .logout:
                await performLogout()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func handleOnAppear() async {
        await loadAllData()
    }
    
    private func loadUserProfile() async {
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
    
    private func loadUserStartups() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let email: String
            if let profile = userProfile, let profileEmail = profile.email, !profileEmail.isEmpty {
                email = profileEmail
            } else {
                let profile = try await cabinetService.getUserProfile()
                email = profile.email ?? ""
                if userProfile == nil {
                    userProfile = profile
                }
            }
            
            guard !email.isEmpty else {
                userStartups = []
                return
            }
            
            let result = try await Task.detached {
                try await self.startupService.getStartups(title: nil, categoryId: nil, email: email, page: 1, pageSize: 100)
            }.value
            userStartups = result.items
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func loadAllData() async {
        await loadUserProfile()
        if userProfile != nil {
            await loadUserStartups()
        }
    }
    
    private func performLogout() async {
        isLoading = true
        errorMessage = nil
        
        // AuthService.logout() doesn't throw errors according to protocol
        await authService.logout()
        userProfile = nil
        userStartups = []
        didLogout = true
        
        isLoading = false
    }
}
