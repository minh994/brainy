# Active Context

## Current Focus
We are enhancing the user experience and functionality of the Brainy Flutter app, with focus on:
1. Improving the Dictionary view with advanced filtering and part of speech visualization
2. Adding audio playback functionality for pronunciation
3. Creating a comprehensive Settings screen
4. Adding a Grammar feature with category and lesson views
5. Optimizing API integration with proper error handling

We've implemented a learning feature for vocabulary with the following components:

1. **Learn View** - Displays a list of words with "learning" status.
2. **Learning Mode Screen** - Interactive flashcard interface for learning words.
3. **Audio Integration** - Consistent audio playback across the app using a shared AudioService.

### Dictionary Feature Enhancements
- Optimizing the Dictionary view with paginated loading
- Implementing infinite scrolling for better performance with large word lists
- Using separate pagination controllers for different word statuses (all, learning, learned, skipped)
- Ensuring proper resource management for pagination controllers
- Integrating pagination with the existing search and filtering functionality

## Recent Changes
- Implemented a word status filtering system using an enum-based approach
- Added color-coded part of speech indicators (noun, verb, adjective) in the Dictionary view
- Created a Settings screen with theme, language, notification, and learning preferences
- Integrated the just_audio package for word pronunciation
- Developed a complete Grammar feature with categories, lessons, and markdown rendering
- Updated API response handling for nested JSON structures
- Improved filter chip UI with better visual feedback for active state
- Enhanced error handling with detailed logging
- Optimized the dictionary word item layout with cleaner design

## Active Decisions
- Using color-coding for parts of speech (POS):
  - Noun: Purple
  - Verb: Blue
  - Adjective: Green
  - Other parts of speech have distinct colors for quick identification

- Using WordStatus enum for standardization:
  - Provides type safety
  - Ensures consistent status names
  - Simplifies filtering logic

- Implementing separate API calls for status counts:
  - More network requests but better separation of concerns
  - Makes error handling more granular
  - Allows for independent updates of counts

- Using just_audio for pronunciation:
  - Cross-platform compatibility
  - Simple API
  - Support for streaming audio

- Settings design choices:
  - Organized by category (Appearance, Language, Sound, etc.)
  - Using shared_preferences for persistence
  - Immediate application of settings when changed

- Grammar feature implementation:
  - Using flutter_markdown for rendering lesson content
  - Styled tables and headers for better readability
  - Category-based organization with progress tracking
  - Responsive UI for both category and lesson displays

## Technical Debt
- Audio playback needs more robust error handling
- Need to add handling for network connectivity issues
- Potential optimization for API calls (batch requests)
- Need for comprehensive unit tests for view models
- Consider implementing more robust state management if needed
- Add caching for grammar lesson content to improve offline experience

## Key Implementation Details

### Learning Flow
- Users can view all their "learning" words in a LearnView
- A floating action button launches a bottom sheet with learning options
- Users can start either Flashcard or Quiz mode
- When learning is complete, a celebration screen appears

### UI Components Structure
We've broken down the Learning Mode UI into modular components:
- **FlashcardWidget** - Displays a word and its definition, switchable by tapping
- **CardSwiperWidget** - Handles card swiping with flutter_card_swiper
- **LearningControls** - Bottom control buttons for Skip, Flip, and Learned actions
- **CompletionScreen** - Appears when user completes all cards

### Interaction Patterns
- **Swipe left** to skip a word
- **Swipe right** to mark a word as learned
- **Tap** on card to flip between word and definition
- Bottom buttons provide alternative to swipe actions

### State Management
- LearnViewModel manages the list of learning words and audio playback
- Word status updates are persisted through the WordRepository
- Learning progress is maintained across app sessions

## Recent Learnings
1. **Component Separation**: Breaking down complex screens into smaller components improves maintainability.
2. **State Management**: Using proper state management patterns to track learning progress.
3. **User Experience**: Providing multiple interaction methods (swipe and buttons) enhances accessibility.
4. **Error Handling**: Gracefully handling edge cases when all cards are completed.

## Next Steps
1. Improve performance of the Dictionary view with virtualized lists
2. Add search history and favorites functionality
3. Implement word learning progress tracking
4. Create more interactive learning exercises
5. Enhance the Grammar feature with interactive exercises
6. Add offline mode with data caching
7. Enhance accessibility features
8. Implement user analytics to track learning progress
9. Implement Quiz Mode as an alternative learning approach
10. Add statistics tracking for learning progress
11. Consider spaced repetition algorithms for word review scheduling
12. Improve animations and transitions in the learning flow 