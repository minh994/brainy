# Brainy Flutter App - MVVM Architecture

This project follows the Model-View-ViewModel (MVVM) architecture pattern with a feature-based organization for a clean and maintainable codebase.

## Project Structure

```
lib/
 ├── core/                 # Core application functionality
 │   ├── base/             # Base classes (MVVM architecture)
 │   │   ├── base_api.dart      # Base API handling
 │   │   ├── base_view.dart     # Base View component
 │   │   └── base_viewmodel.dart # Base ViewModel
 │   ├── services/         # Services used across the app
 │   │   ├── di/              # Dependency injection
 │   │   ├── http/            # HTTP client and services
 │   │   └── ...             # Other services
 │   └── utils/            # Utility functions and helpers
 │
 ├── features/            # Feature modules
 │   ├── auth/            # Authentication feature
 │   │   ├── controllers/  # Auth controllers
 │   │   ├── models/       # Auth data models
 │   │   ├── views/        # Auth UI screens
 │   │   └── viewmodels/   # Auth ViewModels
 │   │
 │   ├── home/            # Home screen feature
 │   │   ├── controllers/  # Home controllers
 │   │   ├── models/       # Home data models
 │   │   ├── views/        # Home UI screens
 │   │   └── viewmodels/   # Home ViewModels
 │   │
 │   └── vocabulary/      # Vocabulary feature
 │       ├── controllers/  # Vocabulary controllers
 │       ├── models/       # Vocabulary data models
 │       ├── views/        # Vocabulary UI screens
 │       └── viewmodels/   # Vocabulary ViewModels
 │
 └── main.dart           # Entry point
```

## Architecture

This application is built using the MVVM (Model-View-ViewModel) architecture with a feature-based organization.

### Core Components

#### Base Classes

1. **BaseApi** (`core/base/base_api.dart`)
   - Provides a standardized way to make HTTP requests
   - Handles error scenarios
   - Includes response parsing with generic types
   - Supports all common HTTP methods (GET, POST, PUT, DELETE)

2. **BaseViewModel** (`core/base/base_viewmodel.dart`)
   - Extends ChangeNotifier for state management
   - Tracks view state (idle, busy, error)
   - Manages error handling
   - Provides convenient methods for async operations

3. **BaseView** (`core/base/base_view.dart`)
   - Simplifies connecting views with viewmodels
   - Manages the lifecycle of viewmodels
   - Provides a consistent pattern for UI implementation
   - Includes helper widgets like BusyIndicator

#### Services

1. **Dependency Injection** (`core/services/di/service_locator.dart`)
   - Uses get_it for service location and dependency injection
   - Centralizes creation and retrieval of service instances
   - Manages singletons and factories

2. **API Client** (`core/services/http/api_client.dart`)
   - Extends BaseApi with app-specific configuration
   - Provides the connection to backend services

### Feature Organization

Each feature is organized into its own directory with a consistent structure:

1. **Models**
   - Data classes representing domain entities
   - DTOs for API responses and requests

2. **ViewModels**
   - Extend BaseViewModel
   - Handle business logic for views
   - Manage state for UI components
   - Connect to services and APIs

3. **Views**
   - UI components and screens
   - Use BaseView to connect with ViewModels
   - Display data and handle user interactions

4. **Controllers** (when needed)
   - Manage application-wide state
   - Coordinate between different parts of the app

## Best Practices

1. Create specific viewmodels for each view/feature
2. Keep viewmodels focused on a single responsibility
3. Use the ApiResponse class to handle all API responses
4. Handle loading and error states in the UI using the BaseViewModel state
5. Avoid business logic in UI code - keep it in viewmodels
6. Use dependency injection for services and controllers
7. Follow the feature-based organization for new functionality
8. Use runBusyFuture for operations that should show loading state 