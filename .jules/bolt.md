## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Expensive Resource Initialization
**Learning:** `JSONDecoder` and `JSONEncoder` in Swift are relatively expensive to initialize. Creating them repeatedly in hot paths (like API calls or cache lookups) adds measurable latency and CPU overhead.
**Action:** Reuse persistent instances of `JSONDecoder` and `JSONEncoder` in services and singletons.

## 2026-06-21 - O(n) String Processing
**Learning:** Chaining `replacingOccurrences` on a `String` results in multiple full-string scans and intermediate allocations, leading to O(m*n) complexity.
**Action:** For multi-character mapping or sanitization, use a single-pass loop (O(n)) with `reserveCapacity` to minimize allocations.
