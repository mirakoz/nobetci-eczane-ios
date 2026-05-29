## 2025-05-15 - Stable Identity in SwiftUI Models
**Learning:** Using a computed property that returns a new `UUID()` for a model's `id` (e.g., `var id: UUID { UUID() }`) is a performance anti-pattern in SwiftUI. It causes the view to treat the model as a completely new item on every state change or view re-initialization, breaking identity tracking and triggering redundant view updates or recreations.
**Action:** Always use a stable unique identifier from the data (like a slug or a remote ID) for the `id` property of `Identifiable` models used in SwiftUI.
