## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-22 - Efficient String Slugification
**Learning:** Chaining `replacingOccurrences` in a loop for character mapping is an O(M*N) operation (M mappings, N string length) and creates many intermediate string allocations. A single-pass O(N) loop with a character map is significantly more efficient.
**Action:** Use a single-pass loop with a dictionary for character substitutions and `reserveCapacity` to minimize reallocations when building strings from scratch.
