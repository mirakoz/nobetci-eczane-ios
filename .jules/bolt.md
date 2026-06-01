## 2026-05-12 - Main Actor Offloading for Data Processing
**Learning:** In SwiftUI ViewModels marked with `@MainActor`, heavy data processing like distance calculations and sorting for large lists can cause UI hitches if performed directly on the Main Actor. Offloading these tasks to `Task.detached` prevents blocking the main thread.
**Action:** Capture required `@Published` properties as local constants before entering a detached task to ensure thread-safe access and avoid implicit Main Actor isolation within the background task.

## 2026-05-12 - Optimization of Immutable Data Structures
**Learning:** Large, immutable datasets (like Turkish city lists) and mapping dictionaries (for string normalization) should be centralized as `static let` members. This prevents redundant re-computation, sorting, and memory allocation during the frequent re-initializations of SwiftUI View structs or utility function calls.
**Action:** Move large constants and pre-sorted lists to `Constants.swift` or as `static let` within extensions to ensure they are computed only once.
