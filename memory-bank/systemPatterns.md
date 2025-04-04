# System Patterns

## Architecture Overview
The Brainy Flutter application follows the MVVM (Model-View-ViewModel) architecture pattern with a clean, layered structure. This ensures separation of concerns and makes the codebase maintainable, testable, and scalable.

## Project Structure
```
lib/
  ├── core/
  │   ├── base/                 # Base classes (BaseView, BaseViewModel)
  │   ├── dependency_injection/ # Service locator using get_it
  │   ├── models/               # Data models
  │   ├── repositories/         # Repository pattern implementations
  │   │   ├── abstract/         # Repository interfaces
  │   │   └── implementations/  # Concrete repository classes
  │   ├── routes/               # Navigation system
  │   ├── services/             # Core services
  │   │   ├── http/             # HTTP client
  │   │   └── storage/          # Local storage
  │   └── widgets/              # Reusable widgets
  ├── features/                 # Feature modules
  │   ├── auth/                 # Authentication feature
  │   │   ├── controllers/      # Controllers for managing state
  │   │   ├── viewmodels/       # ViewModels for UI logic
  │   │   └── views/            # UI components
  │   ├── home/                 # Home feature
  │   └── vocabulary/           # Vocabulary feature
  └── main.dart                 # Application entry point
```

## Design Patterns

### 1. MVVM Pattern
- **Model**: Data classes and repositories define the data structure and business logic.
- **View**: Flutter widgets that render UI and forward user events to the ViewModel.
- **ViewModel**: Manages UI state, processes data for display, and handles user interactions.

### 2. Repository Pattern
- Repositories abstract the data sources from the rest of the application.
- Each repository has an abstract interface and concrete implementation.
- This allows for easy mocking during tests and potential data source changes.

### 3. Dependency Injection
- Using the GetIt library to implement a service locator pattern.
- Services and repositories are registered and retrieved from a central container.
- Facilitates testing by allowing dependencies to be easily replaced with mocks.

### 4. Observer Pattern
- Implemented via Flutter's ChangeNotifier and Provider package.
- ViewModels extend BaseViewModel which extends ChangeNotifier.
- UI components listen to changes in the ViewModel and rebuild when needed.

## Key Components

### BaseViewModel
A foundational class that provides common functionality for all ViewModels:
- Loading state management (isBusy, hasError)
- Error handling
- Safe disposal of resources

### BaseView
A wrapper widget that:
- Creates and provides a ViewModel to the UI
- Manages the ViewModel lifecycle
- Uses Provider to rebuild the UI when the ViewModel changes

### Service Locator
- Centralized dependency management using `locator.dart`
- Handles initialization of services, repositories, controllers, and ViewModels

### API Communication
- BrainyApiClient handles HTTP requests with proper error handling
- Supports authentication with token management
- Generic response parsing

### Local Storage
- SharedPrefsStorage provides a consistent interface for data persistence
- Ensures initialization before use
- Thread-safe operations

## Implementation Standards
1. Each feature is self-contained with its own views, viewmodels, and potentially controllers
2. UI components are focused on rendering and user input
3. Business logic lives in repositories and ViewModels
4. Navigation is centralized in AppRouter
5. Error handling is consistent across the application
6. Service dependencies are explicit through constructor injection 