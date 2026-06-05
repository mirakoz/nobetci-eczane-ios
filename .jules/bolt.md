## 2026-06-12 - Stable Identity in SwiftUI Lists
**Learning:** Using a computed property that returns `UUID()` for the `id` of an `Identifiable` struct (like `District`) is a major performance anti-pattern in SwiftUI. Since the ID changes every time it is accessed, SwiftUI fails to track the identity of list items, leading to redundant view recreations, lost scroll position, and broken animations.
**Action:** Always use stable identifiers (like a slug or a server-provided ID) for the `id` property of `Identifiable` models used in SwiftUI Lists and ForEach loops.
