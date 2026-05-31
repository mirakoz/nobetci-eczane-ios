## 2026-05-31 - Fix hardcoded API key
**Vulnerability:** The NosyAPI key was hardcoded in `Constants.swift` and also present in the documentation file `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Hardcoding secrets leads to credential leakage if the codebase is shared or committed to public repositories. Documentation can also inadvertently leak secrets.
**Prevention:** Use a dedicated secrets file (like `Secrets.plist`) that is excluded from version control via `.gitignore`. Provide a template (e.g., `Secrets.plist.example`) for other developers. Always scrub secrets from documentation.
