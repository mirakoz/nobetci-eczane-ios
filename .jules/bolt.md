## 2026-06-18 - Centralized Static Resources for SwiftUI Views
**Learning:** Hardcoding and sorting large arrays (like the 82-city list) inside SwiftUI Views or their computed properties causes redundant O(N log N) work on every view initialization, which can impact UI responsiveness during parent view updates.
**Action:** Move immutable datasets to `static let` constants in a centralized utility (e.g., `Constants.swift`) and pre-sort them to transition from O(N log N) runtime sorting to O(1) shared access.
