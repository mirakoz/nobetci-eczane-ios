## 2025-05-14 - Hardcoded API Key Exposure
**Vulnerability:** The NosyAPI key was hardcoded directly in the `Constants.swift` file.
**Learning:** Hardcoding secrets in source code leads to credential exposure in version control systems.
**Prevention:** Use a `.plist` file (or environment variables) that is excluded from version control via `.gitignore` to store sensitive credentials, and provide a template for developers.
