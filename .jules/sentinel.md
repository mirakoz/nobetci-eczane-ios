## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-04 - Hardening PharmacyAPIService with URLComponents and Error Sanitization
**Vulnerability:** manual string interpolation for URL construction and leakage of internal API error messages.
**Learning:** URL string interpolation can lead to malformed URLs or injection vulnerabilities if inputs are not perfectly sanitized. Raw API error messages can expose internal system details to the end-user.
**Prevention:** Always use `URLComponents` and `URLQueryItem` for robust URL construction. Sanitize error messages in `LocalizedError` implementations to return generic descriptions for user-facing errors.
