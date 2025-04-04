# Technical Context

## Technology Stack

### Core Technologies
- **Flutter**: Cross-platform UI framework (latest stable version)
- **Dart**: Programming language for Flutter development
- **Provider**: State management using InheritedWidgets
- **Get_It**: Dependency injection service locator

### Persistence
- **shared_preferences**: Lightweight key-value storage
- **REST API**: Backend communication

### Key Dependencies
- **http**: HTTP requests and API communication
- **provider**: ChangeNotifier-based state management

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

### Authentication
- Token-based authentication
- JWT format (access token + refresh token)
- Local credential storage

### API Client
- RESTful API communication
- Generic response handling
- Error handling and retries

### Storage Services
- Secure credential storage
- User preferences
- App state persistence

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