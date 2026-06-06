## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2026-06-03 - URL Scheme Injection via Unsanitized Phone Numbers
**Vulnerability:** Phone numbers were partially sanitized using a blacklist (`replacingOccurrences`), allowing potentially malicious characters (e.g., `;`, `#`) to be passed to the `tel:` URL scheme.
**Learning:** Blacklisting is brittle and often misses edge cases. Injected characters in a `tel:` URL can lead to unexpected behavior or exploit vulnerabilities in the system's telephony handler.
**Prevention:** Use strict whitelist-based filtering for all inputs that are used to construct URLs or passed to system-level handlers. For phone numbers, only allow digits and the `+` character.
