## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Single-pass String Processing
**Learning:** Sequential `replacingOccurrences` and `filter` calls on `String` create multiple intermediate allocations and redundant full-string scans, leading to O(N * M) complexity. A single-pass `for-in` loop with a static character map and `reserveCapacity()` achieves O(N) performance with minimal memory overhead.
**Action:** Replace multi-pass string transformations with single-pass logic and pre-allocated buffers for performance-critical utilities like slugification or sanitization.
