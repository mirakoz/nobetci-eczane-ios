## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Static Data Optimization in SwiftUI
**Learning:** Computed properties or instance constants in SwiftUI View structs that perform sorting or contain large data sets are re-executed/re-allocated every time the view is initialized. In SwiftUI, views are value types and are frequently recreated.
**Action:** Move immutable data and expensive setup logic (like sorting a large list of cities) to 'static let' properties. Use 'Self.' to access them in the 'body'.
