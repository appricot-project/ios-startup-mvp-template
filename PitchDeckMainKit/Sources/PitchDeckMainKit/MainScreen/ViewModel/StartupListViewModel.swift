//
//  StartupListViewModel.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckMainApiKit

@MainActor
final class StartupListViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var startups: [StartupItem] = []
    @Published var categories: [CategoryItem] = []
    @Published var selectedCategoryId: Int? = nil
    @Published var searchText: String? = nil
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var isInitialLoading = true
    @Published var hasMore = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Private properties
    
    private var currentPage = 1
    private let pageSize = 10
    private let service: StartupService
    private var activeTask: Task<Void, Never>? = nil
    
    // MARK: - Init
    
    init(service: StartupService) {
        self.service = service
    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .onSearch(let text):
                await handleSearch(text: text)
            case .onSelectedCategory(let categoryId):
                await handleCategoryChange(categoryId)
            case .onLoadMore:
                await handleLoadMore()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func handleOnAppear() async {
        activeTask?.cancel()
        isInitialLoading = true
        activeTask = Task {
            await loadFreshData(title: nil, categoryId: nil, loadCategories: true)
        }
        await activeTask?.value
    }
    
    private func handleSearch(text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = trimmed.isEmpty ? nil : trimmed
        
        guard searchText != newText else { return }
        
        activeTask?.cancel()
        
        isLoading = true
        searchText = newText
        currentPage = 1
        
        activeTask = Task {
            await loadFreshData(title: newText, categoryId: selectedCategoryId, loadCategories: false)
        }
        await activeTask?.value
        isLoading = false
    }
    
    private func handleCategoryChange(_ categoryId: Int?) async {
        guard selectedCategoryId != categoryId else { return }
        
        activeTask?.cancel()
        
        isLoading = true
        selectedCategoryId = categoryId
        currentPage = 1
        
        activeTask = Task {
            await loadFreshData(title: searchText, categoryId: categoryId, loadCategories: false)
        }
        await activeTask?.value
        isLoading = false
    }
    
    private func handleLoadMore() async {
        guard hasMore, !isLoadingMore, !isLoading else { return }
        
        isLoadingMore = true
        
        do {
            let nextPage = currentPage + 1
            let result = try await service.getStartups(
                title: searchText,
                categoryId: selectedCategoryId,
                page: nextPage,
                pageSize: pageSize
            )
            
            startups.append(contentsOf: result.items)
            if let pageInfo = result.pageInfo {
                hasMore = nextPage < pageInfo.pageCount
            } else {
                hasMore = false
            }
            currentPage = nextPage
        } catch {
            if !(error is CancellationError) {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoadingMore = false
    }
    
    private func loadFreshData(title: String?, categoryId: Int?, loadCategories: Bool) async {
        defer {
            isLoading = false
            isInitialLoading = false
        }
        
        do {
            let startupsResult: StartupPageResult
            if loadCategories {
                async let startupsTask = service.getStartups(
                    title: title,
                    categoryId: categoryId,
                    page: 1,
                    pageSize: pageSize
                )
                
                async let categoriesTask = service.getStartupsCategories()
                
                let (startupsPage, cats) = try await (startupsTask, categoriesTask)
                
                try Task.checkCancellation()
                
                startupsResult = startupsPage
                self.categories = cats
            } else {
                startupsResult = try await service.getStartups(
                    title: title,
                    categoryId: categoryId,
                    page: 1,
                    pageSize: pageSize
                )
                
                try Task.checkCancellation()
            }
            
            self.startups = startupsResult.items
            
            if let pageInfo = startupsResult.pageInfo {
                self.hasMore = 1 < pageInfo.pageCount
            } else {
                self.hasMore = startupsResult.items.count == pageSize
            }
            
            self.currentPage = 1
            self.errorMessage = nil
            
        } catch is CancellationError {
            return
        } catch {
            self.errorMessage = error.localizedDescription
            self.startups = []
            self.hasMore = false
        }
    }
}

// MARK: - Event

extension StartupListViewModel {
    enum Event {
        case onAppear
        case onSearch(String)
        case onSelectedCategory(Int?)
        case onLoadMore
    }
}
