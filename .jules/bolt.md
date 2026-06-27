## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Immutable View Data as Static Constants
**Learning:** Performing expensive operations like array sorting (e.g., 80+ items) or redundant allocations in a SwiftUI View's initializer or computed properties can lead to significant frame drops, as these views are frequently re-initialized during state updates.
**Action:** Move immutable configuration data and pre-sorted lists to 'static let' properties to ensure they are computed once for the lifetime of the application.
