## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Lazy Navigation and Static View Data
**Learning:** Eager instantiation of destination views in large SwiftUI Lists via `NavigationLink(destination:)` can lead to high memory usage and UI stutters. Modern `NavigationLink(value:)` paired with `.navigationDestination(for:)` ensures detail views are only created on demand. Additionally, heavy computations like sorting 80+ strings should be moved to `static let` if the data is immutable to avoid repeated work on view refreshes.
**Action:** Use value-based navigation for all lists and move constant data processing to static properties in View structs.
