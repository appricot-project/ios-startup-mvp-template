# PitchDeck iOS Project Guide

This file contains code style guidelines and project conventions for working on the PitchDeck iOS project.

## Project Overview

- **Type**: iOS application (Swift + SwiftUI)
- **Architecture**: Clean Architecture with multi-module setup
- **DI**: Manual dependency injection with protocols
- **Networking**: Apollo GraphQL + URLSession
- **Build System**: Xcode with Swift Package Manager
- **Package Structure**: Modular Swift packages

## Code Style Guidelines

### Import Organization
- Group imports in this order:
  1. SwiftUI and UIKit imports
  2. Swift standard library
  3. Third-party libraries (Apollo, SnapshotTesting, etc.)
  4. Project imports (same module first, then other modules)
- Use alphabetical ordering within groups
- No unused imports

### Formatting Conventions
- **Indentation**: 4 spaces (no tabs)
- **Line length**: Maximum 120 characters
- **Braces**: Allman style - opening brace on new line
- **Semicolons**: Never use semicolons at line ends
- **Spacing**: Single space around operators, after commas

### Naming Conventions
- **Classes/Structs**: PascalCase (e.g., `HomeViewModel`, `StartupRepository`)
- **Functions/Properties**: camelCase (e.g., `getStartups()`, `startupId`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `DEFAULT_TIMEOUT`)
- **SwiftUI Views**: PascalCase (e.g., `BasicButton`, `HomeScreen`)
- **Private Properties**: camelCase with underscore prefix if needed (e.g., `_errors`)

### Type Guidelines
- **Explicit Returns**: Always specify return types for public functions
- **Optional Types**: Use `?` for optionals, prefer non-optional when possible
- **Enums**: Use for state management and restricted hierarchies
- **Structs**: Use for models with automatic `Equatable` and `Codable`
- **Type Aliases**: Use for complex function types or frequently used types

### Architecture Patterns

### Current Architecture: Service-Based MVVM
The project uses a simplified MVVM pattern with service layer:

- **Presentation Layer**: SwiftUI Views + ViewModels with `@Published` properties
- **Service Layer**: Protocol-based services for data operations  
- **Data Layer**: Apollo GraphQL client for API communication

### Service Layer Structure
```
PitchDeckMainApiKit/
├── Service/
│   ├── StartupService.swift          # Protocol for startup operations
│   ├── StartupDetailNavigationService.swift
│   └── StartupEditNavigationService.swift

PitchDeckMainKit/
├── Service/
│   ├── StartupServiceImpl.swift      # Implementation with Apollo
│   ├── StartupDetailNavigationServiceImpl.swift
│   └── StartupEditNavigationServiceImpl.swift
```

### ViewModel Pattern
```swift
@MainActor
final class StartupDetailViewModel: ObservableObject {
    @Published var startupItem: StartupItem?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service: StartupService
    
    func send(event: Event) {
        // Handle events and update state
    }
}
```

### Dependency Injection
- Use protocol-based constructor injection
- Services are injected into ViewModels
- Mock services for testing

### SwiftUI Guidelines
- **Parameters**: Order views as `viewModel`, `onAction`, then other params
- **Defaults**: Provide sensible defaults for optional parameters
- **Previews**: Include comprehensive previews for all views
- **Modifiers**: Chain modifiers, start with required ones
- **State**: Prefer stateless views, hoist state when needed

### Error Handling
- **Results**: Use `Result<T, Error>` for operations that can fail
- **Exceptions**: Handle with do-catch blocks, prefer specific error types
- **UI State**: Use enums for different UI states (Loading, Data, Error)
- **Logging**: Use `print()` for logging, avoid logging sensitive data

## Module Structure

```
PitchDeck/                    # Main application module
├── PitchDeckAuthKit/         # Authentication module
├── PitchDeckAuthApiKit/       # Authentication API module
├── PitchDeckMainKit/          # Main features module
├── PitchDeckMainApiKit/       # Main features API module
├── PitchDeckCabinetKit/       # Cabinet/profile module
├── PitchDeckCabinetApiKit/    # Cabinet/profile API module
├── PitchDeckCoreKit/          # Core utilities and networking
├── PitchDeckUIKit/            # UI components and design system
├── PitchDeckNavigationKit/     # Navigation utilities
├── PitchDeckNavigationApiKit/  # Navigation API module
└── PitchDeckRootKit/          # Root coordinator and app entry
```

## Dependencies Management

- **Swift Package Manager**: All dependencies managed via `Package.swift` files
- **Local Packages**: Use relative paths for local modules
- **External Packages**: Managed through Xcode Package Manager

## GraphQL Integration

