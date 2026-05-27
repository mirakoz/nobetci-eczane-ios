## 2025-05-15 - Stable Identities in SwiftUI Models
**Learning:** Using computed properties that generate new identities (e.g., `var id: UUID { UUID() }`) for models used in SwiftUI `List` or `ForEach` is a major performance anti-pattern. It breaks SwiftUI's identity tracking, forcing the entire list to be re-rendered on any state change and breaking animations.
**Action:** Always use stable, unique properties (like a slug, ID from API, or a stored UUID) for the `id` property of `Identifiable` models in SwiftUI.
