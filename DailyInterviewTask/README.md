# DailyInterviewTask

## Project Overview

DailyInterviewTask is a local-only SwiftUI iPhone study app focused on the full Blind 75 problem set. Users can review a daily recommendation, jump to a random next problem, browse the full catalog, switch between English and Chinese content on learning pages, compare optimal and alternative solutions, bookmark problems, mark them completed, and track progress by topic.

## Tech Stack

- Swift
- SwiftUI
- MVVM-style screen state
- Local JSON loading with `Bundle.main`
- `UserDefaults` persistence for bookmarks, completion, and language preference
- XCTest unit coverage

## How to Run

1. Open `DailyInterviewTask.xcodeproj` in Xcode.
2. Select the `DailyInterviewTask` scheme.
3. Run the app on an iPhone simulator or device.

## Project Structure

- `DailyInterviewTask/Models`: bilingual models, solutions, and topic progress types
- `DailyInterviewTask/Repositories`: local JSON repository
- `DailyInterviewTask/Services`: `UserDefaults` persistence and app settings
- `DailyInterviewTask/ViewModels`: Home, All Problems, Detail, and Progress state
- `DailyInterviewTask/Views`: tab shell and screen implementations
- `DailyInterviewTask/Components`: reusable cards, rows, code blocks, language toggle, and progress bars
- `DailyInterviewTask/Resources`: Blind 75 JSON dataset
- `DailyInterviewTaskTests`: unit tests

## JSON File Location

The full problem database lives in `DailyInterviewTask/Resources/questions.json`.

## How to Add or Update Problems

1. Edit `DailyInterviewTask/Resources/questions.json`.
2. Follow the `Question` schema, including bilingual text and multiple `solutions`.
3. Keep one solution marked with `isOptimal = true`.
4. Rebuild the app.

## Local Persistence

The app stores:

- completed problem IDs
- bookmarked problem IDs
- selected language

All persistence uses `UserDefaults`, keeping the app fully offline and lightweight.

## Future Improvements

- Topic-specific review queues and spaced repetition
- Richer search and difficulty filters
- Personalized study plans
- Per-problem notes and revision history
- Stronger automated validation for the JSON content