- **Client**: Apollo iOS
- **Schema**: Auto-generated from GraphQL schema
- **Queries**: Use generated types for type safety

### GraphQL Commands
```bash
# Generate GraphQL classes from schema
cd PitchDeck/Apollo
./apollo-ios-cli generate --path apollo-codegen-config.json
```

## Build Configuration

- **iOS Deployment Target**: 17.6
- **Swift Version**: 6.0
- **Xcode Version**: 16.0+
- **Architecture**: arm64 (iOS Device), x86_64 (Simulator)

## Quality Assurance

- **Lint**: Run Xcode static analysis before commits
- **Tests**: Ensure all critical paths are tested
- **Code Review**: Follow established patterns and conventions
- **Documentation**: Update relevant documentation when adding features

## Navigation

### Navigation Architecture

The project uses a coordinator-based navigation system with the following structure:

- **API Modules**: Define navigation destinations and routes (`*_ApiKit` modules)
- **Implementation Modules**: Contain actual screens and navigation logic
- **Core Navigation**: Centralized navigation configuration and utilities

### Adding New Features with Navigation

#### 1. Create API Module
```swift
// NewFeatureApiKit/Sources/NewFeatureApiKit/Navigation/NewFeatureRoute.swift
public enum NewFeatureRoute: Hashable {
    case main
    case details(id: String)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .main:
            hasher.combine("main")
        case .details(let id):
            hasher.combine("details")
            hasher.combine(id)
        }
    }
}
```

#### 2. Create Implementation Module
```swift
// NewFeatureKit/Sources/NewFeatureKit/Coordinator/NewFeatureCoordinator.swift
@MainActor
public final class NewFeatureCoordinator: BaseCoordinator<NewFeatureRoute> {
    public let service: NewFeatureService
    
    public init(service: NewFeatureService) {
        self.service = service
        super.init()
    }
    
    @ViewBuilder
    public func build(route: NewFeatureRoute) -> some View {
        switch route {
        case .main:
            NewFeatureMainScreen(
                viewModel: NewFeatureMainViewModel(service: service),
                onDetailsTap: { [weak self] id in
                    self?.push(.details(id: id))
                }
            )
        case .details(let id):
            NewFeatureDetailsScreen(
                viewModel: NewFeatureDetailsViewModel(id: id, service: service)
            )
        }
    }
}
```

#### 3. Add Navigation Dependencies
```swift
// NewFeatureKit/Package.swift
dependencies: [
    .package(path: "../NewFeatureApiKit"),
    .package(path: "../PitchDeckCoreKit"),
    .package(path: "../PitchDeckUIKit")
]
```

### Navigation Best Practices

#### Route Naming Conventions
- Use descriptive, PascalCase names
- Include feature prefix: `FeatureNameScreenName`
- Group related routes: `ProfileMain`, `ProfileEdit`, `ProfileSettings`

#### Parameter Handling
```swift
// Define routes with parameters
public enum StartupRoute: Hashable {
    case details(documentId: String)
}

// Navigate with parameters
onDetailsTap = { [weak self] documentId in
    self?.push(.details(documentId: documentId))
}

// Handle parameter in viewModel
init(documentId: String, service: StartupService) {
    self.documentId = documentId
    self.service = service
}
```

## Clean Architecture Screen Creation Guide

This section describes the complete process of creating a new screen following Clean Architecture principles in the PitchDeck project.

### Architecture Layers

#### 1. Data Layer
**DataSource** - Raw data access (network, cache)
```swift
// PitchDeckMainApiKit/Sources/PitchDeckMainApiKit/Service/StartupService.swift
public protocol StartupService {
    func getStartup(documentId: String) async throws -> StartupItem
    func getStartups(title: String?, categoryId: Int?, email: String?, page: Int, pageSize: Int) async throws -> StartupPageResult
}

public class StartupServiceImpl: StartupService {
    private let apolloClient: ApolloClient
    
    public init(apolloClient: ApolloClient = ApolloWebClient.shared.apollo) {
        self.apolloClient = apolloClient
    }
    
    public func getStartup(documentId: String) async throws -> StartupItem {
        let query = GetStartupQuery(documentId: documentId)
        let response = try await apolloClient.fetch(query: query)
        guard let startup = response.data?.startup else {
            throw NSError(domain: "StartupError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Startup not found"])
        }
        return startup.toDomain()
    }
}
```

