## 2026-05-22 - Offloading CPU-intensive processing from Main Actor
**Learning:** Performing O(N) calculations (like distance) and O(N log N) sorting on the Main Actor in a ViewModel can cause UI hitches, especially as the number of items grows. SwiftUI views are also frequently re-initialized, so expensive operations in View properties should be minimized.
**Action:** Use `Task.detached` for background processing in ViewModels and `static let` for immutable sorted data in Views to ensure maximum responsiveness.
