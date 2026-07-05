## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Static Data in SwiftUI Views
**Learning:** Initializing and sorting large arrays (e.g., 81 strings) within a SwiftUI View's initializer or as computed properties is a performance bottleneck. Since SwiftUI views are value types and are recreated frequently, these operations are repeated unnecessarily.
**Action:** Move immutable data and expensive setup logic (like sorting) to `static let` properties to ensure they are computed only once.
