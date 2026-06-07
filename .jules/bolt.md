
## 2026-06-15 - Optimizing SwiftUI Model Identity and String Slugification
**Learning:** Using a computed 'UUID()' for an 'Identifiable' model's 'id' property in SwiftUI triggers redundant view recreations on every state change because the identity is never stable. Additionally, repeated 'replacingOccurrences' calls for string slugification leads to O(N*M) complexity and excessive allocations.
**Action:** Always use stable identifiers (like a slug or remote ID) for SwiftUI models. For string processing, use a single-pass loop with a static mapping dictionary and 'reserveCapacity' to achieve O(N) performance and minimize allocations.
