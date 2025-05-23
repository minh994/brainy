# System Patterns

## Core Architecture
This project follows an MVVM (Model-View-ViewModel) pattern with:

- **Models**: Data structures like `Word`, `Sense`, and `Example`
- **ViewModels**: Business logic classes that manage state and data
- **Views**: UI components that render data from ViewModels

## Feature Module Structure
The app is organized into feature modules:

1. **Auth Feature**
   - Login/Signup
   - Authentication state management

2. **Dictionary Feature**
   - Dictionary browsing
   - Word details

3. **Home Feature**
   - Dashboard view
   - Summary of learning progress

4. **Vocabulary Feature**
   - Vocabulary lists
   - Vocabulary cards

5. **Grammar Feature**
   - Grammar lessons
   - Categories and details

6. **Learn Feature**
   - Learning view showing words with "learning" status
   - Flashcard learning mode with interactive card swiper
   - Learning controls and completion screens

## Component Architecture
We've implemented a component-based architecture for UI elements:

### Learning Feature Components
The learning feature demonstrates our component architecture approach:

1. **Container Components (Smart Components)**
   - `LearnView`: Manages the list of learning words
   - `LearningModeScreen`: Orchestrates the learning experience
   
2. **Presentational Components (Dumb Components)**
   - `FlashcardWidget`: Displays the word card with flip functionality
   - `CardSwiperWidget`: Handles card swiping interactions
   - `LearningControls`: UI for control buttons
   - `CompletionScreen`: Celebration UI when learning is complete

### Component Communication
- Parent-to-child: Props passed down to child components
- Child-to-parent: Callbacks passed up through function parameters
- Sibling-to-sibling: Through parent component or shared ViewModel

## State Management
- **BaseViewModel**: Foundation class for all ViewModels
- **Service Locator**: Dependencies injected using GetIt
- **Repository Pattern**: Data access abstracted through repository interfaces
- **Audio Service**: Singleton service for managing audio playback
- **Word Repository**: Manages word data and learning statuses

## Navigation Patterns
- **AppRouter**: Central router class for navigation
- **Modal Bottom Sheets**: For auxiliary views like learning options and completion
- **Dialogs**: For confirmations and alerts

## UI Patterns
- **Card Pattern**: Primary visual element for words
- **Card Swipe Interaction**: Left/right swiping for learning decisions
- **Flip Animation**: For toggling between word and definition
- **Progress Indicators**: Linear indicator for learning progress
- **Bottom Controls**: Consistent button layout for actions

## Service Patterns
1. **Repository Pattern**
   - Abstract interfaces defined in `abstract/` folder
   - Concrete implementations in `implementations/` folder
   - Repositories provide data access to ViewModels

2. **Service Locator Pattern**
   - Central registration in `locator.dart`
   - All dependencies registered with appropriate lifetime (singleton, factory)
   - ViewModels access dependencies through locator

3. **Audio Service**
   - Singleton service for audio playback
   - Manages audio state (playing, stopped)

## Architecture Overview
The Brainy Flutter application follows the MVVM (Model-View-ViewModel) architecture pattern with a clean, layered structure. This ensures separation of concerns and makes the codebase maintainable, testable, and scalable.

