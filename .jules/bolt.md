## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Efficient Data Structures in SwiftUI and String Processing
**Learning:** Computed properties in SwiftUI View structs that perform sorting or complex logic (like 'sortedCities') are re-executed frequently during re-renders. Moving these to 'static let' ensures they are computed once and stored globally. Additionally, single-pass string processing using 'reduce' and 'reserveCapacity' is significantly more efficient than multiple 'replacingOccurrences' calls.
**Action:** Always prefer 'static let' for immutable data in SwiftUI views and use single-pass algorithms for string transformations to minimize allocations and traversals.
