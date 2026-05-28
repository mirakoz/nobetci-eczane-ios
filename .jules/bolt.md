## 2025-05-15 - Offload CPU-intensive tasks from Main Actor
**Learning:** Performing distance calculations and sorting on a large list of items (like pharmacies) within a ViewModel method isolated to `@MainActor` can block the UI thread, leading to hitches and reduced responsiveness.
**Action:** Use `Task.detached` with an appropriate priority (e.g., `.userInitiated`) to move CPU-bound processing to a background thread, then await the result back on the Main Actor for UI updates.
