## 2025-05-27 - [CRITICAL] Remove hardcoded API key
**Vulnerability:** The NosyAPI key was hardcoded directly in `Constants.swift`, exposing it to anyone with access to the source code.
**Learning:** Hardcoding secrets is a common but dangerous shortcut. In SwiftUI/iOS apps, these should be offloaded to non-tracked Property Lists or Environment Variables.
**Prevention:** Use a `Secrets.plist` file that is excluded from Git via `.gitignore`, and provide a `Secrets.plist.example` for other developers. Load these secrets at runtime using `PropertyListSerialization`.
