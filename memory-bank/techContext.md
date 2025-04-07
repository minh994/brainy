# Technical Context

## Core Technologies

### Flutter Framework & Components
- **Flutter 3.x** - UI framework
- **Get_It** - Service locator for dependency injection
- **Provider (via BaseViewModel)** - Simple state management
- **Flutter Card Swiper** - Component used for flashcard interactions
- **Audio Player** - For pronunciation playback

## Architecture & Patterns

### MVVM Pattern
- **Models** - Data structures like Word, Sense, Example
- **ViewModels** - Business logic and state management
  - BaseViewModel - Foundation for all ViewModels
  - LearnViewModel - Manages learning state and word statuses
  - HomeViewModel - Manages home screen state
  - DictionaryViewModel - Manages dictionary browsing
  - DictionaryDetailViewModel - Handles word details
- **Views** - UI components
  - Structured hierarchically with parent views and child components
  - Component-based approach for reusability

### Dependency Injection
- Service locator pattern with Get_It
- Central registration in locator.dart
- Factory pattern for ViewModels
- Singleton pattern for services (AudioService)

### Component Structure
We've implemented a modular component architecture with:
1. **Core Widgets** - Reusable across the app
   - AudioButton
   - BusyIndicator
   
2. **Feature-specific Components** - Encapsulated in feature folders
   - FlashcardWidget
   - LearningControls
   - CardSwiperWidget
   - CompletionScreen

## Data Management

### API Integration
- **BrainyApiClient** - Central HTTP client for API communication
- **ApiResponse<T>** - Generic wrapper for API responses with success/error handling
- **Repositories** - Interface between ViewModels and API
  - WordRepository - Handles CRUD operations for words and learning statuses

### Local Storage
- **SharedPrefsStorage** - Wrapper for SharedPreferences
- **StorageService** - Interface for storage operations
- Used for token storage and app settings

## Development Patterns

### Error Handling
- Consistent error handling through ApiResponse
- Error states in ViewModels
- User-friendly error messages in UI

### Navigation
- AppRouter - Centralized navigation
- Named routes
- Nested routing for feature modules

### Testing
- Unit testing for critical components
- UI testing for main workflows

## External Libraries
- **flutter_card_swiper**: For interactive flashcard swiping functionality
- **get_it**: For dependency injection
- **audioplayers**: For audio playback of word pronunciations

## Technology Stack

### Core Technologies
- **Flutter**: Cross-platform UI framework (latest stable version)
- **Dart**: Programming language for Flutter development
- **Provider**: State management using InheritedWidgets
- **Get_It**: Dependency injection service locator

### Media & UI
- **just_audio**: Audio playback for pronunciation
- **flutter_card_swiper**: Card swiping functionality for vocabulary learning
- **google_fonts**: Custom font integration
- **flutter_markdown**: Markdown rendering for grammar lessons
- **url_launcher**: Opening external links from markdown content

### Persistence
- **shared_preferences**: Lightweight key-value storage
- **REST API**: Backend communication

### Key Dependencies
- **http**: HTTP requests and API communication
- **provider**: ChangeNotifier-based state management
- **flutter_dotenv**: Environment configuration management
- **intl**: Internationalization and date formatting

## Development Environment

### Setup Requirements
- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- IDE: VS Code or Android Studio
- Git for version control

### Build & Run
- Development: `flutter run`
- Release: `flutter build apk` (Android) or `flutter build ios` (iOS)

## Architecture Components

### Core Infrastructure
- **BaseViewModel**: Abstract ViewModel base class with common functionality
- **BaseView**: State management wrapper for widgets
- **BusyIndicator**: Standardized loading indicator
- **WordStatus**: Enum for word learning status

### Authentication
- Token-based authentication
- JWT format (access token + refresh token)
- Local credential storage

### API Client
- RESTful API communication
- Generic response handling
- Error handling and retries
- Nested JSON structure parsing

### Storage Services
- Secure credential storage
- User preferences
- App state persistence

### Media Services
- Audio playback with just_audio
- Resource management and disposal
- Error handling for media playback

### Content Rendering
- Markdown rendering with flutter_markdown
- Custom styling for markdown elements
- Table formatting and styling
- External link handling

## Feature Components

### Dictionary
- Status-based filtering
- Part of speech visualization
- Search functionality
- API integration

### Grammar
- Category-based organization
- Progress tracking per category
- Lesson hierarchy within categories
- Markdown content rendering
- Styled tables and typography
- API integration with categories and lessons endpoints

### Settings
- Theme management
- Language selection
- Notification preferences
- Learning goals configuration

## Code Conventions

### File Structure
- **Naming**: snake_case for filenames
- **Organization**: Feature-based structure
- **Views**: Named as `feature_view.dart`
- **ViewModels**: Named as `feature_view_model.dart`

### Dart Style
- Follow official Dart style guide
- Use strong types (avoid `dynamic` where possible)
- Use `final` for immutable variables
- Leverage Dart null safety features

### Widget Structure
- Stateless widgets preferred
- ExtractWidget for reusable components
- Composition over inheritance

### Error Handling
- Centralized error handling in ViewModels
- User-friendly error messages
- Detailed logging for debugging

## Testing Strategy

### Unit Tests
- ViewModel logic
- Repository implementations
- Service classes

### Widget Tests
- Component rendering
- User interactions
- State changes

### Integration Tests
- Critical user journeys
- API interactions

## Security Considerations
- Secure storage for tokens
- HTTPS for all API communications
- Input validation
- Obfuscation in release builds

## Performance Guidelines
- Minimize rebuilds
- Lazy loading for large datasets
- Image optimization
- Memory management for disposable resources
- Audio resource disposal
- Efficient markdown rendering

### Core Dependencies
- **flutter_dotenv** - Environment configuration management
- **provider** - State management solution
- **http** - HTTP client for API communication
- **shared_preferences** - Local storage for user preferences and caching
- **just_audio** - Audio playback for word pronunciations
- **flutter_card_swiper** - Card swiping functionality for learning mode
- **google_fonts** - Integration of custom fonts
- **infinite_scroll_pagination** - Pagination for efficient loading of large data sets 