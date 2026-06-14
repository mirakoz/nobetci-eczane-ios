## 2026-06-15 - Stable Identity in SwiftUI
**Learning:** Using a computed property that returns `UUID()` for a model's `id` (as required by `Identifiable`) is a major performance anti-pattern in SwiftUI. Since the `id` changes on every access, SwiftUI's diffing algorithm thinks every instance is new during every render pass, forcing complete list re-renders and causing UI flickering or loss of state.
**Action:** Always use stable identifiers from the data source (like a `slug` or `remoteID`) for the `id` property of `Identifiable` models used in SwiftUI collections.
