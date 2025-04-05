# Technical Context

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

### Persistence
- **shared_preferences**: Lightweight key-value storage
- **REST API**: Backend communication

### Key Dependencies
- **http**: HTTP requests and API communication
- **provider**: ChangeNotifier-based state management
- **flutter_dotenv**: Environment configuration management

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

## Feature Components

### Dictionary
- Status-based filtering
- Part of speech visualization
- Search functionality
- API integration

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