## 2024-05-15 - Offloading Main Actor computations
**Learning:** CPU-intensive operations like distance calculations and list sorting (O(N log N)) on data models can block the Main Actor, causing UI hitches and jank in SwiftUI applications, especially as the dataset grows.
**Action:** Use `Task.detached(priority: .userInitiated)` to move these computations to a background thread. Ensure that results are correctly awaited and that subsequent UI state updates occur back on the Main Actor.
