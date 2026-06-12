## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-21 - Enhanced Phone Number Sanitization with Whitelisting
**Vulnerability:** The previous phone number sanitization used a blacklist approach (removing spaces and dashes), which was incomplete and allowed potentially malicious or malformed characters to be passed to the `tel:` URL scheme.
**Learning:** Blacklisting is often insufficient for security. Whitelisting (allow-listing) only known good characters is a much more robust approach for input validation and sanitization.
**Prevention:** Use `filter` with an explicit allow-list (e.g., digits and '+') when preparing strings for sensitive operations like URL schemes or shell commands.
