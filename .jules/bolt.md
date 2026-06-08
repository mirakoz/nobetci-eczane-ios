
## 2026-06-08 - Cache Consolidation and Coder Reuse
**Learning:** Performing two separate disk I/O operations (JSON and metadata) and two separate decoding steps for every cache access was a significant bottleneck. Consolidating into a single entry struct allows for O(1) disk access and a single pass of the decoder. Reusing static JSONEncoder/Decoder instances also avoids the overhead of repeated allocations in frequently called service methods.
**Action:** Always combine related data/metadata into a single Codable entry when caching to disk, and use static properties for shared Codable instances in service layers.
