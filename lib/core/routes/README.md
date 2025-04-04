# Brainy App Routing System

This directory contains the centralized routing system for the Brainy app. The `AppRouter` class provides a clean, type-safe, and maintainable way to handle navigation throughout the app.

## Key Features

- Centralized route definitions
- Type-safe navigation methods
- Custom transition animations
- Support for route parameters
- Path-based routing
- Navigation state management

## How to Use

### 1. Defining Routes

All routes are defined as static constants in the `AppRouter` class:

```dart
// Basic routes
static const String login = '/login';
static const String home = '/home';

// Routes with parameters (example)
static String wordDetailWithId(String id) => '/word/$id';
```

### 2. Basic Navigation

To navigate between screens, use the provided navigation methods:

```dart
// Push a new screen
AppRouter.navigateTo(context, AppRouter.home);

// Replace the current screen
AppRouter.navigateToReplacement(context, AppRouter.login);

// Clear the navigation stack and push a new screen (e.g., for logout)
AppRouter.navigateToAndClearStack(context, AppRouter.login);

// Go back to the previous screen
AppRouter.navigateBack(context);
```

### 3. Navigation with Parameters

You can pass parameters to routes in two ways:

#### A. Using the arguments parameter:

```dart
// Pass data as arguments
AppRouter.navigateTo(
  context, 
  AppRouter.wordDetail,
  arguments: {'wordId': 'example123'},
);

// Access in the destination view:
final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
final wordId = args['wordId'];
```

#### B. Using route parameters:

```dart
// Navigate to a parameterized route
AppRouter.navigateTo(context, AppRouter.wordDetailWithId('example123'));

// The route handler will extract the ID and pass it to the view
```

### 4. Custom Transitions

You can specify a custom transition animation for your navigation:

```dart
// Fade transition (default)
AppRouter.navigateTo(context, AppRouter.home);

// Slide from right
AppRouter.navigateTo(
  context, 
  AppRouter.home,
  transitionType: RouteTransitionType.slideRight,
);

// Slide up
AppRouter.navigateTo(
  context, 
  AppRouter.wordDetail,
  transitionType: RouteTransitionType.slideUp,
);

// No animation
AppRouter.navigateTo(
  context, 
  AppRouter.login,
  transitionType: RouteTransitionType.none,
);
```

## Adding New Routes

1. Define your new route constant in `AppRouter`
2. Add the route handler in the `generateRoute` method
3. Create your new view file
4. Use the navigation methods to navigate to your new route

## Best Practices

1. Always use the `AppRouter` constants for route names
2. Keep all route-related logic in the `AppRouter` class
3. Use type-safe navigation methods with proper generics
4. Consider appropriate transition animations for different navigation flows
5. Handle route parameters consistently
6. Document complex navigation flows

By using this routing system, you ensure a consistent navigation experience throughout the app while maintaining clean, maintainable code. 