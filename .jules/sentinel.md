## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-03 - Fragile URL Construction and Weak Phone Sanitization
**Vulnerability:** URL parameters were built using string interpolation, and phone numbers were only partially sanitized.
**Learning:** Manual URL building is prone to injection and encoding issues. Basic string replacement for sanitization (e.g., removing spaces) often misses edge cases that could be exploited in URI schemes.
**Prevention:** Always use `URLComponents` and `URLQueryItem` for API requests. Use whitelist-based filtering (e.g., digits and '+') for phone number sanitization to ensure only safe characters are passed to `tel:` URLs.
