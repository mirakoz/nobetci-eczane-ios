## 2026-06-21 - Stable Identity in SwiftUI
**Learning:** Using `UUID()` as a computed property for a model's `id` in SwiftUI is a significant performance anti-pattern. It causes the view to lose its identity on every access, forcing redundant re-renders and potentially breaking animations or scroll state in Lists.
**Action:** Always prefer stable, unique identifiers from the data source (like a `slug` or `id` from the API) for the `Identifiable` protocol.

## 2026-06-21 - Immutable Static Data and Decoder Reuse
**Learning:** Reusing `JSONDecoder`/`JSONEncoder` instances and moving static UI data to `static let` properties in a utility class significantly reduces allocation overhead and CPU cycles on the main thread. SwiftUI views benefit from offloading data preparation (like sorting) to constants.
**Action:** Always check for redundant object initializations in hot paths (networking, caching) and move static data out of View structs to avoid recreation on re-renders.
