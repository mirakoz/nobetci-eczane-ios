## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.
