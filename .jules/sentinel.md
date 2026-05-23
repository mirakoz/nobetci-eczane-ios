## 2024-05-23 - Hardcoded API Key in Constants
**Vulnerability:** The `nosyAPIKey` was hardcoded directly in `NobetciEczane/Utilities/Constants.swift`.
**Learning:** Hardcoding secrets in source code leads to credential exposure when the code is committed to version control.
**Prevention:** Use a `Secrets.plist` file (excluded from git) to store sensitive keys and load them at runtime. Provide a template (`Secrets.plist.example`) for development setup.
