## 2026-06-02 - Fixed Hardcoded API Key
**Vulnerability:** The NosyAPI key was hardcoded in `Constants.swift` and also present in the documentation file `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Hardcoding secrets is a common but high-risk practice that can lead to credential leakage if the code is shared or committed to a public repository. Documentation files can also inadvertently contain secrets.
**Prevention:** Always use a local configuration file (like `Secrets.plist`) that is excluded from version control via `.gitignore`. Provide a template file (like `Secrets.plist.example`) for other developers to use. Scrub all documentation of sensitive information.
