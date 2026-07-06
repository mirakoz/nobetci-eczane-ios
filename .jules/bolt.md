## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-07-06 - O(N) String Slugification
**Learning:** Chaining multiple `replacingOccurrences` calls on a string is an O(M*N) operation (M replacements, N string length) that creates many intermediate string allocations. A single-pass O(N) approach using a character mapping dictionary and `reserveCapacity` is significantly more efficient and avoids locale-sensitive issues with Turkish characters when mapping is done before lowercasing.
**Action:** Replace multiple string replacements with a single-pass loop and pre-allocated buffer when performing complex string sanitization or mapping.
