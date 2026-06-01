## 2026-05-12 - Main Actor Offloading for Data Processing
**Learning:** In SwiftUI ViewModels marked with `@MainActor`, heavy data processing like distance calculations and sorting for large lists can cause UI hitches if performed directly on the Main Actor. Offloading these tasks to `Task.detached` prevents blocking the main thread.
**Action:** Capture required `@Published` properties as local constants before entering a detached task to ensure thread-safe access and avoid implicit Main Actor isolation within the background task.
