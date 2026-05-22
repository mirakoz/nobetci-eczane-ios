## 2024-12-16 - Hardcoded API Key in Source Code
**Vulnerability:** A critical API key for the NosyAPI service was found hardcoded in `NobetciEczane/Utilities/Constants.swift`.
**Learning:** Storing secrets in plain text within the codebase exposes them to anyone with access to the repository, increasing the risk of unauthorized use and potential financial or data impact.
**Prevention:** Always use environment variables or encrypted secret stores. For iOS development, use `.plist` files or `.xcconfig` files that are excluded from version control, or use a secure vault for CI/CD pipelines.
