
## 2026-06-05 - SwiftUI Identity and Static Data Optimization
**Learning:** Using computed UUIDs for Identifiable models (e.g., 'var id: UUID { UUID() }') in SwiftUI Lists triggers redundant view recreations and breaks identity tracking. Additionally, computing and sorting large static arrays within View structs leads to unnecessary CPU cycles and allocations on every view initialization.
**Action:** Always use stable identifiers (like slugs or remote IDs) for model identities. Centralize and pre-calculate static datasets (like city lists) in Constants or singletons using 'static let' to ensure O(1) access and zero re-computation cost.
