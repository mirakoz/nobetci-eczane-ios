## 2026-06-12 - Stable Identity for List Items
**Learning:** Using a computed property that returns `UUID()` for the `id` of an `Identifiable` model (like `District`) causes SwiftUI to treat every instance as unique on every render pass. This breaks identity tracking, leading to redundant view re-creations, loss of state, and broken animations in `List` or `ForEach`.
**Action:** Always use a stable, unique identifier from the data (like a slug, remote ID, or pre-assigned UUID) for the `id` property of `Identifiable` models to ensure efficient view diffing.
