## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Optimized String Processing in Swift
**Learning:** Sequential calls to `replacingOccurrences` on a string in Swift are inefficient because each call traverses the entire string and allocates a new string object. For complex transformations like slugification, a single-pass O(N) loop with `reserveCapacity` is significantly more performant.
**Action:** Use a single-pass loop with a mapping dictionary and pre-allocate string capacity when performing multiple character replacements or filtering on a string.
