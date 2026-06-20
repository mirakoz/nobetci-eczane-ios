## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Efficient String Slugification in Swift
**Learning:** Chaining multiple `replacingOccurrences` calls on a string creates multiple intermediate string allocations, leading to O(M*N) complexity where M is the number of replacements and N is the string length. For Turkish character normalization and slugification, a single-pass O(n) algorithm using a static character map and `reserveCapacity` is significantly more efficient.
**Action:** Prefer single-pass character-by-character transformation with pre-allocated capacity for string sanitization and normalization tasks.
