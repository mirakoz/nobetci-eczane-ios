## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Heavy Allocations in View Property Initializers
**Learning:** Defining large data structures (like an 80+ item array) or performing sorting logic directly within a SwiftUI View's property initializers or computed properties is a performance bottleneck. Since SwiftUI views are value types and are recreated frequently, this work is redundant and can cause stuttering during UI updates.
**Action:** Move static data and its associated processing to `static let` constants or a shared service to ensure it is computed once and cached.
