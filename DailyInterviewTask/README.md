# DailyInterviewTask

## Project Overview

DailyInterviewTask is a local-only SwiftUI iPhone app for learning common algorithm interview problems. Users can browse curated problems, read explanations and recommended solutions, bookmark useful questions, mark completed work, and track progress over time.

## Tech Stack

- Swift
- SwiftUI
- MVVM-style presentation layer
- Local JSON data loading with `Bundle.main`
- `UserDefaults` persistence for bookmarks and completion
- XCTest for basic unit coverage

## How to Run

1. Open `DailyInterviewTask.xcodeproj` in Xcode.
2. Select the `DailyInterviewTask` scheme.
3. Run on an iPhone simulator.

## Project Structure

- `DailyInterviewTask/Models`: Codable app models
- `DailyInterviewTask/Repositories`: JSON loading repository
- `DailyInterviewTask/Services`: UserDefaults-backed progress storage
- `DailyInterviewTask/ViewModels`: Home, detail, and progress view models
- `DailyInterviewTask/Views`: Main screens and app shell
- `DailyInterviewTask/Components`: Reusable UI components
- `DailyInterviewTask/Resources`: Local JSON problem database
- `DailyInterviewTaskTests`: Unit tests

## JSON File Location

Problem data lives in `DailyInterviewTask/Resources/questions.json`.

## How to Add New Problems

1. Open `DailyInterviewTask/Resources/questions.json`.
2. Add a new JSON object matching the `Question` schema.
3. Keep the `solution` payload aligned with `QuestionSolution`.
4. Rebuild the app.

No Swift code changes are required when only adding or editing problems.

## Local Persistence

The app stores completed and bookmarked question IDs in `UserDefaults`. That keeps the MVP offline, lightweight, and simple to evolve without introducing Core Data or a backend.

## Future Improvements

- Add topic and difficulty filters
- Add spaced-repetition review scheduling
- Support notes per problem
- Add search and sorting controls
- Add richer analytics and streak tracking
