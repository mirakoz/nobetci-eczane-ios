## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-23 - O(n) String Transformation for Slugification
**Learning:** Chaining multiple `replacingOccurrences` calls on a string results in an O(M*N) complexity where M is the number of replacements and N is the string length. For frequently called transformation functions like slugification, a single-pass character iteration is significantly more efficient.
**Action:** Use a single-pass O(n) algorithm with a static mapping dictionary and `reserveCapacity` when performing complex string transformations.
