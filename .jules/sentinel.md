## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-03 - Insecure URL Construction and Weak Phone Sanitization
**Vulnerability:** Use of string interpolation for URL construction and incomplete sanitization of phone numbers in `tel:` URLs.
**Learning:** String interpolation for URLs can lead to malformed requests or injection if inputs aren't perfectly sanitized. Basic `replacingOccurrences` for phone numbers may miss dangerous characters (e.g., USSD codes).
**Prevention:** Always use `URLComponents` and `URLQueryItem` for robust parameter encoding. Use strict whitelists (e.g., `CharacterSet.decimalDigits`) for sanitizing inputs used in sensitive URI schemes like `tel:`.
