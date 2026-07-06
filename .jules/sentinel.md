## 2026-06-03 - Hardcoded NosyAPI Key in Constants and Documentation
**Vulnerability:** The NosyAPI key was hardcoded in `NobetciEczane/Utilities/Constants.swift` and also exposed in `.skills/references/nobetci-eczane-nosyapi.md`.
**Learning:** Sensitive credentials can easily leak into source code and documentation if not managed by a dedicated configuration system or secret management tool.
**Prevention:** Use a `.plist` file for local development secrets that is excluded from version control via `.gitignore`. Provide a template `.example` file for other developers.

## 2024-05-15 - Locale-Sensitive String Sanitization (Turkish I Problem)
**Vulnerability:** The `slugified()` function previously called `.lowercased()` before mapping Turkish-specific characters like 'İ'. In certain system locales, `"İ".lowercased()` might not yield the expected 'i' (e.g., it might stay 'İ' or become 'ı'), leading to incorrect URL generation and potential API failures or cache inconsistencies.
**Learning:** String transformations that are critical for system logic (like URL generation or key mapping) must be locale-independent. General-purpose methods like `lowercased()` are sensitive to the environment's current locale.
**Prevention:** Perform explicit character mappings for locale-sensitive characters *before* applying general casing transformations, or use locale-agnostic APIs.
