## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-03 - Insecure URL Construction and Information Leakage
**Vulnerability:** Use of string interpolation for URL construction and exposure of raw API/HTTP error details in the UI.
**Learning:** Manual URL construction is prone to injection if inputs aren't perfectly sanitized. Leaking raw error messages (like decoding errors or HTTP codes) can expose internal architectural details to potential attackers.
**Prevention:** Always use `URLComponents` and `URLQueryItem` for robust URL encoding (Defense-in-Depth). Sanitize user-facing error descriptions to provide generic messages while logging details internally.
