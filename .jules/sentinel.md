## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-03 - Robust URL Construction with URLComponents
**Vulnerability:** Manual string interpolation for API URLs is error-prone and can lead to malformed requests or potential injection if input is not perfectly sanitized.
**Learning:** Even with basic sanitization like slugification, using native APIs for URL construction provides a more robust and secure "defense in depth" layer.
**Prevention:** Always use 'URLComponents' and 'URLQueryItem' for constructing URLs with query parameters in Swift to ensure proper encoding and structure.
