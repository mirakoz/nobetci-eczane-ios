# Bolt's Journal ⚡

## 2026-05-12 - Initial Performance Audit
**Learning:** Identified multiple performance anti-patterns in the NobetciEczane codebase:
1. Redundant dictionary initialization in `String.slugified()`.
2. Unstable identities in SwiftUI Lists due to `UUID()` being used in a computed `id` property for `District`.
3. CPU-intensive sorting and distance calculations performed on the Main Actor in `PharmacyListViewModel`.
**Action:** Implement optimizations to address these issues, prioritizing stable identities and offloading heavy work from the main thread.
