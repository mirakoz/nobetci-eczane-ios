
## 2026-06-15 - SwiftUI View Re-initialization Optimization
**Learning:** SwiftUI views are value types recreated frequently during render cycles. Performing data allocations or sorting within instance-level property initializers leads to redundant O(N log N) work.
**Action:** Centralize immutable datasets and expensive computations as 'static let' constants in a utility or constant file to ensure single-pass initialization and shared access.
