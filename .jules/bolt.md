## 2026-05-24 - Optimizing SwiftUI Identity and Static Data

**Learning:**
1. Using `UUID()` in a computed property for `id` in a struct conforming to `Identifiable` (like `District`) is a performance anti-pattern. It causes SwiftUI to lose track of the view's identity on every update, leading to redundant view recreations and potential loss of state (like scroll position).
2. Large immutable data structures (like the list of 81+ cities in `CityPickerSheet`) should be declared as `static let`. When declared as instance properties in a SwiftUI `View` struct, they are re-allocated (and in this case, re-sorted) every time the view is re-initialized, which happens frequently in SwiftUI's rendering lifecycle.

**Action:**
1. Always use stable identifiers (like a `slug` or `id` from the backend) for `Identifiable` models.
2. Move constant, expensive-to-initialize data to `static let` within SwiftUI views or to a separate constant provider.