#### 2. Presentation Layer
**ViewModel** - UI state management and business logic coordination
```swift
// PitchDeckMainKit/Sources/PitchDeckMainKit/DetailScreen/ViewModel/StartupDetailViewModel.swift
@MainActor
public final class StartupDetailViewModel: ObservableObject {
    @Published public var startupItem: StartupItem?
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let documentId: String
    private let service: StartupService
    private var loadTask: Task<Void, Never>? = nil
    
    public init(documentId: String, service: StartupService) {
        self.documentId = documentId
        self.service = service
    }
    
    public func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            }
        }
    }
    
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
}

public extension StartupDetailViewModel {
    enum Event {
        case onAppear
        case onShareTapped
    }
}
```

**View** - UI implementation
```swift
// PitchDeckMainKit/Sources/PitchDeckMainKit/DetailScreen/View/StartupDetailView.swift
struct StartupDetailView: View {
    @ObservedObject private var viewModel: StartupDetailViewModel
    let onEditTapped: ((String) -> Void)?
    let onDeleteSuccess: (() -> Void)?
    
    public init(
        viewModel: StartupDetailViewModel,
        onEditTapped: ((String) -> Void)? = nil,
        onDeleteSuccess: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.onEditTapped = onEditTapped
        self.onDeleteSuccess = onDeleteSuccess
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let item = viewModel.startupItem {
                    mainContent(item: item)
                } else {
                    emptyStateView
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationTitle(viewModel.startupItem?.title ?? "")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isOwner() {
                    Button(action: {
                        if let documentId = viewModel.startupItem?.documentId {
                            onEditTapped?(documentId)
                        }
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            viewModel.send(event: .onAppear)
        }
    }
}
```

### Model Mapping

#### GraphQL Models
```swift
// PitchDeckMainApiKit/Sources/PitchDeckMainApiKit/Model/StartupItem.swift
public struct StartupItem: Codable, Sendable {
    public let id: Int
    public let documentId: String
    public let title: String
    public let description: String
    public let image: String?
    public let category: String
    public let location: String
    public let ownerEmail: String
}

// Extension for GraphQL to Domain conversion
extension GetStartupQuery.Data.Startup {
    func toDomain() -> StartupItem {
        return StartupItem(
            id: id,
            documentId: documentId,
            title: title,
            description: description,
            image: image,
            category: category,
            location: location,
            ownerEmail: ownerEmail
        )
    }
}
```

### Module Structure for New Screen

```
NewFeatureKit/
├── Sources/
│   └── NewFeatureKit/
│       ├── Coordinator/
│       │   └── NewFeatureCoordinator.swift
│       ├── Model/
│       │   └── NewFeatureModel.swift
│       ├── Presentation/
│       │   ├── ViewModel/
│       │   │   └── NewFeatureViewModel.swift
│       │   └── View/
│       │       └── NewFeatureScreen.swift
│       └── Service/
│           └── NewFeatureService.swift
└── Tests/
    └── NewFeatureKitTests/
        ├── Mocks/
        │   └── MockNewFeatureService.swift
        ├── ViewModelTests/
        │   └── NewFeatureViewModelTests.swift
        └── SnapshotTests/
            └── NewFeatureScreenSnapshotTests.swift
```

### Key Principles

1. **Service-Based Architecture**: Services handle data operations directly
2. **MVVM Pattern**: ViewModels manage UI state with @Published properties
3. **Protocol-Based DI**: Services are injected via protocols for testability
4. **Direct Data Flow**: ViewModels call services directly (no UseCase layer)
5. **State Management**: ViewModels expose @Published properties for UI state
6. **Mock Testing**: Protocol conformance enables easy mocking

## Testing Guidelines

### Unit Tests
- Use `XCTest` framework
- Mock dependencies using protocol conformance
- Test ViewModels in isolation
- Use `@MainActor` for ViewModels that update UI

### Snapshot Tests
- Use `SnapshotTesting` framework
- Test all SwiftUI views
- Include different states (loading, error, success)
- Use `isRecording = true` for initial recording

### Test Structure
```swift
@MainActor
final class NewFeatureViewModelTests: XCTestCase {
    var sut: NewFeatureViewModel!
    var mockService: MockNewFeatureService!
    
    override func setUp() async throws {
        mockService = MockNewFeatureService()
        sut = NewFeatureViewModel(service: mockService)
    }
    
    override func tearDown() async throws {
        mockService.reset()
        sut = nil
        mockService = nil
    }
    
    func testInitialState_isCorrect() {
        XCTAssertNil(sut.data)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
}
```

## Localization

- Use `.localized` extension on strings
- Store localized strings in `Localizable.strings`
- Follow key naming convention: `feature.action.description`
- Test different languages in snapshots

## Performance Guidelines

- Use `@MainActor` for UI-related classes
- Implement proper cancellation in async operations
- Use lazy loading for large datasets
- Optimize SwiftUI view updates
- Profile with Instruments when needed
