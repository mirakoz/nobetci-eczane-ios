## 2026-05-20 - SwiftUI Identity & Offloading
**Learning:** Using computed 'UUID()' for Identifiable 'id' properties in SwiftUI models causes redundant view re-initializations because the identity changes on every access. Centralizing and pre-sorting large static datasets (like Turkish city lists) prevents redundant allocations in View structs.
**Action:** Use stable properties (like slugs or remote IDs) for 'id'. Move CPU-intensive processing (sorting, distance calculation) to 'Task.detached' to keep the Main Actor responsive.
