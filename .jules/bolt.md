## 2026-05-23 - Static Data Allocation in SwiftUI Views
**Learning:** Initializing large arrays and performing computations (like sorting) inside a SwiftUI View's initializer or body can cause performance hitches because View structs are frequently recreated by the framework.
**Action:** Use `static let` for immutable data sets that are shared across all instances of a View. This ensures the data is allocated and processed once, then reused.

## 2026-05-23 - Unstable Identity in SwiftUI Models
**Learning:** Using a computed property like `var id: UUID { UUID() }` in a model conforming to `Identifiable` is a performance anti-pattern. It generates a new ID every time the property is accessed, which breaks SwiftUI's identity tracking and causes unnecessary view destructions and recreations in Lists or ForEach loops.
**Action:** Use stable identifiers from the data (like a slug or remote ID) for the `id` property of models used in SwiftUI collections.
