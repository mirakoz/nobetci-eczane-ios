## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Static Constants for Immutable Data in SwiftUI
**Learning:** Initializing and sorting large immutable data structures (like city lists) as instance properties in SwiftUI `View` structs causes redundant allocations and processing on every view recreation. Since SwiftUI views are value types and recreated frequently, this can lead to measurable performance overhead.
**Action:** Move static, immutable data that doesn't depend on the view's state to `static let` properties to ensure they are initialized once and shared across all instances of the view.