## Project Structure
```
lib/
  ├── core/
  │   ├── base/                 # Base classes (BaseView, BaseViewModel)
  │   ├── dependency_injection/ # Service locator using get_it
  │   ├── enums/                # Application-wide enumerations
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
  │   │   ├── components/       # Auth-specific UI components
  │   │   ├── viewmodels/       # ViewModels for UI logic
  │   │   └── views/            # UI components
  │   ├── home/                 # Home feature
  │   ├── dictionary/           # Dictionary feature
  │   │   ├── viewmodels/       # Dictionary ViewModels
  │   │   └── views/            # Dictionary UI components
  │   ├── grammar/              # Grammar feature
  │   │   ├── components/       # Grammar-specific UI components
  │   │   ├── models/           # Grammar data models
  │   │   ├── repositories/     # Grammar repositories
  │   │   ├── viewmodels/       # Grammar ViewModels
  │   │   └── views/            # Grammar UI components
  │   ├── settings/             # Settings feature
  │   │   ├── viewmodels/       # Settings ViewModels
  │   │   └── views/            # Settings UI components  
  │   └── vocabulary/           # Vocabulary feature
  │       ├── components/       # Word-specific UI components
  │       ├── viewmodels/       # ViewModels for vocabulary features
  │       └── views/            # Vocabulary UI components
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

### 5. Enum-Based Standardization
- Using enums for type-safe value selection (e.g., WordStatus)
- Provides consistent values across the application
- Simplifies UI logic with enum-driven rendering

### 6. Filter Pattern
- Implemented in Dictionary view using status-based filtering
- Allows for dynamic filtering of data based on selected criteria
- Combines well with search functionality

### 7. Category-Lesson Pattern
- Hierarchical structure used in the Grammar feature
- Categories contain lessons in a parent-child relationship
- Enables navigation from general (categories) to specific (lesson content)

### 8. Pagination Pattern
- **Implementation**: Using the `infinite_scroll_pagination` package to efficiently load large datasets
- **Key Components**:
  - `PagingController<Key, Item>` - Manages pagination state and loading logic
  - `PagedListView` - UI component that displays paginated data
  - `PagingListener` - Responds to pagination state changes
- **Benefits**:
  - Memory efficiency by loading only visible data
  - Better performance with large datasets
  - Automatic loading indicators and error handling
  - Reduced network usage
- **Usage**: Implemented in Dictionary feature to load words with different filters

## Key Components

### BaseViewModel
A foundational class that provides common functionality for all ViewModels:
- Loading state management (isBusy, hasError)
- Error handling
- Safe disposal of resources

```dart
// Core functionality in BaseViewModel
class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  bool _hasError = false;
  String? _errorMessage;

  bool get isBusy => _isBusy;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setError(String? message) {
    _hasError = message != null;
    _errorMessage = message;
    notifyListeners();
  }
}
```

### BaseView
A wrapper widget that:
- Creates and provides a ViewModel to the UI
- Manages the ViewModel lifecycle
- Uses Provider to rebuild the UI when the ViewModel changes

```dart
// Example usage of BaseView
BaseView<SignupViewModel>(
  viewModelBuilder: () => locator<SignupViewModel>(),
  builder: (context, model, child) {
    return Scaffold(
      // UI that reacts to model properties
      body: model.isBusy 
        ? LoadingIndicator() 
        : SignupForm(model: model),
    );
  },
)
```

### Authentication Flow
The application implements a token-based authentication flow:
1. User registers or logs in via the API
2. For login, tokens are received and stored securely
3. For signup, no tokens are provided, so user is redirected to login
4. Token refresh is handled automatically when tokens expire
5. Authenticated requests include the access token
6. User state is preserved for persistent login

### Dictionary Feature
The Dictionary feature implements:
1. Status-based filtering using WordStatus enum
2. Part of speech visualization with color coding
3. Search functionality across words and definitions
4. Efficient API integration with the repository pattern

### Grammar Feature
The Grammar feature implements:
1. Categories listing with progress indicators
2. Category detail view with lesson listings
3. Markdown-based lesson content rendering
4. Custom styling for tables, headings, and other markdown elements
5. Repository pattern for API integration
6. Responsive design for different screen sizes

### Settings Feature
The Settings feature provides:
1. User preferences management (theme, language, notifications)
2. Learning configuration (daily goals)
3. Data management (clearing user data)
4. Persistent storage using shared_preferences

### Audio Playback
The audio playback functionality:
1. Uses just_audio for cross-platform compatibility
2. Creates separate player instances to avoid conflicts
3. Handles errors gracefully
4. Properly disposes resources

### Service Locator
- Centralized dependency management using `locator.dart`
- Handles initialization of services, repositories, controllers, and ViewModels

### API Communication
- BrainyApiClient handles HTTP requests with proper error handling
- Supports authentication with token management
- Generic response parsing
- Handles nested JSON structures

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
7. Viewmodels should be focused on a single responsibility
8. Views should use the BaseView pattern for lifecycle management
9. Enums should be used for type-safe value selection
10. Colors and styles should be consistent throughout the application 