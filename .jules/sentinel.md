## 2026-05-24 - [CRITICAL] Hardcoded API Secrets
**Vulnerability:** API keys were stored as static string literals in `Constants.swift`, making them visible to anyone with access to the source code and potentially leaking them via version control.
**Learning:** Hardcoding secrets is a common shortcut that bypasses secure configuration management. Even for public APIs, leaking keys can lead to quota exhaustion or unauthorized billing if the key is tied to a paid tier.
**Prevention:** Use property lists (.plist) or environment variables to store secrets, and ensure these files are excluded from version control via `.gitignore`. Provide a template file (e.g., `Secrets.plist.example`) for local development.
