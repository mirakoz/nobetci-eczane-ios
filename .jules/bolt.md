## 2026-05-30 - Performance Audit
**Learning:** Found several performance anti-patterns:
1. `CityPickerSheet` re-sorts the entire Turkish city list on every initialization. Since it's used in a `.sheet` modifier, this happens whenever the parent view re-renders.
2. `String.slugified()` re-initializes a dictionary for Turkish character mapping on every call.
3. `PharmacyListViewModel.fetchForCity` performs distance calculation and sorting of the pharmacy list on the Main Actor, which can lead to UI hitches.

**Action:** Centralize immutable data like the city list in `Constants.swift` as `static let` to ensure single initialization and sorting. Offload heavy computations from the Main Actor.
