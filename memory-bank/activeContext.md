# Active Context

## Current Focus
We are implementing the MVVM architecture for the Brainy Flutter app. The main goals are:
1. Establish a clean, maintainable architecture
2. Create reusable base classes for views and view models
3. Setup proper dependency injection
4. Implement authentication flow with proper error handling

## Recent Changes
- Created `BaseViewModel` class to standardize view model behavior
- Created `BaseView` widget to manage the view/view model lifecycle
- Implemented `BusyIndicator` for consistent loading states
- Set up GetIt service locator for dependency injection
- Fixed shared_preferences implementation to prevent MissingPluginException
- Removed duplicate code and unified the services structure
- Added a username field to the signup form
- Refactored SignupView to use the BaseView pattern
- Created a dedicated SignupViewModel to handle registration logic
- Fixed authentication flow to redirect to login after successful signup (since API doesn't return tokens on signup)

## Active Decisions
- Using MVVM pattern over other architectures because:
  - Clear separation of UI and business logic
  - Testability of view models
  - Consistent state management
  - Reusability of components

- Using repository pattern for data access:
  - Abstracts data source implementation details
  - Allows for easier testing with mock data
  - Provides a clean interface for view models

- Implementing a service locator with GetIt:
  - Efficient dependency injection
  - Avoids passing dependencies through constructors
  - Provides both singletons and factory instances

- Signup flow redirect to login:
  - Current API design doesn't return auth tokens on signup
  - User must explicitly log in after registration
  - Shows a success dialog before redirecting to login

## Technical Debt
- Some duplicate service implementations (now cleaned up)
- Need to add comprehensive error handling
- Need to implement proper loading states in all views
- Should add unit tests for view models
- Consider implementing more robust state management if needed

## Next Steps
1. Complete the authentication flow
   - Add token refresh mechanism
   - Implement auto-login on app start
   - Add logout functionality with token invalidation

2. Create vocabulary feature
   - Implement vocabulary list view
   - Add vocabulary detail view
   - Connect to API endpoints

3. Enhance UI components
   - Standardize form fields
   - Create a consistent theme
   - Add animation transitions

4. Add unit and widget tests
   - Test view models
   - Test repositories
   - Test critical UI components 