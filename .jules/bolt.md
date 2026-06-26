## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-22 - O(N) Slugification and Static View Data
**Learning:** Chaining multiple `replacingOccurrences` calls results in $O(M \times N)$ complexity and excessive intermediate string allocations. A single-pass character iteration is $O(N)$ and more efficient. Additionally, computed properties in SwiftUI views that perform sorting or complex logic are re-executed frequently; moving them to `static let` for immutable data prevents redundant work and allocations.
**Action:** Use single-pass iteration for string sanitization/slugification. Move immutable, expensive-to-compute data in Views to `static let` properties.
